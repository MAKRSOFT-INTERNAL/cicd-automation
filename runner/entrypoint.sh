#!/usr/bin/env bash
set -euo pipefail

: "${REPO_URL:?Set REPO_URL in runner/.env}"
: "${RUNNER_TOKEN:?Set RUNNER_TOKEN in runner/.env}"

runner_name="${RUNNER_NAME:-docker-ephemeral}"
runner_labels="${RUNNER_LABELS:-docker-agent}"
runner_workdir="${RUNNER_WORKDIR:-_work}"

cleanup() {
  if [[ -f .runner ]]; then
    ./config.sh remove --unattended --token "$RUNNER_TOKEN" || true
  fi
}
trap cleanup EXIT

./config.sh \
  --unattended \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$runner_name" \
  --labels "$runner_labels" \
  --work "$runner_workdir" \
  --ephemeral \
  --disableupdate \
  --replace

./run.sh