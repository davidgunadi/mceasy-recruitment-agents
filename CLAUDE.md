# CV Screening Agent — McEasy Recruitment

## What this repo does

An AI-assisted CV screening system. A recruiter drops CVs into a job's `inbox/`
folder, runs a slash command, and gets back a ranked + grouped spreadsheet with
per-criterion explanations. Recruiter feedback flows back to improve the rubric
over time.

## Agent family

| File | Purpose | Recommended model |
|------|---------|------------------|
| `.claude/agents/rubric-builder.md` | Converts a raw Job Description into a structured, editable `rubric.md` | Opus |
| `.claude/agents/cv-screener.md` | Core engine — scores one CV against the rubric, emits a structured record | Sonnet |
| `.claude/agents/feedback-learner.md` | Reads a recruiter-corrected spreadsheet and updates rubric + examples | Opus |

## Skill (slash command)

`.claude/skills/screen-cv/SKILL.md` exposes three sub-commands:

```
/screen-cv setup              # Create a new job folder and build its rubric
/screen-cv <job-id>           # Screen everything in jobs/<job-id>/inbox/
/screen-cv feedback <job-id>  # Incorporate recruiter corrections from the spreadsheet
```

## Folder conventions

```
jobs/
  _TEMPLATE/          # Copied on setup — do not edit directly
  <job-id>/           # One folder per open position
    job-description.md
    rubric.md
    examples.md
    inbox/            # Drop CVs here (PDF or DOCX)
    processed/        # CVs moved here after screening

outputs/
  screening-<job-id>-<date>.xlsx
```

## Rules

- All generated files go to `./outputs/` — never the repo root.
- Job IDs are recruiter-chosen slugs (lowercase-hyphen), auto-suggested from the JD title.
- `setup` warns instead of overwriting an existing job ID.
- `screen` and `feedback` against a non-existent ID tell the recruiter to run `setup` first.
- The agent ranks and explains; **the recruiter decides**. Never auto-reject.
- CVs are personal data — keep everything local for the PoC. Define a retention rule before going to production (CDSO sign-off required).

## Scoring is deterministic — never grade by hand

- The cv-screener agent emits **raw judgments only**: must-have status, each
  nice-to-have's `raw` (0–3) + `weight`, and red flags. It must NOT output
  `tier` or `score_pct`.
- A script computes `score_pct` and `tier` so the same CV always lands in the
  same tier: `.claude/skills/screen-cv/score.py` (Python) and `score.ps1`
  (PowerShell). Run one of them in the SCREEN flow; never compute tier/% in chat.
  Fixed formula: `max = sum(weights) × 3`, `pct = achieved ÷ max × 100`.
  (History: hand-computed math once divided by the wrong max and bumped a
  candidate from Good fit to Best fit.)

## Runtime / environment

- **Do not assume Python or Node is installed.** Some dev machines have neither
  (only PowerShell). Provide a PowerShell path for any script the skill shells
  out to, and pick the runtime that exists at run time.
- Known gap: the DOCX-parsing step in `SKILL.md` still calls `pandoc`/`python3`
  and will fail on a Python-less machine. PDFs and `.txt` are unaffected.
  Convert it to a PowerShell fallback before relying on `.docx` intake.
