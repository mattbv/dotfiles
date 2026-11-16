import { claudeAccount } from "./claude.js";
import codex from "./codex.js";

// Order here is the order in the status bar and the settings popup.
// Plain `claude` (~/.claude) is the personal account. Other accounts are found at
// start: every ~/.claude-<name> folder with a .claude.json (the claude-* aliases set
// CLAUDE_CONFIG_DIR to those), labelled <name>.
export const PROVIDERS = [claudeAccount("claude", "personal", null), codex];

export const isClaude = (id) => id === "claude" || id.startsWith("claude-");

// names: folder names like ".claude-work". Adds the new ones before codex.
export function addClaudeAccounts(names) {
  for (const n of names) {
    const tag = n.replace(/^\.claude-/, "");
    const id = `claude-${tag}`;
    if (!tag || PROVIDERS.some((p) => p.id === id)) continue;
    PROVIDERS.splice(PROVIDERS.indexOf(codex), 0, claudeAccount(id, tag, `~/${n}`));
  }
}
