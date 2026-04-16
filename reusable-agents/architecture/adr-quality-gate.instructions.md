---
description: "Use when enforcing ADR quality gate checks for ADR completeness, reciprocal link integrity, and ADR index consistency before closing architecture updates."
applyTo: "docs/architecture/**/adr/**/*.md"
---
You are enforcing the ADR Quality Gate for architecture workflow closure.

## Purpose
- Ensure ADR records are minimally complete.
- Ensure reciprocal links between ADRs and architecture documentation are intact.
- Prevent architecture workflow closure when ADR governance is incomplete.

## Minimum Required ADR Fields
Every ADR being created or updated must contain:
- Title
- Status
- Date
- Context
- Decision
- Options Considered
- Tradeoffs
- Consequences
- Evidence and References
- Related Architecture Sections
- Supersedes / Superseded By

## Link Integrity Checks
- Every impacted ADR must link to the relevant architecture document sections.
- Every impacted architecture document must link back to the relevant ADR IDs.
- `docs/architecture/<system-name>/adr/adr-index.md` must include each changed ADR.
- ADR status in `adr-index.md` must match the status inside the ADR file.

## Closure Rule
- If any required field is missing, output `Gate Status: FAIL`.
- If any reciprocal link is missing or inconsistent, output `Gate Status: FAIL`.
- If ADR index entries are missing or mismatched, output `Gate Status: FAIL`.
- Only output `Gate Status: PASS` when all checks succeed.

## Output Format
Return:
1. Gate Status: `PASS` or `FAIL`
2. ADRs Checked: list of ADR IDs or file names
3. Missing Fields: list or `none`
4. Link Integrity Findings: list or `none`
5. ADR Index Findings: list or `none`
6. Remediation Checklist: required when Gate Status is `FAIL`
7. Workflow Instruction: if `FAIL`, state that architecture workflow closure remains blocked

## Constraint
- Do not assess whether the decision itself is correct.
- Only assess minimum completeness and linkage integrity for workflow closure.