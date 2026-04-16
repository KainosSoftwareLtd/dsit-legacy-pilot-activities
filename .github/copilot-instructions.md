## Pilot Workflow Rules

- Treat `.github/pilots/<pilot-id>/state.yaml` as the machine-readable source of truth for pilot state.
- Treat `.github/pilots/<pilot-id>/tracker.md` as the human-readable source of truth for progress and next actions.
- Never mark an activity complete unless its required outcome artefact exists and passes validation.
- Generate reports from artefacts and tracker state, not from chat memory.
- Preserve phase isolation: complete the current phase gate before advancing the pilot to the next phase.

## Multi-System Pilot Boundaries

- A pilot can span one or more target systems.
- For multi-system pilots, each target system has its own completed LITRAF assessment and score.
- The pilot tracker must coordinate activities across all in-scope systems in a single pilot view.
- Do not collapse multi-system evidence into one synthetic score unless that aggregation is supplied explicitly by humans.
- Track cross-system dependencies explicitly through activity dependencies and shared handoff entries.

## Pilot Folder Layout

Every pilot should use this structure:

```text
.github/pilots/<pilot-id>/
  litraf-reports/
    <system-a>.md
    <system-b>.md
  state.yaml
  tracker.md
  prepare/
  assess/
  execute/
  evaluate/
  report/
```

## Tracker Status Vocabulary

Use only these statuses in `state.yaml` and `tracker.md`:

- `not-started`
- `ready`
- `waiting-on-human`
- `in-progress`
- `blocked`
- `done`
- `skipped`

## Tracker Row Schema

Each tracked activity should record:

- `activity_id`
- `activity_name`
- `legacy_type`
- `target_systems`
- `phase`
- `status`
- `dependencies`
- `required_inputs`
- `required_artefacts`
- `artefacts_produced`
- `human_input_required`
- `blockers`
- `downstream_unblocked`
- `last_updated`
- `notes_for_report`
- `next_action`

## Artefact Rules

- Every activity must define at least one required outcome artefact.
- If an activity depends on external tooling or exports, record the human-provided evidence as an artefact before validation.
- If an activity produces a shared output used by downstream activities, record that handoff explicitly in the tracker.
- When confidence is low because an input is missing or partial, record the assumption in the artefact.

## LITRAF Integration

- Ask for completed LITRAF report artefacts before pilot kickoff where they are available.
- If direct LITRAF access is unavailable, run a structured discovery conversation to identify in-scope systems, legacy types, risks, and candidate activities.
- For multi-system pilots, store one LITRAF report per system under `litraf-reports/` and map each system to its report path in `state.yaml` when provided.
- Record discovery outputs as a Prepare artefact when LITRAF reports are not provided.
- Use available LITRAF and discovery outputs to determine scope and sequencing inputs during Prepare.
- LITRAF inputs guide prioritization and risk context; they do not replace tracker-level dependency management.

## Report Output Policy

- Produce one output in the Report phase:
  - private report for DSIT, containing pilot-organization-specific details and evidence
- The private report may include specific organization names, architecture details, constraints, and sensitive context.

## Phase Gates

### Prepare

Must produce:

- LITRAF report artefacts for in-scope systems where provided
- scoped activity discovery artefact when LITRAF reports are unavailable
- selected in-scope activities
- initial `tracker.md`
- initial `state.yaml`

### Assess

Must produce:

- baseline metrics artefact
- hypotheses artefact
- execute plan artefact
- access and governance notes

### Execute

Must produce:

- outcome artefacts for each completed activity
- handoff notes for shared outputs
- tracker updates after each activity state change

### Evaluate

Must produce:

- end-state metrics artefact
- cross-type observations
- evidence completeness check

### Report

Must produce:

- private final pilot report for DSIT

## Agent Behavior

- The orchestrator owns state, sequencing, resumability, and phase advancement.
- Activities are performed offline by humans; the orchestrator records outcomes and requested evidence.
- The artefact gatekeeper decides whether an activity can be marked `done`.
- The report synthesiser builds the final report from stored artefacts and tracker state.