// What the bar and its hover card show, as plain data. Pure: no Herdr imports.
import { timeLeft, shortLeft, level, pace, ago } from "./format.js";
import { isShown } from "./prefs.js";
import { PROVIDERS } from "../providers/index.js";

const STALE_AFTER = 15 * 60; // s

// brief fits the width of "100%": the percentage or, once a limit is used up, the
// time until it resets (what matters then). text adds the time when asked to.
export function segmentView(w, now, showResetTime = false) {
  if (w.resetsAt != null && w.resetsAt <= now) {
    return { id: w.id, short: w.short, text: "—", brief: "—", level: "ok", fill: 0, tick: null, expired: true };
  }
  const lv = level(w.percent);
  const left = w.resetsAt != null ? ` · ${timeLeft(w.resetsAt - now)}` : "";
  const spent = w.percent >= 100 && w.resetsAt != null;
  const brief = spent ? shortLeft(w.resetsAt - now) : `${w.percent}%`;
  return {
    id: w.id,
    short: w.short,
    text: showResetTime ? `${w.percent}%${left}` : brief,
    brief,
    level: lv,
    fill: Math.min(1, Math.max(0, w.percent / 100)),
    tick: pace(w, now)?.elapsed ?? null,
    expired: false,
  };
}

const cap = (s) => s.charAt(0).toUpperCase() + s.slice(1);

const VERDICT = { "on pace": "you're on pace", ahead: "you're using it up too fast", under: "you have room to spare" };

// What the tick means, in this limit's own numbers. No tick, nothing to explain.
function tickHint(percent, p) {
  if (!p) return null;
  return `Tick: ${Math.round(p.elapsed * 100)}% of the time has passed.\nYou've used ${percent}%, so ${VERDICT[p.verdict]}.`;
}

function cardRow(w, now) {
  if (w.resetsAt != null && w.resetsAt <= now) {
    return { id: w.id, long: w.long, percent: "—", level: "ok", fill: 0, tick: null, hint: null, left: "", detail: "reset, waiting for a new reading" };
  }
  const p = pace(w, now);
  return {
    id: w.id,
    long: w.long,
    percent: `${w.percent}%`,
    level: level(w.percent),
    fill: Math.min(1, Math.max(0, w.percent / 100)),
    tick: p?.elapsed ?? null,
    hint: tickHint(w.percent, p),
    left: w.resetsAt != null ? timeLeft(w.resetsAt - now) : "",
    detail: "",
  };
}

// The hover panel: everything known. What's hidden is hidden from the bar only.
export function cardModel(states, now, providers = PROVIDERS) {
  const groups = [];
  for (const p of providers) {
    const { report = null, lastGood = null, installed = null } = states[p.id] ?? {};
    if (installed === false) continue;
    const g = { providerId: p.id, name: p.name, icon: p.icon, plan: null, status: "loading…", failed: false, dim: false, age: null, rows: [] };
    if (report?.status === "ok") {
      g.plan = report.plan ? cap(report.plan) : null;
      g.status = `updated ${ago(report.observedAt, now)}`;
      g.dim = now - report.observedAt > STALE_AFTER;
      g.rows = report.windows.map((w) => cardRow(w, now));
    } else if (report) {
      g.status = report.message ?? report.status;
      g.failed = true;
      g.dim = true;
      g.age = lastGood ? `Last reading ${ago(lastGood.observedAt, now)}` : null;
      g.rows = (lastGood?.windows ?? []).map((w) => cardRow(w, now));
    }
    groups.push(g);
  }
  return { groups, empty: groups.length === 0 };
}

// The panel opens on limits: settings last only until it closes. It closes closeDelay
// after the pointer leaves, and nothing reports that, so it's worked out on the way back.
export function panelOnEnter(panel, leftAt, nowMs, closeDelay) {
  return leftAt != null && nowMs - leftAt > closeDelay ? "limits" : panel;
}

// ProviderState: { report: Report|null, lastGood: Report|null, installed: true|false|null }
export function barModel(states, prefs, now, providers = PROVIDERS) {
  const groups = [];
  for (const p of providers) {
    if (!isShown(prefs, p.id)) continue;
    const st = states[p.id] ?? { report: null, lastGood: null, installed: null };
    if (st.installed === false) continue;
    let mark = null;
    let source = st.report;
    if (!st.report) {
      mark = "…";
      source = null;
    } else if (st.report.status !== "ok") {
      mark = "!";
      source = st.lastGood;
    }
    const segments = (source?.windows ?? [])
      .filter((w) => isShown(prefs, p.id, w.id))
      .map((w) => segmentView(w, now, prefs.showResetTime));
    const dim = mark === "!" || (source != null && now - source.observedAt > STALE_AFTER);
    groups.push({ providerId: p.id, name: p.name, tag: p.tag ?? null, icon: p.icon, mark, dim, segments });
  }
  return { groups, empty: groups.length === 0 };
}

// Rough text widths at 11.8px (labels 10.5px): enough to pick a density, not to lay out.
const GROUP = 20 + 45; // icon + gaps + account tag
function segmentWidth(s, density) {
  const text = 7 * (density === 3 ? s.brief : s.text).length + 12;
  if (density >= 2) return text;
  const label = 8 + 6.5 * s.short.length;
  return density === 1 ? label + text : label + 30 + text;
}

export function modelWidth(model, density) {
  return model.groups.reduce((sum, g) => sum + GROUP + g.segments.reduce((a, s) => a + segmentWidth(s, density), 0), 0);
}

// 0 = label + bar + percent, 1 = no bars, 2 = no labels, 3 = no time on calm windows.
export function chooseDensity(model, widthPx, showBars = true) {
  for (const d of showBars ? [0, 1, 2, 3] : [1, 2, 3]) {
    if (modelWidth(model, d) <= widthPx) return d;
  }
  return 3;
}

// Every window any of these accounts has, each at its widest reading. All accounts
// use these columns, so the bar stays still between them and when a limit runs out.
export function widestSegments(accounts, showResetTime = false) {
  const widest = showResetTime ? "100% · 00h 00m" : "100%";
  const byId = new Map();
  for (const g of accounts) {
    for (const s of g.segments) {
      if (!byId.has(s.id)) byId.set(s.id, { ...s, text: widest, brief: widest, level: "ok", fill: 0, tick: null });
    }
  }
  return [...byId.values()];
}

// An account's readings in those columns; a window it doesn't have shows a dash.
export function alignSegments(segments, columns) {
  return columns.map((c) => segments.find((s) => s.id === c.id) ?? { ...c, text: "—", brief: "—" });
}
