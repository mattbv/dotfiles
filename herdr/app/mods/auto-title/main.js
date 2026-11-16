// Auto title: names tabs that Herdr doesn't name well on its own.
//   shell tab  → the git branch, else the folder
//   other      → "program · folder" (nvim · my-repo)
//   agent tab  → left to Herdr: since 0.1.16 an unnamed agent tab follows its
//                session title live, and renaming it would stop that.
// A tab you rename yourself stays yours: we remember the names we set, and a
// tab whose name differs from ours was renamed by someone else. Clear its name
// (rename to empty) to hand it back.
// Runs as an invisible floating block: no programs, no network.
import { View } from "gpui-kit";
import { spaces, panes, run, shared, setShared, home } from "herdr";

const EVERY = 3000; // ms between checks
const MAX = 30;     // characters in a tab name
const OLD_KEY = "auto-title.owned"; // where the list used to live (shared state)

function loadOwned() {
  try {
    const v = JSON.parse(localStorage.getItem("owned") ?? "null");
    if (v && typeof v === "object" && !Array.isArray(v)) return v;
  } catch { /* fall through */ }
  const old = shared(OLD_KEY);
  return old && typeof old === "object" ? { ...old } : {};
}
function saveOwned(owned) {
  try { localStorage.setItem("owned", JSON.stringify(owned)); } catch { /* keep in memory */ }
}

function base(path) {
  if (!path) return "";
  const p = path.replace(/\/+$/, "");
  if (p === home()) return "~";
  return p.split("/").pop() ?? "";
}

function clip(s) {
  return s.length > MAX ? `${s.slice(0, MAX - 1).trimEnd()}…` : s;
}

const isAgent = (pane) => pane.status != null || pane.program?.agent;

function nameFor(pane) {
  if (!pane || pane.terminal == null || isAgent(pane)) return null;
  const folder = base(pane.cwd);
  if (pane.program?.shell) return clip(pane.branch || folder || pane.program.name);
  const prog = pane.program?.name ?? "";
  return clip(folder ? `${prog} · ${folder}` : prog) || null;
}

// The pane that speaks for a tab: its first agent, else its first terminal.
function paneFor(tabId, all) {
  const mine = all.filter((p) => p.tab === tabId && p.terminal != null);
  return mine.find(isAgent) ?? mine[0] ?? null;
}

export default class AutoTitle extends View {
  init(_props, cx) {
    this.owned = loadOwned();
    if (shared(OLD_KEY) != null) { saveOwned(this.owned); setShared(OLD_KEY, null); }
    this.sync();
    cx.timer.every(EVERY, () => this.sync());
  }

  sync() {
    const owned = this.owned;
    const all = panes();
    const live = new Set();
    let changed = false;
    for (const space of spaces()) {
      for (const tab of space.tabs ?? []) {
        live.add(tab.id);
        const ours = tab.id in owned;
        if (tab.named && owned[tab.id] !== tab.name) {
          // Someone else named it: hands off.
          if (ours) { delete owned[tab.id]; changed = true; }
          continue;
        }
        const pane = paneFor(tab.id, all);
        if (pane && isAgent(pane)) {
          // Herdr names agent tabs live; give back one we named earlier.
          if (ours) { run("tab.rename", { id: tab.id, name: "" }); delete owned[tab.id]; changed = true; }
          continue;
        }
        const name = nameFor(pane);
        if (!name || name === tab.name) continue;
        run("tab.rename", { id: tab.id, name });
        owned[tab.id] = name;
        changed = true;
      }
    }
    for (const id of Object.keys(owned)) {
      if (!live.has(id)) { delete owned[id]; changed = true; }
    }
    if (changed) saveOwned(owned);
  }

  render() {
    return ""; // nothing to show
  }
}
