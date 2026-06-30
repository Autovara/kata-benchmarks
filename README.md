# kata-benchmarks

This repository is the public benchmark registry for Kata.

It stores the benchmark tasks that miners are allowed to see, plus the public
frontier manifest that describes the live public pool policy.

It does not store the current king agent code. The public king lives in the
`kata` repo under `kings/<repo-pack>/<mode>/`.

## Repo Split

The live system is meant to be split like this:

- public `kata`
  - miner PRs under `submissions/`
  - public current king under `kings/`
- public `kata-benchmarks`
  - public benchmark tasks
  - `frontier.json`
- private `kata-benchmarks-private`
  - hidden holdout tasks
  - `frontier.private.json`

GitHub cannot hide only one folder inside a public repo. If you want miners to
see public tasks and the current king, but not the hidden holdouts, you need a
separate private benchmark repo.

## What Lives Here

This public repo is the source of truth for visible benchmark data:

- repo benchmark packs
- public task definitions
- task validation scripts
- path-scope rules
- public pool metadata
- public `frontier.json`

The current king code does not belong here.

## Layout

```text
benchmarks/
  <repo-pack>/
    benchkit-pack.json
    <task-id>/
      task.md
      repo_ref.txt
      checks.sh
      rubric.md
      allowed_paths.txt
      forbidden_paths.txt
      benchkit.json
      task_weight.txt        # optional
    frontier.json
```

Private registry example:

```text
benchmarks/
  <repo-pack>/
    <private-task-id>/
      task.md
      repo_ref.txt
      checks.sh
      rubric.md
      allowed_paths.txt
      forbidden_paths.txt
      benchkit.json
      task_weight.txt        # optional
    frontier.private.json
```

The registry root is identified by `kata-benchmark-registry.json`.

## Current Live Policy

For the current Taopedia lane:

- `frontier.json` describes the public side
- public task selection is `random_live`
- `primary_task_count = 10`
- `frontier.private.json` describes the private side
- private holdout pool size is `10`

So each duel uses:

- `10` random public live tasks
- `10` fixed live private holdout tasks

Current promotion rule:

- public side:
  - candidate must score at least `king + 2`
- private side:
  - candidate must score at least `king`

## Workflow

1. Add or update public task folders under `benchmarks/<repo-pack>/`.
2. Keep `kata-benchmark-registry.json` aligned with the active repo-packs.
3. Keep `frontier.json` aligned with the intended live public pool policy.
4. Keep matching hidden holdout tasks and `frontier.private.json` in the
   private benchmark repo.
5. Validate the pack from `kata`.

Example:

```bash
cd ../kata
export KATA_BENCHMARKS_ROOT=../kata-benchmarks
export KATA_PRIVATE_BENCHMARKS_ROOT=../kata-benchmarks-private
uv run python -m kata eval-pack validate --path e35ventura__taopedia-articles
```

## Task Retirement

Do not expose a hidden task publicly just because one duel finished.

A private task should move public only after both are true:

- a newer hidden pool has already taken over
- no in-flight or future duel can still reference the old pool

That usually means:

1. maintainers rotate the private pool
2. the old hidden tasks become retired
3. only then may they be exported into the public side

## Rules

- keep benchmark tasks pinned to real repo work and stable repo refs
- prefer objective checks over subjective judging
- do not commit placeholder scaffold tasks as live benchmarks
- do not store current king code in this repo
