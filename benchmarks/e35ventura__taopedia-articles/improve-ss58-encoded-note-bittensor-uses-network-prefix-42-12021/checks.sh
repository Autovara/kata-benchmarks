#!/usr/bin/env bash
set -euo pipefail

# Run objective repo checks for this benchmark task.
npm run format:check
npm run validate

# Run deterministic task-specific oracle checks.
python -m kata.oracle verify --workspace "$KATA_WORKSPACE" --task-dir "$KATA_EVAL_TASK_DIR" --score-file "$KATA_SCORE_FILE"
