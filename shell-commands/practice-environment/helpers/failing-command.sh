#!/usr/bin/env bash

# ============================================
# Failing Command Helper
# ============================================
# Purpose: Intentionally fails with specified exit code and message
# Usage: ./failing-command.sh [exit_code] [message]

EXIT_CODE="${1:-1}"
MESSAGE="${2:-Command failed}"

echo "ERROR: $MESSAGE" >&2
exit "$EXIT_CODE"
