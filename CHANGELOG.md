# Changelog

All notable changes to this repo are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Scope: version numbers track functional changes only — the `.claude/agents/*`,
`.claude/skills/**` (including `score.py`/`score.ps1`), `jobs/_TEMPLATE/**`, and
the rules in `CLAUDE.md`. Per-job data (`jobs/<id>/rubric.md`,
`job-description.md`, CVs, `outputs/*.xlsx`), README wording, and repo
housekeeping (`.gitignore`, etc.) are not versioned.

## [Unreleased]

## [1.0.0] - 2026-07-06

### Added
- `rubric-builder`, `cv-screener`, and `feedback-learner` agents forming the
  screening pipeline, plus the `/screen-cv` skill (`setup`, `<job-id>`,
  `feedback <job-id>` sub-commands).
- `jobs/_TEMPLATE/` scaffold (job description, rubric, examples, inbox,
  processed) copied on every `setup`.
- Deterministic scoring: `cv-screener` emits raw judgments only (must-have
  status, nice-to-have raw scores + weights, red flags); `score.py` /
  `score.ps1` compute `score_pct` and `tier` from a fixed formula
  (`max = sum(weights) × 3`, `pct = achieved ÷ max × 100`) so tier/%% is never
  hand-computed in chat.
- CLAUDE.md rules covering folder conventions, the deterministic-scoring
  requirement, and the "agent ranks and explains, recruiter decides" policy.

### Changed
- Rebalanced `cv-screener` scoring algorithm and reworked `rubric-builder`
  output structure for clearer must-have/nice-to-have separation.
- Set recommended models per agent (Opus for `rubric-builder` and
  `feedback-learner`, Sonnet for `cv-screener`).

### Known issues
- DOCX intake in `SKILL.md` still shells out to `pandoc`/`python3` and will
  fail on a Python-less machine; PDFs and `.txt` are unaffected. Needs a
  PowerShell fallback before `.docx` intake can be relied on.
