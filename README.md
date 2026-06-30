# kata-benchmarks

This repository is the canonical benchmark registry for Kata.

Kata uses this repo together with:

- `kata`: evaluation engine and submission logic
- `kata-bot`: GitHub orchestration and PR automation

It stores benchmark definitions and frontier state as versioned files so
repo-specific agent evaluation stays transparent, reviewable, and reproducible.

Current MVP scope:

- upstream SN74/Gittensor may contain many registered target repos
- Kata does not need to activate all of them on day one
- this registry currently exposes one active competition pack:
  - `e35ventura__taopedia-articles`

That means miners compete on one repo-pack first, and more packs can be added
later by adding benchmark content here and then extending the registry metadata.

## Purpose

This repo is for benchmark source-of-truth data:

- repo benchmark packs
- task definitions
- task validation scripts
- path-scope rules
- task weights
- frontier manifests
- baseline and frontier agent files

It is not for runtime logs or temporary eval artifacts. Kata writes those
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
    agents/
      contributor/
        baseline/
          agent.py
          agent_manifest.json
        frontier/
          agent.py
          agent_manifest.json
      reviewer/
        baseline/
          agent.py
          agent_manifest.json
        frontier/
          agent.py
          agent_manifest.json
```

The registry root is identified by
`kata-benchmark-registry.json`. Kata uses that marker to discover the
registry automatically or via `KATA_BENCHMARKS_ROOT`.

## Workflow

1. Add or update benchmark task folders under `benchmarks/<repo-pack>/`.
2. Keep `kata-benchmark-registry.json` aligned with the active lanes.
   For the MVP, `active_repo_packs` should stay limited to
   `e35ventura__taopedia-articles`.
3. Validate the pack from Kata:

```bash
cd ../kata
uv run python -m kata eval-pack validate --path <repo-pack>
```

4. Initialize frontier state when the pack is ready:

```bash
uv run python -m kata frontier init \
  --repo /path/to/target-repo \
  --eval-pack <repo-pack> \
  --mode contributor \
  --primary-task <task-id>
```

5. Commit benchmark changes in this registry repo.
6. Run evaluation or challenge flows from Kata against the same pack id.

## Rules

- Keep benchmark tasks pinned to real repo work and stable repo refs.
- Prefer explicit checks over subjective agent judgment.
- Review benchmark changes carefully because benchmark edits change what scores
  mean.
- Do not commit placeholder scaffold tasks as live benchmarks.
