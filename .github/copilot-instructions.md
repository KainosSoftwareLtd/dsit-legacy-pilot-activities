## Pilot Workflow Rules

- Treat `.github/pilots/<pilot-id>/state.yaml` as the machine-readable source of truth for pilot state.
- Treat `.github/pilots/<pilot-id>/tracker.md` as the human-readable source of truth for progress and next actions.
- Never mark an activity complete unless its required outcome artefact exists and passes validation.
- Generate reports from artefacts and tracker state, not from chat memory.
- Preserve phase isolation: complete the current phase gate before advancing the pilot to the next phase.

## Pilot Folder Layout

Every pilot should use this structure:

```text
.github/pilots/<pilot-id>/
  litraf-report.md
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

## Phase Gates

### Prepare

Must produce:

- `litraf-report.md`
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

- final pilot report
- continuation and backlog recommendation

## Agent Behavior

- The orchestrator owns state, sequencing, resumability, and phase advancement.
- Activities are performed offline by humans; the orchestrator records outcomes and requested evidence.
- The artefact gatekeeper decides whether an activity can be marked `done`.
- The report synthesiser builds the final report from stored artefacts and tracker state.