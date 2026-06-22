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
