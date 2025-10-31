#!/bin/bash
#
# ghorg-sync.sh - Sync all GitHub repositories for configured users/orgs
#
# This script runs ghorg reclone continuously every 2 minutes to keep all
# configured repositories up to date. It respects the GHORG_NO_CLEAN setting
# to avoid overwriting local changes.
#
# Run in background: nohup ./ghorg-sync.sh &
# Stop: pkill -f ghorg-sync.sh
#

set -e

GHORG_BIN="${HOME}/code/bin/ghorg"
LOG_DIR="${HOME}/.local/share/ghorg/logs"
SYNC_INTERVAL=120  # 2 minutes in seconds

# Ensure log directory exists
mkdir -p "${LOG_DIR}"

# Check if ghorg is installed
if [ ! -f "${GHORG_BIN}" ]; then
    echo "Error: ghorg not found at ${GHORG_BIN}"
    echo "Please install ghorg first: go install github.com/gabrie30/ghorg@latest"
    exit 1
fi

# Signal handler for graceful shutdown
trap 'echo "Received shutdown signal, exiting..."; exit 0' SIGINT SIGTERM

# Function to run a single sync
run_sync() {
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local log_file="${LOG_DIR}/sync-${timestamp}.log"

    echo "Starting ghorg sync at $(date)" | tee -a "${log_file}"
    echo "============================================" | tee -a "${log_file}"

    "${GHORG_BIN}" reclone --color=enabled 2>&1 | tee -a "${log_file}"

    echo "============================================" | tee -a "${log_file}"
    echo "Sync completed at $(date)" | tee -a "${log_file}"
    echo "Log saved to: ${log_file}"

    # Keep only the last 30 log files
    cd "${LOG_DIR}" && ls -t sync-*.log | tail -n +31 | xargs -r rm -- 2>/dev/null || true
}

echo "ghorg-sync daemon started at $(date)"
echo "Syncing every ${SYNC_INTERVAL} seconds (2 minutes)"
echo "Logs saved to: ${LOG_DIR}"
echo "Press Ctrl+C to stop"
echo ""

# Main loop
while true; do
    run_sync
    echo ""
    echo "Waiting ${SYNC_INTERVAL} seconds until next sync..."
    echo "Next sync scheduled for: $(date -d "+${SYNC_INTERVAL} seconds" 2>/dev/null || date -v+${SYNC_INTERVAL}S 2>/dev/null || echo "in 2 minutes")"
    echo ""
    sleep "${SYNC_INTERVAL}"
done
