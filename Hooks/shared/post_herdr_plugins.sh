#!/usr/bin/env bash
# Install the herdr plugins pinned in herdr-plugins.txt.
#
#   post_herdr_plugins.sh           install anything missing or at a different commit
#   post_herdr_plugins.sh --freeze  print a spec for the currently installed plugins
set -euo pipefail

spec="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/herdr-plugins.txt"

for cmd in herdr jq; do
  if ! command -v "$cmd" >/dev/null; then
    echo "herdr plugins: $cmd not found, skipping" >&2
    exit 0
  fi
done

# One "OWNER/REPO[/SUBDIR] COMMIT" line per installed GitHub plugin.
installed() {
  herdr plugin list --json 2>/dev/null |
    jq -r '.result.plugins[].source
      | select(.kind == "github")
      | "\(.owner)/\(.repo)\(if .subdir then "/" + .subdir else "" end) \(.resolved_commit)"' ||
    true
}

if [[ ${1:-} == --freeze ]]; then
  cat <<'EOF'
# herdr plugins, installed by post_herdr_plugins.sh on `tuckr set shared`.
#
# Format: OWNER/REPO[/SUBDIR] COMMIT
#
# To add or bump a plugin, edit this file and re-run the hook, or install it
# by hand with `herdr plugin install` and refresh the pins with:
#   Hooks/shared/post_herdr_plugins.sh --freeze > Hooks/shared/herdr-plugins.txt

EOF
  installed
  exit 0
fi

current="$(installed)"

while read -r source commit _; do
  [[ -z $source || $source == \#* ]] && continue
  if grep -qxF "$source $commit" <<<"$current"; then
    echo "herdr plugins: ok $source"
  else
    echo "herdr plugins: installing $source@$commit"
    # herdr 0.9.0 rejects flags placed before the source, despite its --help.
    herdr plugin install "$source" --ref "$commit" --yes
  fi
done <"$spec"
