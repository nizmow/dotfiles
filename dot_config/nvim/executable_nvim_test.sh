#!/usr/bin/env bash
set -euo pipefail

target="${1:-}"
wait_ms="${NVIM_CAPTURE_MS:-3000}"
if [[ $# -gt 0 ]]; then
  shift
fi

extra_args=()
for cmd in "$@"; do
  extra_args+=(+"$cmd")
done

rm -f nvim-output.log nvim.log nvim-capture.log

status=0
cmd=(env NVIM_DEBUG=1 NVIM_LOG_FILE="$PWD/nvim.log" nvim --headless)
if [[ -n "$target" ]]; then
  cmd+=("$target")
fi
if [[ ${#extra_args[@]} -gt 0 ]]; then
  for arg in "${extra_args[@]}"; do
    cmd+=("$arg")
  done
fi

"${cmd[@]}" \
  +'set nomore' \
  +"lua require('debug.validate').run()" \
  +"lua vim.defer_fn(function() vim.cmd('qall!') end, $wait_ms)" \
  > nvim-output.log 2>&1 || status=$?

for log in nvim-output.log nvim-capture.log nvim.log; do
  if [[ -s "$log" ]]; then
    printf '\n===== %s =====\n' "$log"
    cat "$log"
  fi
done

exit "$status"
