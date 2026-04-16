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
```

## Getting started

1. **Obtain LITRAF scores** for the target system (or assess informally using the likelihood criteria in `context/LITRAF_GOVUK_Guidance.md`).
2. **Open the [Pilot Planning Guide](Pilot-Planning-Guide.md)** to identify which legacy types apply, find the matching cluster, and estimate total effort.
3. **Select activities** from the relevant type folders. Not every activity needs to be run; choose based on pilot hypotheses.
4. **Follow the 5-week pilot structure**: Prepare, Assess (Week 1), Execute (Weeks 2-4), Evaluate (Week 5).

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
