#!/usr/bin/env bash
set -euo pipefail

target="content/pages/alpha_distribution_ratio/index.mdx"

cleanup() {
  rm -rf node_modules
}

trap cleanup EXIT

test -f "$target"

grep -Fq '## Halving Index Input' "$target"
grep -Fq '`2^(k - n)`' "$target"
grep -Fq 'global TAO halving index' "$target"
grep -Fq "subnet's alpha halving index" "$target"

npm ci --silent
npm run validate --silent
