# Skill Security Assessment — acquire-codebase-knowledge

**Source:** .github/skills/acquire-codebase-knowledge
**Assessed:** 2026-04-24
**Framework:** OWASP LLM Top 10 (2025), MITRE ATLAS, STRIDE

## Verdict
- **Overall score:** 34/100
- **Severity:** Medium
- **Recommendation:** Approve with Conditions

## Dimension Scores

| # | Dimension | Score | Weight | Contribution | Evidence |
|---|-----------|:-----:|:------:|:------------:|----------|
| 1 | Permission Scope | 5/10 | 15% | 0.75 | Skill runs scanner and writes output docs. Evidence: `SKILL.md` lines 57-59 and 79; `scan.py` lines 561-564 (`output_dir.mkdir(...)`, `open(args.output, 'w', ...)`). |
| 2 | Data Egress | 1/10 | 20% | 0.20 | No HTTP/network libraries or endpoint usage in shipped code; imports are local/system only (`scan.py` lines 17-24). |
| 3 | Code Execution | 5/10 | 15% | 0.75 | `subprocess.run` executes fixed git commands for commit/churn discovery (`scan.py` lines 326-347, 363-368), with no shell interpolation. |
| 4 | Prompt Injection Surface | 6/10 | 10% | 0.60 | Workflow explicitly ingests repository intent docs (`SKILL.md` line 68) and uses them to guide output generation (`SKILL.md` line 102), with no explicit untrusted-content guardrail. |
| 5 | Sensitive Data Handling | 4/10 | 10% | 0.40 | Scanner reads and outputs env template previews directly (`scan.py` lines 141, 607-613) without pattern-based redaction. |
| 6 | Supply Chain | 1/10 | 10% | 0.10 | No runtime dependency installation, downloads, or remote code execution directives in skill artefacts. |
| 7 | Agency & Autonomy | 4/10 | 10% | 0.40 | Prescribed workflow writes seven docs automatically (`SKILL.md` lines 23, 79-87) and has no required user confirmation gate before writes. |
| 8 | Transparency & Intent Integrity | 2/10 | 10% | 0.20 | Declared purpose aligns with behavior across manifest and script; no hidden capabilities observed (`SKILL.md` lines 4, 21-23; `scan.py` lines 556-700). |

**Total score = ((5×0.15)+(1×0.20)+(5×0.15)+(6×0.10)+(4×0.10)+(1×0.10)+(4×0.10)+(2×0.10))×10 = 34/100**

## Key Findings

### Critical / High Issues
- None identified.

### Medium / Low Issues

- **F1 (Medium): Prompt-injection exposure from untrusted repository content**
  - *Evidence:* "Search for `PRD`, `TRD`, `README`, `ROADMAP`, `SPEC`, `DESIGN` files and read them" — `SKILL.md` line 68.
  - **Impact:** Malicious instructions embedded in any scanned repository document could influence agent behavior during documentation generation (OWASP LLM01).
  - **Mitigation:** Add explicit safety clause — repository text must be treated as untrusted data and must not alter tool-calling decisions or execution behavior.

- **F2 (Medium): Broad local command execution and recursive repository scan**
  - *Evidence:* `subprocess.run(["git", "log", ...])` — `scan.py` lines 326, 343; recursive traversal `os.walk(Path.cwd())` — `scan.py` lines 297 and 497.
  - **Impact:** In sensitive repos, broad read scope surfaces internal metadata, commit history, and file contents to the agent context.
  - **Mitigation:** Restrict scan scope to user-approved paths; add opt-out flags for git history/churn sections.

- **F3 (Low/Medium): Env-template preview may surface secret-like values**
  - *Evidence:* `read_file_preview(filepath)` called for env templates without redaction — `scan.py` lines 610-613.
  - **Impact:** Accidentally committed template values (even placeholder secrets) would be reproduced verbatim in the plaintext scan output artifact.
  - **Mitigation:** Apply basic pattern redaction (keys, tokens, passwords) before writing scan output.

## Required Conditions (Approve with Conditions)
- [ ] Add a prompt-injection safety clause to the skill: repository text must not directly influence tool usage or execution behavior.
- [ ] Add secret-pattern redaction in scanner output before writing to disk.
- [ ] Add a user confirmation step before writing or overwriting `docs/codebase/` files.
- [ ] Optionally gate git-history collection behind explicit user consent.

## Unverified Areas
- None. All files shipped under `.github/skills/acquire-codebase-knowledge/` were readable.

## Automatic Block Triggers Fired
- none
