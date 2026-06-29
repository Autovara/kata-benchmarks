# promptforge-benchmarks

This repository is the canonical benchmark registry for PromptForge.

PromptForge uses this repo together with:

- `PromptForge`: evaluation engine and submission logic
- `promptforge-bot`: GitHub orchestration and PR automation

It stores benchmark definitions and frontier state as versioned files so prompt
evaluation stays transparent, reviewable, and reproducible.

## Purpose

This repo is for benchmark source-of-truth data:

- repo benchmark packs
- task definitions
- task validation scripts
- path-scope rules
- task weights
- frontier manifests
- baseline and frontier prompt files

It is not for runtime logs or temporary eval artifacts. PromptForge writes those
to `runs/` in the evaluator workspace.

## Layout

```text
benchmarks/
  <repo-pack>/
    <task-id>/
      task.md
      repo_ref.txt
      checks.sh
      rubric.md
      allowed_paths.txt
      forbidden_paths.txt
      task_weight.txt        # optional
    frontier.json
    prompts/
      contributor/
        baseline.md
        frontier.md
      reviewer/
        baseline.md
        frontier.md
```

The registry root is identified by
`promptforge-benchmark-registry.json`. PromptForge uses that marker to discover
the registry automatically or via `PROMPTFORGE_BENCHMARKS_ROOT`.

## Workflow

1. Add or update benchmark task folders under `benchmarks/<repo-pack>/`.
2. Validate the pack from PromptForge:

```bash
cd ../PromptForge
uv run python -m promptforge eval-pack validate --path <repo-pack>
```

3. Initialize frontier state when the pack is ready:

```bash
uv run python -m promptforge frontier init \
  --repo /path/to/target-repo \
  --eval-pack <repo-pack> \
  --mode contributor \
  --primary-task <task-id>
```

4. Commit benchmark changes in this registry repo.
5. Run evaluation or challenge flows from PromptForge against the same pack id.

## Rules

- Keep benchmark tasks pinned to real repo work and stable repo refs.
- Prefer explicit checks over subjective prompt judgment.
- Review benchmark changes carefully because benchmark edits change what scores
  mean.
- Do not commit placeholder scaffold tasks as live benchmarks.
