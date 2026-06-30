#!/usr/bin/env bash
set -euo pipefail

target="content/pages/emission/index.mdx"

cleanup() {
  rm -rf node_modules
}

trap cleanup EXIT

test -f "$target"

grep -Fq 'Root Subnet is the exception' "$target"
grep -Fq 'Subnet Zero has no alpha currency' "$target"
grep -Fq 'staking stays TAO-denominated' "$target"
grep -Fq 'there is no subnet alpha distribution there' "$target"

npm ci --silent
npm run validate --silent
