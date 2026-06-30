#!/usr/bin/env bash
set -euo pipefail

# Run objective repo checks for this benchmark task.
npm ci
npm run validate
rg -q 'ADR follows the formula 2\^\(k - n\) under the current halving documentation\.' content/pages/alpha_distribution_ratio/index.mdx
