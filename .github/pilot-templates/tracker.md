# Pilot Tracker: <pilot-id>

## Snapshot

| Field | Value |
|---|---|
| Target system | <target-system> |
| Current phase | prepare |
| Selected legacy types | <L1, L3, L6> |
| Selected clusters | <Cluster C> |
| Last updated | <yyyy-mm-dd> |

## Phase Progress

| Phase | Status | Gate condition | Next action |
|---|---|---|---|
| Prepare | not-started | tracker, state, selected activities initialized | initialize pilot files and selected activity list |
| Assess | not-started | baseline, hypotheses, execute plan, governance artefacts complete | capture assess artefacts |
| Execute | not-started | all in-scope activity evidence gathered | run ready activities and validate artefacts |
| Evaluate | not-started | end-state metrics and evidence completeness check complete | compile evaluation artefacts |
| Report | not-started | final report and continuation roadmap generated | synthesize report from artefacts |

## Current Queue

### Ready

- None

### Waiting On Human

- None

### Blocked

- None

## Activity Tracker

| Activity ID | Activity Name | Legacy Type | Phase | Status | Dependencies | Required Inputs | Required Artefacts | Artefacts Produced | Human Input Required | Blockers | Downstream Unblocked | Last Updated | Notes For Report | Next Action |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| <activity-id> | <activity-name> | <legacy-type> | <phase> | not-started | <dependency-ids> | <key-inputs> | <required-artefacts> | <artefacts-produced> | yes/no | <blockers> | <activity-ids> | <yyyy-mm-dd> | <report-note> | <next-action> |

## Shared Output Handoffs

| Source Activity | Shared Output | Consumed By | Handoff Status | Notes |
|---|---|---|---|---|
| <source-activity> | <artefact> | <downstream-activities> | <planned/in-use/completed> | <notes> |

## Recent Decisions And Blockers

| Date | Type | Item | Detail | Owner | Resolution Needed |
|---|---|---|---|---|---|
| <yyyy-mm-dd> | blocker | <activity-or-phase> | <detail> | <owner> | <required-action> |