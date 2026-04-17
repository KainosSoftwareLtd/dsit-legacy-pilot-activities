# DSIT Legacy Modernisation: Pilot Activity Pages

Execution-ready activity pages for the DSIT AI Code Lab Legacy Modernisation engagement. Each page is a self-contained instruction set that a team can run inside a timeboxed pilot to evidence where AI accelerates legacy remediation.

## Structure

```
index.md                          Full index with links to every activity
Pilot-Planning-Guide.md           How to compose activities across legacy types
L1-Software-Out-of-Support/       5 activities
L2-Expired-Vendor-Contracts/      5 activities
L3-Not-Enough-Knowledge-or-Skills-Available/  7 activities
L4-Cannot-Meet-Current-or-Future-Business-Needs/  6 activities
L5-Unsuitable-Hardware-or-Physical-Environment/   6 activities
L6-Known-Security-Vulnerabilities/   6 activities
L7-Recent-Failures-or-Downtime/      6 activities
docs/architecture/                  Standard location for generated architecture artefacts
```

## Getting started

1. **Obtain LITRAF scores** for the target system (or assess informally using the likelihood criteria in `context/LITRAF_GOVUK_Guidance.md`).
2. **Open the [Pilot Planning Guide](Pilot-Planning-Guide.md)** to identify which legacy types apply, find the matching cluster, and estimate total effort.
3. **Select activities** from the relevant type folders. Not every activity needs to be run; choose based on pilot hypotheses.
4. **Follow the 5-week pilot structure**: Prepare, Assess (Week 1), Execute (Weeks 2-4), Evaluate (Week 5).

<<<<<<< HEAD
## Reusable agents

This repository includes reusable custom agents under:

- [reusable-agents/architecture/architecture-docs-governance.agent.md](reusable-agents/architecture/architecture-docs-governance.agent.md)
- [reusable-agents/architecture/architecture-review-security.agent.md](reusable-agents/architecture/architecture-review-security.agent.md)
- [reusable-agents/architecture/adr-steward.agent.md](reusable-agents/architecture/adr-steward.agent.md)
- [reusable-agents/architecture/architecture-drift-monitor.agent.md](reusable-agents/architecture/architecture-drift-monitor.agent.md)

Use the `Architecture Docs and Governance Orchestrator` as the single user entrypoint for architecture work. It will automatically invoke the supporting architecture subagents when the workflow requires security review, ADR governance, drift validation, or consistency checks.

All architecture artefacts should be stored under `docs/architecture/<system-name>/`.

Do not start the specialist agents directly in normal use. They exist to support the orchestrator's gated workflow.

The orchestrator now persists workflow gate state, human overrides, approved deviations, and architectural preferences in `docs/architecture/<system-name>/workflow-state.yaml`.

### Copy to a pilot codebase repository

1. In the pilot repository, create the target folder: `.github/agents/`.
2. Copy [reusable-agents/architecture/architecture-docs-governance.agent.md](reusable-agents/architecture/architecture-docs-governance.agent.md) into the pilot repo as `.github/agents/architecture-docs-governance.agent.md`.
3. Copy [reusable-agents/architecture/architecture-review-security.agent.md](reusable-agents/architecture/architecture-review-security.agent.md) into the pilot repo as `.github/agents/architecture-review-security.agent.md`.
4. Copy [reusable-agents/architecture/adr-steward.agent.md](reusable-agents/architecture/adr-steward.agent.md) into the pilot repo as `.github/agents/adr-steward.agent.md`.
5. Copy [reusable-agents/architecture/architecture-drift-monitor.agent.md](reusable-agents/architecture/architecture-drift-monitor.agent.md) into the pilot repo as `.github/agents/architecture-drift-monitor.agent.md`.
6. Commit the agent files so the whole team can use the same architecture workflow.

The specialist agents are copied because the orchestrator delegates to them. Users should still start with the orchestrator.

### How to use the architecture agent

Use the `Architecture Docs and Governance Orchestrator` whenever you want to create, update, review, or validate system architecture.

Basic usage pattern:

1. Switch to the `Architecture Docs and Governance Orchestrator` agent in Copilot Chat.
2. Provide the system name, mode, and any evidence sources you already have.
3. State the outcome you want: initial baseline, update after a change, legacy inference, greenfield design, or architecture validation.
4. Let the orchestrator run the workflow. It will decide when to ask for clarification, when to invoke security review, when ADRs are needed, and when drift or consistency validation should block closure.

Recommended prompt shapes:

1. Initial legacy baseline:
	"Create an initial living architecture pack for <system-name> in docs/architecture/<system-name>. Use mode=legacy, strict evidence policy, and produce the architecture outputs needed to start the workflow."
2. Greenfield design:
	"Design the architecture for <system-name> in docs/architecture/<system-name>. Use mode=greenfield, document assumptions clearly, create ADRs for major decisions, and run the full workflow to closure."
3. Update after change:
	"Update the living architecture for <system-name> after the recent change. Apply the workflow, update impacted docs and DSL only, and close any required review or governance gates."
4. Legacy validation pass:
	"Review and reconcile the current implementation of <system-name> against docs/architecture/<system-name>. Use mode=hybrid and close the workflow only if consistency and review gates pass."

### Use the orchestrator for an initial architecture baseline

1. In Copilot Chat, switch to the `Architecture Docs and Governance Orchestrator` agent.
2. Provide `mode` (`greenfield`, `legacy`, or `hybrid`), system scope, and known evidence sources (repo paths, config files, infra manifests, APIs, ops docs, contracts, SME notes).
3. Ask for a first-pass architecture pack with strict evidence tagging and confidence levels.

Example prompt:

"Create an initial living architecture pack for <system-name> in docs/architecture/<system-name>. Use mode=legacy, strict evidence policy, produce C4 Context and Container DSL, and capture unknowns/questions for validation."

Expected outputs:

1. `docs/architecture/<system-name>/` document set.
2. C4 DSL files for context and container views.
3. Confidence summary and an explicit unknowns/assumptions list.

### What the orchestrator does automatically

The orchestrator may automatically invoke internal architecture subagents as part of the workflow. Users should not normally invoke these directly.

Automatic security workflow includes:
- **OWASP** risk categories for architecture and API exposure.
- **STRIDE** threat modelling across trust boundaries and data flows.
- **Vulnerability exposure** patterns in authentication, authorization, interfaces, dependencies, and secrets handling.
- **Cloud Well-Architected security principles** (least privilege, defense in depth, traceability, incident readiness).

Automatic governance workflow includes:
- ADR creation or updates when design intent changes.
- ADR quality gating before closure when ADRs were touched.
- Drift validation after major refactors or high-impact updates.
- Final consistency checking across C4 DSL, docs, ADRs, and workflow state.

The orchestrator keeps the workflow blocked until the required gates pass.

### Workflow outputs you should expect

1. `docs/architecture/<system-name>/` architecture documents and C4 DSL.
2. `docs/architecture/<system-name>/adr/` ADR records when design decisions changed.
3. `docs/architecture/<system-name>/reviews/` review artefacts when review phases ran.
4. `docs/architecture/<system-name>/workflow-state.yaml` gate and workflow state.

### ADR Quality Gate

The architecture workflow now includes a lightweight ADR quality gate enforced before closure when ADRs have changed.

The gate checks:
- minimum ADR fields are present
- reciprocal links exist between ADRs and impacted architecture docs
- ADR index entries resolve and statuses match the ADR file contents

Gate output contract:
- `Gate Status: PASS` allows workflow closure
- `Gate Status: FAIL` blocks closure and must include a short remediation checklist

### Architecture Consistency Gate

Before workflow closure, the orchestrator must verify that:
- C4 DSL matches architecture docs
- ADR decisions and assumptions match architecture docs
- workflow state reflects the actual gate outcomes and blockers

If contradictions remain, the workflow stays blocked.

### Iterate after system changes

1. Provide the change context (new integration, dependency upgrade, deployment/runtime change, incident fix, contract change).
2. Ask the agent to update only impacted sections and append a dated entry in `CHANGELOG.md`.
3. Re-generate only affected C4 DSL views and keep diagram identifiers stable.

Example prompt:

"Update the living architecture for <system-name> after the recent change. Identify impacted docs/diagrams, apply minimal updates, append changelog entries, and list follow-up validation questions."

### Interaction tips

1. Always include evidence locations in your prompt to reduce ambiguity.
2. Ask for confidence tags (`High`, `Medium`, `Low`) on all major claims.
3. Request unresolved questions as a checklist for SME walkthroughs.
4. Use short, repeatable update prompts after each material system change to keep docs truly living.
5. Use the orchestrator as the only manual entrypoint; it will decide whether review, ADR, drift, and consistency phases are required.

### Additional architecture-focused agents worth adding

1. **NFR Scenario Agent**: curates and stress-tests quality-attribute scenarios used by the review process.
2. **Threat Modelling Agent**: runs STRIDE-style threat passes and links security concerns into the architecture risk register.

### Architecture agent routing by activity

| Activity | Recommended architecture entrypoint | What the orchestrator will handle |
|---|---|---|
| [L3-Architecture-Summary](L3-Not-Enough-Knowledge-or-Skills-Available/L3-Architecture-Summary.md) | Architecture Docs and Governance Orchestrator | Baseline generation plus any required internal review and governance gates |
| [L3-Generate-System-Documentation](L3-Not-Enough-Knowledge-or-Skills-Available/L3-Generate-System-Documentation.md) | Architecture Docs and Governance Orchestrator | Documentation generation plus automatic review and consistency checks when required |
| [L3-Documentation-Gap-Analysis](L3-Not-Enough-Knowledge-or-Skills-Available/L3-Documentation-Gap-Analysis.md) | Architecture Docs and Governance Orchestrator (for architecture-related gaps) | Gap remediation, review, ADR, and consistency workflow when architecture work is needed |
| [L4-Change-Impact-Mapping](L4-Cannot-Meet-Current-or-Future-Business-Needs/L4-Change-Impact-Mapping.md) | Architecture Docs and Governance Orchestrator | Architecture updates, review, and any required governance or drift validation |
| [L6-Architecture-Risk-Scan](L6-Known-Security-Vulnerabilities/L6-Architecture-Risk-Scan.md) | Architecture Docs and Governance Orchestrator | Architecture baseline plus automatic internal security review workflow |

Rule of thumb:
- Use **Architecture Docs and Governance Orchestrator** for all user-driven architecture work.
- Let the orchestrator invoke the supporting architecture agents internally.
=======
## Using the Pilot Orchestrator Agent

The Pilot Orchestrator agent manages the entire lifecycle of a pilot: initialization, activity sequencing, artefact validation, state tracking, and final reporting. Activities themselves are executed offline by the pilot team; the orchestrator records outcomes, validates evidence, and coordinates cross-system dependencies.

### Quick start

1. **For a new pilot:** Open Copilot Chat, select **Pilot Orchestrator**, and provide:
   - Pilot identifier (e.g. `hmrc-hr-platform-2026q2`)
   - Target system name(s)
   - Completed LITRAF report content or file path (if available)

2. **For an existing pilot:** Open Copilot Chat, select **Pilot Orchestrator**, and provide the pilot identifier. It will load your progress and resume from the last waiting or ready activity.

### Agent role and responsibilities

The orchestrator:
- **Initializes** pilots from LITRAF reports or discovery inputs
- **Selects** in-scope activities based on LITRAF scores and existing clusters
- **Tracks** pilot state in machine-readable (`state.yaml`) and human-readable (`tracker.md`) formats
- **Sequences** activities according to dependencies and phase gates
- **Validates** offline-completed artefacts before marking activities `done`
- **Coordinates** shared outputs across multiple legacy types
- **Handles** resumability: you can pause and return without losing context
- **Delegates** report generation when the pilot is ready to close

The orchestrator **does not** execute individual activities; those are completed offline by the pilot team using the activity pages in this repository.

### Pilot structure and phases

Every pilot follows a five-phase structure. The orchestrator enforces phase gates to ensure quality.

**Prepare** (before kickoff)
- Input: LITRAF report or discovery interview
- Output: Selected activity list, dependency map, initialized tracker and state
- Gate: LITRAF artefacts or discovery summary must be stored; tracker rows must be valid

**Assess** (Week 1)
- Output: Baseline metrics, hypotheses, execute plan, access/governance notes
- Gate: All Assess outputs must exist before moving to Execute

**Execute** (Weeks 2-4)
- Process: Team completes activities offline; you provide artefacts to orchestrator for validation
- Output: Completed activity artefacts, handoff notes, updated tracker
- Gate: Only validated artefacts unblock downstream activities

**Evaluate** (Week 5)
- Output: End-state metrics, cross-type observations, evidence completeness checklist
- Gate: Evaluation evidence must be complete before Report phase

**Report** (post-pilot)
- Output: Private pilot report
- Process: Orchestrator delegates to Pilot Report Synthesiser; you review and approve outputs

### Workflow: starting a new pilot

**Session 1: Initialize**

1. Select **Pilot Orchestrator** in Copilot Chat
2. Say: "Start a new pilot. Pilot ID: `{your-id}`. Target system: `{system-name}`. Here is the LITRAF report: `[paste content or file reference]`."
3. The orchestrator will:
   - Create `.github/pilots/{pilot-id}/` directory structure
   - Store LITRAF report as artefact
   - Analyze LITRAF scores and identify legacy types
   - Map to activity clusters from the Pilot Planning Guide
   - Generate `.github/pilots/{pilot-id}/state.yaml` with activity list and dependencies
   - Generate `.github/pilots/{pilot-id}/tracker.md` with human-readable status and next actions
4. The orchestrator will display:
   - Selected legacy types and cluster
   - In-scope activities (prioritized, with dependencies)
   - Estimated effort and critical path
   - Next action for Assess phase

**Session 2+: Assess Phase**

1. Say: "Continue pilot `{pilot-id}`. We have completed Assess phase with these outputs: [attach or describe baseline metrics, hypotheses, execute plan, access notes]."
2. The orchestrator will:
   - Verify Assess gate requirements
   - Generate activity cards for Execute phase
   - Update tracker to `ready` for first executable activities
   - Display high-priority execution order

### Workflow: executing activities

**During execution (Weeks 2-4):**

1. **Team executes offline:** Pick an activity from the tracker's `ready` list. Follow the activity page instructions. Save all outputs (artefacts, code, reports, metrics).

2. **Provide outcomes to orchestrator:**
   - Say: "I have completed `Activity-ID-Name` for `system-name`. Here are the required artefacts: [attach files or descriptions]."
   - The orchestrator will validate using the **Pilot Artefact Gatekeeper**.
   - If valid, the activity is marked `done` and downstream activities may become `ready`.
   - If incomplete, it moves to `waiting-on-human` with specific missing evidence listed.

3. **Repeat** until all Execute-phase activities in the critical path are complete.

### Workflow: resuming a pilot

When returning to an in-progress pilot:

1. Say: "Resume pilot `{pilot-id}`."
2. The orchestrator will:
   - Load current state and tracker
   - Display current phase and next required actions
   - List `ready` activities you can start
   - List `waiting-on-human` activities where evidence is needed
   - List `blocked` activities and their dependencies
3. You can resume from any activity in `ready` or `waiting-on-human` state.

### Workflow: completing evaluation and reporting

**Evaluate phase:**

1. Say: "We have completed Evaluate. Here is the end-state metrics summary, cross-type observations, and evidence completeness checklist: [provide outputs]."
2. The orchestrator verifies all gate requirements and moves to Report phase.

**Report phase:**

1. The orchestrator delegates to **Pilot Report Synthesiser**.
2. Say: "Generate the final private report for DSIT."
3. The synthesiser builds:
   - `.github/pilots/{pilot-id}/report/final-report-private.md` (private, includes client-specific details and continuation recommendations)
4. Review report and request edits if needed.

### Multi-system pilots

For pilots spanning multiple target systems with separate LITRAF reports:

1. Provide LITRAF report per system during initialization.
2. The orchestrator creates per-system sections in tracker and state.
3. The orchestrator tracks shared outputs and cross-system handoffs explicitly.
4. When an activity completes on System A and its output is needed by System B, the orchestrator marks System B activities as `ready`.
5. Final report includes per-system sections and explicit cross-system findings.

### Key concepts and terminology

| Term | Meaning |
|------|---------|
| **Pilot ID** | Unique identifier for the pilot (e.g. `hmrc-hr-2026q2`). Used in file paths and tracker. |
| **LITRAF report** | Completed assessment document showing scores for each legacy criterion (L1-L7). Required for scoping. |
| **Activity** | A discrete task from this repository (e.g. "L1 Extract SBOM"). Executed offline by the team. |
| **Artefact** | Output evidence from a completed activity (code, report, metrics, etc.). Required before marking activity `done`. |
| **Hub activity** | An activity whose output is shared across multiple legacy types (e.g. Architecture Summary). Executed once. |
| **Cluster** | A common combination of legacy types (e.g. L1+L6 "Unpatched and exposed"). See Pilot Planning Guide. |
| **Phase gate** | Requirement that must be satisfied before advancing to the next phase (e.g. "Assess outputs must be complete"). |
| **Blocker** | A dependency or resource issue that prevents an activity from progressing. Recorded in tracker. |
| **State file** | `.github/pilots/{pilot-id}/state.yaml` — machine-readable source of truth for pilot phase, activities, and dependencies. |
| **Tracker** | `.github/pilots/{pilot-id}/tracker.md` — human-readable dashboard of current status and next actions. |

### Integration with activity pages

The Pilot Orchestrator orchestrates; the activity pages provide execution instructions. When in Execute phase:

1. Open the orchestrator's tracker and pick a `ready` activity.
2. Open the corresponding activity page from this repository (e.g. [L1 Extract SBOM](L1-Software-Out-of-Support/L1-Extract-SBOM.md)).
3. Follow the activity's 12 sections: purpose, scope, AI use, preconditions, tooling, timebox, inputs, outputs, metrics, risks, definition of done, playbook contribution.
4. Save all required outputs (artefacts).
5. Return to the orchestrator and provide outputs for validation and state update.

### Artefact gatekeeper and validation

Before marking any activity `done`, the orchestrator invokes the **Pilot Artefact Gatekeeper**, which checks:

- **Completeness:** Does the artefact match the activity's "Required Outputs" section?
- **Quality:** Does the artefact meet the activity's "Definition of Done" criteria?
- **Traceability:** Can the artefact be traced back to its source (repository, module, incident)?

If validation fails, the activity returns to `waiting-on-human` with specific feedback on what is missing.

### Handling blockers and waiting-on-human

Activities may be blocked or waiting on human decision for these reasons:

- **Blocked:** Cannot proceed until an upstream activity completes or a dependency is resolved. Orchestrator shows the dependency.
- **Waiting-on-human:** Requires information from you (artefact, clarification, decision). Orchestrator displays the specific request.
- **Ready:** All dependencies met, no human input needed. You can start this activity immediately.

When you see `waiting-on-human`:

1. Read the orchestrator's request carefully.
2. Provide the missing information, artefact, or decision.
3. The orchestrator will validate and update state.

### Resumability and session recovery

Pilots are designed to be pauseable across sessions:

- All state is stored in files (`.github/pilots/{pilot-id}/state.yaml` and tracker.md), not in chat memory.
- You can leave mid-activity and return within minutes or days.
- When you resume, say "Resume pilot `{pilot-id}`" and the orchestrator loads current state.
- You continue from the last waiting or ready activity without re-planning.

### Best practices

1. **Keep LITRAF scores clear.** Before starting a pilot, ensure LITRAF scores are finalized. This drives activity selection.
2. **Select clusters intentionally.** Use the [Pilot Planning Guide](Pilot-Planning-Guide.md) to identify common type combinations and plan cross-system handoffs upfront.
3. **Complete hub activities first.** Architecture Summary, SBOM, and Log Clustering feed multiple downstream activities. Prioritize these early.
4. **Validate as you go.** Don't wait until the end of Execute phase to provide artefacts. Submit after each activity for quick feedback.
5. **Use tracker as your roadmap.** Check the tracker frequently to see what's `ready`, what's `blocked`, and what's next.
6. **Record cross-system handoffs.** When one system's output becomes another system's input (e.g. shared Architecture Summary), the orchestrator tracks this explicitly.
7. **Ask for clarification.** If you don't understand a gate requirement or a gatekeeper feedback, ask the orchestrator to explain.
>>>>>>> main

## Activity page format

Each activity follows a 12-section template:

1. Why this activity matters
2. Scope and steps (numbered sub-tasks)
3. How AI is used
4. Preconditions
5. Tooling (categories with examples)
6. Timebox (hours/half-days with confidence tag)
7. Inputs
8. Outputs
9. Metrics (baseline vs observed)
10. Risks and mitigations
11. Definition of Done
12. Playbook contribution (patterns and anti-patterns)

## Multi-type pilots

Real systems rarely score on just one LITRAF criterion. The [Pilot Planning Guide](Pilot-Planning-Guide.md) covers:

- **Common type clusters** (e.g. L1+L6 "Unpatched and exposed", L4+L3+L7 "Can't change, keeps breaking")
- **Hub activities** whose outputs are shared across types (Architecture Summary, SBOM, Log Clustering, Triage SAST/SCA)
- **Effort savings** from running types together rather than in isolation
- **Week-by-week schedule template** mapping activities to pilot phases
- **Dependency diagrams** (Mermaid) showing cross-type data flows

## Options bands (pilot-scope)

| Band | Person-days |
|------|-------------|
| XS   | 1-2         |
| S    | 3-5         |
| M    | 6-10        |
| L    | 11-16       |
| XL   | 17-25       |

Keep ROMs in person-days for cross-pilot comparability. Convert to calendar time only in narrative if needed.

## Metrics

Activities are measured using a consistent set so DSIT can roll up findings across departments:

- **P1** Task time delta (median-based, percent change vs baseline)
- **P2** Quality score (reviewer rubric 1-5)
- **P3** Developer sentiment (SPACE survey)
- **P4** Lead time for changes (DORA)
- **P5** Change failure rate (DORA)
- **P6** Test coverage delta
- **P7** Vulnerability/risk reduction
- **P8** Reusable artefacts produced
