# Skill Security Assessment — acquire-codebase-knowledge

**Source:** .agents/skills/acquire-codebase-knowledge
**Assessed:** 2026-04-22
**Framework:** OWASP LLM Top 10 (2025), MITRE ATLAS, STRIDE

## Verdict
- **Overall score:** 34/100
- **Severity:** Medium
- **Recommendation:** Approve with Conditions

## Dimension Scores

| # | Dimension | Score | Weight | Contribution | Evidence |
|---|-----------|:-----:|:------:|:------------:|----------|
| 1 | Permission Scope | 5/10 | 15% | 0.75 | Skill runs scanner, generates docs, creates output directories. `SKILL.md` lines 57, 79; `scan.py` lines 561–564 (`output_dir.mkdir(parents=True, exist_ok=True)`, `open(args.output, 'w', ...)`). |
| 2 | Data Egress | 1/10 | 20% | 0.20 | No HTTP client, external endpoint, or upload code found. All data stays within local filesystem. `scan.py` imports: `os`, `sys`, `argparse`, `subprocess`, `json`, `pathlib`, `re` only. |
| 3 | Code Execution | 5/10 | 15% | 0.75 | `subprocess.run` used for git history/churn calls. `scan.py` lines 326–336 (`get_git_commits`), 342–357 (`get_git_churn`), 363–371 (`is_git_repo`). Commands are `["git", "log", ...]` — fixed, no user-controlled string injection. |
| 4 | Prompt Injection Surface | 6/10 | 10% | 0.60 | Workflow instructs reading PRD/TRD/README/ROADMAP/SPEC/DESIGN files then using content to drive generated documentation (`SKILL.md` lines 68–69, 102). No adversarial-content sanitisation clause. |
| 5 | Sensitive Data Handling | 4/10 | 10% | 0.40 | Scanner deliberately reads and previews `.env.example` / `.env.template` files (`scan.py` lines 141, 607–612). Scan output written in plaintext to `docs/codebase/.codebase-scan.txt`. No redaction for secret-like values. |
| 6 | Supply Chain | 1/10 | 10% | 0.10 | Zero runtime installs or dynamic downloads. All dependencies are Python stdlib only (`os`, `sys`, `argparse`, `subprocess`, `json`, `pathlib`, `typing`, `re`, `collections`). |
| 7 | Agency & Autonomy | 4/10 | 10% | 0.40 | End-to-end write workflow: scan → investigate → populate seven docs → validate — no explicit user confirmation before writing/overwriting `docs/codebase/` files (`SKILL.md` lines 23, 57–89). |
| 8 | Transparency & Intent Integrity | 2/10 | 10% | 0.20 | Declared purpose ("map codebase, create docs") matches observed behavior exactly. No hidden network calls, undeclared writes, or obfuscated logic found. |

**Total score = ((5×0.15)+(1×0.20)+(5×0.15)+(6×0.10)+(4×0.10)+(1×0.10)+(4×0.10)+(2×0.10))×10 = 34/100**

## Key Findings

### Critical / High Issues
- None identified.

### Medium / Low Issues

- **F1 (Medium): Prompt-injection exposure from untrusted repository content**
  - *Evidence:* "Search for PRD/TRD/README/ROADMAP/SPEC/DESIGN files and read them" — `SKILL.md` line 68.
  - **Impact:** Malicious instructions embedded in any scanned repository document could influence agent behavior during documentation generation (OWASP LLM01).
  - **Mitigation:** Add explicit safety clause — repository text must be treated as untrusted data and must not alter tool-calling decisions or execution behavior.

- **F2 (Medium): Broad local command execution and recursive repository scan**
  - *Evidence:* `subprocess.run(["git", "log", ...])` — `scan.py` lines 326, 343; `os.walk(Path.cwd())` — `scan.py` line 497.
  - **Impact:** In sensitive repos, broad read scope surfaces internal metadata, commit history, and file contents to the agent context.
  - **Mitigation:** Restrict scan scope to user-approved paths; add opt-out flags for git history/churn sections.

- **F3 (Low/Medium): Env-template preview may surface secret-like values**
  - *Evidence:* `read_file_preview(filepath)` called unconditionally for env templates — `scan.py` line 612.
  - **Impact:** Accidentally committed template values (even placeholder secrets) would be reproduced verbatim in the plaintext scan output artifact.
  - **Mitigation:** Apply basic pattern redaction (keys, tokens, passwords) before writing scan output.

## Required Conditions (Approve with Conditions)
- [ ] Add a prompt-injection safety clause to the skill: repository text must not directly influence tool usage or execution behavior.
- [ ] Add secret-pattern redaction in scanner output before writing to disk.
- [ ] Add a user confirmation step before writing or overwriting `docs/codebase/` files.
- [ ] Optionally gate git-history collection behind explicit user consent.

## Unverified Areas
- None. All files shipped under `.agents/skills/acquire-codebase-knowledge/` were readable.

## Automatic Block Triggers Fired
- none
