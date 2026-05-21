# Legacy Migration Agents

This folder contains the agent workflow for controlled legacy migration planning and execution.

## Current Behavior

The workflow is orchestrated by [migration-orchestrator.agent.md](migration-orchestrator.agent.md) and currently follows these phases:

1. Discover
2. Target intent
3. Test baseline
4. Planning
5. Execution
6. Evaluate

Each phase is gated by persisted artefacts under `.github/migrations/<migration-id>/...`. The orchestrator uses those artefacts, not chat state, as the source of truth.

## Execution Modes

Execution mode is set after baseline testing:

- `AUTONOMOUS`: allowed only when `baseline-evidence.md` records `autonomy-verdict: HIGH`
- `SUPERVISED`: required when the verdict is `MEDIUM` or `LOW`

In `AUTONOMOUS` mode, the orchestrator auto-proceeds after a slice passes the PR quality gate.

In `SUPERVISED` mode, each passing slice waits for human merge confirmation.

`AUTONOMOUS` execution can still pause when one of these occurs:

- Greenfield/create-from-scratch approval is required
- Slice scope or acceptance criteria materially change
- A blocker or blocked status transition is raised

When those exceptions are resolved, execution resumes from the last successful slice or gate unless `execution_mode` is explicitly changed in `state.yaml`.

## Human Gates

The current workflow keeps humans in the loop only for high-impact decisions:

- Current-state accuracy confirmation in Discover
- Strategic target-state decision approval in Target intent
- Greenfield approval in Planning
- Explicit risk acceptance for deferred E2E gaps
- Per-slice merge decisions in `SUPERVISED` mode
- Drift-learning approval for policy or agent-definition changes

Objective completeness checks now replace several former blanket approvals:

- Technical preferences are checked for completeness rather than requiring generic sign-off
- Slice plans can auto-advance when acceptance criteria, dependencies, rollback posture, and verification methods are complete
- E2E readiness can advance without extra approval when verification is complete and passing

## Evidence Contract

Agents that execute or verify work are expected to persist command-level evidence. The current standard is:

- exact command
- exit code
- execution timestamp
- pass/fail summary
- classification of failures when non-zero

This applies to baseline verification, E2E remediation, slice implementation, OpenRewrite execution, and PR quality gating.

Checkpoint blocks now fall into two categories:

- `verification_evidence_summary`: for agents that execute or verify commands
- `evidence_basis_summary` or `planning_evidence_summary`: for agents that synthesize or validate non-executable planning/state artefacts

## Agent Responsibilities

- [legacy-system-analyst.agent.md](legacy-system-analyst.agent.md): documents current state without changing code or inferring behavior
- [target-architecture-intent.agent.md](target-architecture-intent.agent.md): defines target state, constraints, ADRs, NFRs, and technical preferences
- [behaviour-baseline-characterisation-testing.agent.md](behaviour-baseline-characterisation-testing.agent.md): verifies build/test baseline and sets the autonomy verdict
- [migration-planner-slice-designer.agent.md](migration-planner-slice-designer.agent.md): turns approved intent into executable slices and roadmap
- [e2e-test-assessment-remediation.agent.md](e2e-test-assessment-remediation.agent.md): maps slice coverage to journeys/contracts and closes or documents E2E gaps
- [slice-implementer-worker.agent.md](slice-implementer-worker.agent.md): implements approved slices and gathers verification evidence
- [openrewrite-version-uplift.agent.md](openrewrite-version-uplift.agent.md): handles automated version-uplift slices with recipe-driven changes
- [pr-quality-gate-verification.agent.md](pr-quality-gate-verification.agent.md): enforces the formal pass/fail gate before merge or auto-proceed
- [drift-retrospective-learning.agent.md](drift-retrospective-learning.agent.md): proposes evidence-backed workflow improvements during Evaluate

## E2E Policy

E2E coverage is part of the decision to trust autonomous execution.

- If critical-path E2E verification is missing, failing, or deferred, the orchestrator can downgrade execution to `SUPERVISED` before Execution starts.
- Deferred E2E risk requires explicit owner, due date, and human risk acceptance.
- If a slice is in scope for E2E according to `e2e-coverage-matrix.md`, E2E execution evidence is required before PR handoff.

## OpenRewrite Policy

`version-uplift` slices should prefer [openrewrite-version-uplift.agent.md](openrewrite-version-uplift.agent.md) when a valid recipe exists.

The OpenRewrite agent is expected to:

- dry-run first when supported
- record exact recipe/execution commands
- run build and full tests after recipe application
- escalate only bounded residual gaps to the slice implementer

## Folder Notes

- `e2e-test-patterns.md` is supporting guidance for E2E test generation and should stay aligned with the E2E assessment agent.
- This folder documents workflow behavior; migration artefacts themselves live under `.github/migrations/<migration-id>/`.