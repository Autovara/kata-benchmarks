#!/usr/bin/env bash
set -euo pipefail

# Run objective repo checks for this benchmark task.
npm ci
npm run validate
rg -q 'a subnet with emission disabled receives a zero share and its portion is redistributed proportionally to the remaining emission-enabled subnets' content/pages/emission/index.mdx
