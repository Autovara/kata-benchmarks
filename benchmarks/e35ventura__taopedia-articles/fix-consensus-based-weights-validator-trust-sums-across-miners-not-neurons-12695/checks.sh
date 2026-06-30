#!/usr/bin/env bash
set -euo pipefail

# Run objective repo checks for this benchmark task.
npm run format:check
npm run validate
