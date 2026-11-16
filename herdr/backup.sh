#!/bin/sh
# Copies my own Herdr config here. Skips what Herdr ships and rewrites on every
# start (its layouts, mods, icons, AGENTS.md), plus logs, sockets and state.
# Run again any time to refresh. Restore = copy app/ and core/ back.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
app=${HERDR_APP_HOME:-$HOME/.config/herdr-app}
core=$HOME/.config/herdr

shipped_layouts="main terminals win98"
shipped_themes="atom-one-dark win98"
shipped_mods="agents changes confirm files help machine-add menu new-menu pane peek
picker prompt spaces tabs terminals-bar terminals-pane toast win98
workspace-chrome workspace-status worktree"

is_in() { case " $(echo $2) " in *" $1 "*) return 0 ;; esac; return 1; }

rm -rf "$here/app" "$here/core"
mkdir -p "$here/app/layouts" "$here/app/themes" "$here/app/mods" "$here/core"

for f in settings.json keys.json programs.json; do
  [ -f "$app/$f" ] && cp "$app/$f" "$here/app/"
done

for f in "$app"/layouts/*.json; do
  is_in "$(basename "$f" .json)" "$shipped_layouts" || cp "$f" "$here/app/layouts/"
done
for f in "$app"/themes/*.json; do
  is_in "$(basename "$f" .json)" "$shipped_themes" || cp "$f" "$here/app/themes/"
done
for d in "$app"/mods/*/; do
  m=$(basename "$d")
  is_in "$m" "$shipped_mods" || rsync -a --exclude test --exclude '*.d.ts' --exclude jsconfig.json "$d" "$here/app/mods/$m/"
done

[ -f "$core/config.toml" ] && cp "$core/config.toml" "$here/core/"

echo "herdr config backed up to $here"
