#!/usr/bin/env bash

# ============================================
# Slow Process Simulator
# ============================================
# Purpose: Simulates a long-running process with output
# Usage: ./slow-process.sh [duration_seconds]

DURATION="${1:-10}"

echo "Starting slow process (duration: ${DURATION}s)..."

for i in $(seq 1 "$DURATION"); do
    echo "[$i/$DURATION] Processing... ($(date +%H:%M:%S))"
    sleep 1
done

echo "Process completed successfully!"
