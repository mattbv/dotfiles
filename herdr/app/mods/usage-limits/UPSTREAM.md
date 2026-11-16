# usage-limits (local, modified)

Based on github.com/nozikov/herdr-usage-limits at commit 19fda91 (2026-11-09), MIT
(see LICENSE). These changes are not contributed upstream on purpose; this copy
lives in the dotfiles repo.

Local changes:
- One provider per Claude account: plain `claude` (~/.claude) is "personal", and every
  ~/.claude-<name> folder with a .claude.json is found at start as "<name>"
  (providers/index.js, providers/claude.js, helpers/claude-usage.sh takes the
  account's CLAUDE_CONFIG_DIR as $1).
- helpers/session.sh finds a session in whichever ~/.claude* folder owns the pid.
- The bar shows one Claude account at a time, rotating every 6 s (paused on hover,
  click to skip), with position dots (main.js).
- Fixed widths: the account label is as wide as the longest name, percents have a
  minimum width, so the bar doesn't shift (main.js, lib/view.js).

Upstream has since been restructured (ui/, io/) and added OpenCode and Pi; updating
means porting the changes above onto the new layout.
