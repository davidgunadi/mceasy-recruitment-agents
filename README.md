# McEasy CV Screening Agents

AI-assisted CV screening built on Claude Code's agent + skill pattern. A recruiter drops CVs into a folder, runs one command, and gets a ranked spreadsheet with per-criterion explanations. Recruiter feedback flows back to improve scoring over time.

## How it works

```
Recruiter pastes JD → rubric-builder generates rubric.md
Recruiter drops CVs in inbox/ → cv-screener scores each one
Output: ranked .xlsx with tier, score, strengths, gaps
Recruiter corrects tiers → feedback-learner updates rubric + examples
```

The screening logic lives in transparent, version-controlled rubric files — not a black box. Every tier decision is explainable and auditable.

## Installation

You only need to do this once. Choose whichever method is easier for you.

---

### Option A — Download as ZIP (no coding tools needed)

1. Go to the repository page in your browser.
2. Click the green **Code** button near the top right.
3. Click **Download ZIP**.
4. Once downloaded, find the ZIP file in your **Downloads** folder and double-click it to unzip. You will get a folder called something like `mceasy-recruitment-agents-main`.
5. Move that folder somewhere easy to find, for example your **Desktop** or **Documents**.

---

### Option B — Clone with Git

Use this if you have Git installed and want to receive future updates easily.

**On Mac:**

1. Open **Terminal** (press `Cmd + Space`, type `Terminal`, press Enter).
2. Run this command (paste it and press Enter):
   ```
   git clone https://github.com/mceasy/mceasy-recruitment-agents.git
   ```
3. A folder called `mceasy-recruitment-agents` will appear in your home directory.

**On Windows:**

1. Open **PowerShell** (press the Windows key, type `PowerShell`, press Enter).
2. Run this command:
   ```
   git clone https://github.com/mceasy/mceasy-recruitment-agents.git
   ```
3. A folder called `mceasy-recruitment-agents` will appear in your user folder.

> **Don't have Git?** Download it from [git-scm.com](https://git-scm.com/downloads) and install it first, then repeat the steps above.

---

### After installing

1. Open **Claude Code** (the desktop app).
2. Click **Open Folder** (or `File → Open Folder`) and select the `mceasy-recruitment-agents` folder you just downloaded or cloned.
3. That's it — the slash commands (`/screen-cv setup`, etc.) are now available in Claude Code's chat input.

---

## Quick start

**New position:**
```
/screen-cv setup
```
Paste the JD when prompted, confirm the suggested job ID, then review the generated `rubric.md` before first use.

**Screen CVs:**
```
/screen-cv <job-id>
```
Drop PDF or DOCX files in `jobs/<job-id>/inbox/` first.

**Apply recruiter feedback:**
```
/screen-cv feedback <job-id>
```
Fill in `Recruiter override tier` and `Recruiter feedback` columns in the spreadsheet, then run this.

## Agents

| Agent | Model | Role |
|-------|-------|------|
| `rubric-builder` | Opus | Converts a raw JD into a structured `rubric.md` |
| `cv-screener` | Sonnet | Scores one CV against the rubric; emits a JSON record |
| `feedback-learner` | Opus | Diffs recruiter corrections vs agent tiers; updates rubric + examples |

## Folder structure

```
.claude/
  agents/
    rubric-builder.md
    cv-screener.md
    feedback-learner.md
  skills/
    screen-cv/SKILL.md

jobs/
  _TEMPLATE/              # Starter — copied on each setup, do not edit
  <job-id>/
    job-description.md    # Raw JD
    rubric.md             # Scoring rubric (agent-generated, recruiter-edited)
    examples.md           # Calibration examples (appended by feedback loop)
    inbox/                # Drop CVs here
    processed/            # CVs move here after screening

outputs/
  screening-<job-id>-<date>.xlsx
```

## Fit tiers

| Tier | Meaning |
|------|---------|
| Best fit | All must-haves met, high nice-to-have score, no red flags |
| Good fit | All must-haves met, moderate score |
| Moderate fit | 1 must-have missing or several gaps — worth a skim |
| Not a fit | Multiple must-haves missing or a hard red flag |

**The agent ranks and explains. The recruiter decides.** Tiers are never auto-rejections.

## Requirements

- Claude Code with access to this repo
- PDF/DOCX conversion: `pandoc` or `python-docx` for DOCX files (`pip install python-docx`)

## Privacy & compliance

CVs are personal data. For the PoC:
- Keep everything local — do not sync `inbox/` or `processed/` to cloud storage
- Retain `processed/` files until the position closes + 30 days (or per HR policy)
- CDSO sign-off required before moving beyond PoC
- Anonymization option (strip name/photo/age before scoring) is available on request
