---
description: "Use when enforcing consistency checks between C4 DSL, architecture documentation, ADRs, and workflow state before closing architecture updates."
applyTo: "docs/architecture/**"
---
You are enforcing the Architecture Consistency Gate for workflow closure.

## Purpose
- Ensure architecture artefacts agree with each other before closure.
- Prevent contradictions between diagrams, docs, ADRs, and workflow state.
- Reduce cognitive load by forcing unresolved inconsistencies into an explicit blocker list.

## Consistency Checks
- C4 Context, Container, and Component DSL must not contradict architecture documentation.
- Architecture documentation must not contradict ADR decisions, assumptions, or stated constraints.
- ADRs must not describe decisions that are absent or contradicted in the docs without explanation.
- `workflow-state.yaml` must accurately reflect current gate outcomes, blockers, and next handoff target.

## Closure Rule
- If any unexplained inconsistency remains, output `Consistency Gate: FAIL`.
- Only output `Consistency Gate: PASS` when artefacts agree or justified deviations are explicitly documented.

## Output Format
Return:
1. Consistency Gate: `PASS` or `FAIL`
2. Artefacts Checked
3. C4 vs Docs Findings
4. Docs vs ADR Findings
5. Workflow State Findings
6. Justified Deviations
7. Remediation Checklist: required when gate fails
8. Workflow Instruction: if `FAIL`, state that architecture workflow closure remains blocked

## Constraint
- Do not redesign the architecture.
- Only identify contradictions, unexplained mismatches, and missing justifications.