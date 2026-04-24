# Skill Security Assessment — refactor

**Source:** .github/skills/refactor/SKILL.md  
**Assessed:** 2026-04-24  
**Framework:** OWASP LLM Top 10 (2025), MITRE ATLAS, STRIDE

## Verdict
- **Overall score:** 14.5/100
- **Severity:** Low
- **Recommendation:** Approve

## Dimension Scores

| # | Dimension | Score | Weight | Contribution | Evidence |
|---|-----------|:-----:|:------:|:------------:|----------|
| 1 | Permission Scope | 4/10 | 15% | 6.0 | Refactoring skill modifies code structure and symbols across the codebase; "Surgical code refactoring..." (.github/skills/refactor/SKILL.md:2) and operation list (.github/skills/refactor/SKILL.md:631). |
| 2 | Data Egress | 0/10 | 20% | 0.0 | No network calls, endpoints, or webhook instructions in manifest content. |
| 3 | Code Execution | 1/10 | 15% | 1.5 | No scripts or executable command directives; guidance/examples only. |
| 4 | Prompt Injection Surface | 2/10 | 10% | 2.0 | Repository code ingestion is implied by refactoring workflow, but no web/third-party content ingestion instructions (.github/skills/refactor/SKILL.md:15). |
| 5 | Sensitive Data Handling | 2/10 | 10% | 2.0 | Refactoring may touch files containing sensitive data, but no explicit secret collection/transmission behavior is defined. |
| 6 | Supply Chain | 0/10 | 10% | 0.0 | No dependency install/fetch/dynamic download instructions. |
| 7 | Agency & Autonomy | 2/10 | 10% | 2.0 | Process encourages small steps and test gates, reducing autonomous blast radius (.github/skills/refactor/SKILL.md:33,567). |
| 8 | Transparency & Intent Integrity | 1/10 | 10% | 1.0 | Description and body align on maintainability-focused refactoring intent (.github/skills/refactor/SKILL.md:2,15). |

## Key Findings

### Critical / High Issues
- none

### Medium / Low Issues
- **[F-01] Broad write capability by design** — *evidence*: operation set includes extract/inline/rename/push-down/pull-up refactor actions (.github/skills/refactor/SKILL.md:631)
  - **Impact:** Misapplied changes can introduce regressions while appearing structural.
  - **Mitigation:** Keep mandatory tests and small-step commits per documented process.

- **[F-02] Example literal misuse risk** — *evidence*: sample code includes hardcoded illustrative values such as passwords (.github/skills/refactor/SKILL.md:168)
  - **Impact:** Users may copy insecure placeholders into production code.
  - **Mitigation:** Add explicit note that examples are non-production placeholders.

## Required Conditions (if Approve with Conditions)
- Not applicable.

## Unverified Areas
- none

## Automatic Block Triggers Fired
- none
