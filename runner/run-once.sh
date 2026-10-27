#!/usr/bin/env bash
set -uo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

compose=(docker compose --env-file .env -f docker-compose.yml)
status=0

"${compose[@]}" up --build --abort-on-container-exit --exit-code-from runner || status=$?
"${compose[@]}" down --remove-orphans || status=$?

exit "$status"