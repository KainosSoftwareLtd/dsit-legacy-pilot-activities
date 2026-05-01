# Skill Security Assessment — architecture-blueprint-generator

**Source:** .github/skills/architecture-blueprint-generator/SKILL.md  
**Assessed:** 2026-04-24  
**Framework:** OWASP LLM Top 10 (2025), MITRE ATLAS, STRIDE

## Verdict
- **Overall score:** 8.5/100
- **Severity:** Low
- **Recommendation:** Approve

## Dimension Scores

| # | Dimension | Score | Weight | Contribution | Evidence |
|---|-----------|:-----:|:------:|:------------:|----------|
| 1 | Permission Scope | 1/10 | 15% | 1.5 | Instruction-only manifest, no explicit tool/MCP calls; "Create a comprehensive ... document" ( .github/skills/architecture-blueprint-generator/SKILL.md:24 ) |
| 2 | Data Egress | 1/10 | 20% | 2.0 | No network execution instructions/endpoints; metadata URL is informational ( .github/skills/architecture-blueprint-generator/SKILL.md:6 ) |
| 3 | Code Execution | 0/10 | 15% | 0.0 | No scripts and no executable command content in package |
| 4 | Prompt Injection Surface | 3/10 | 10% | 3.0 | Broad repository-ingestion scope: "Analyze the project structure ... dependencies and import statements" ( .github/skills/architecture-blueprint-generator/SKILL.md:27 ) |
| 5 | Sensitive Data Handling | 1/10 | 10% | 1.0 | "Secret management approach" appears as documentation topic, not extraction/transmission behavior ( .github/skills/architecture-blueprint-generator/SKILL.md:124 ) |
| 6 | Supply Chain | 0/10 | 10% | 0.0 | No install/fetch/remote execution directives |
| 7 | Agency & Autonomy | 1/10 | 10% | 1.0 | Bounded output objective to generate architecture blueprint doc ( .github/skills/architecture-blueprint-generator/SKILL.md:24 ) |
| 8 | Transparency & Intent Integrity | 0/10 | 10% | 0.0 | Description aligns with generated prompt intent ( .github/skills/architecture-blueprint-generator/SKILL.md:2,24 ) |

## Key Findings

### Critical / High Issues
- none

### Medium / Low Issues
- **[F-01] Moderate prompt-ingestion surface** — *evidence*: "Analyze the project structure ... dependencies and import statements" ( .github/skills/architecture-blueprint-generator/SKILL.md:27 )
  - **Impact:** Malicious or misleading repository content could influence generated architectural guidance.
  - **Mitigation:** Add explicit instruction to treat repository content as untrusted and request user confirmation before high-impact recommendations.

## Required Conditions (if Approve with Conditions)
- Not applicable.

## Unverified Areas
- none

## Automatic Block Triggers Fired
- none
