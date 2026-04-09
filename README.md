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

## Reusable agents

This repository includes reusable Copilot custom agents that can be copied into client repositories.

- Shared agent catalog location: [reusable-agents/](reusable-agents/)
- Agent 1: [reusable-agents/architecture-discovery-and-dsl.agent.md](reusable-agents/architecture-discovery-and-dsl.agent.md)
- Agent 2: [reusable-agents/behavior-baseline-and-onboarding.agent.md](reusable-agents/behavior-baseline-and-onboarding.agent.md)

### Architecture Discovery and DSL Agent

Use this agent when a team needs a source-grounded architecture view of an existing codebase.

What it generates (per run):
- Markdown architecture summary
- C4 Context diagram (Mermaid)
- C4 Container diagram (Mermaid)
- Structurizr DSL

Default output behavior:
- Writes latest artifacts to docs/architecture/
- Preserves run history in docs/architecture/history/<timestamp>/
- Updates docs/architecture/history/index.md for traceability

Required evidence sources:
- Source code and configuration files
- CI/CD pipeline definitions
- Infrastructure manifests (Docker, Helm, Terraform)

### How to use in a client repo

1. Copy [reusable-agents/architecture-discovery-and-dsl.agent.md](reusable-agents/architecture-discovery-and-dsl.agent.md) into the client repo at .github/agents/architecture-discovery-and-dsl.agent.md.
2. Open Copilot Chat and select Architecture Discovery and DSL Agent from the agent picker.
3. Run one of these prompts:
	- Run Architecture Discovery and DSL Agent for this repository.
	- Generate architecture artifacts for services in /src and write to docs/architecture/.
	- Create C4 context/container plus Structurizr DSL for this monolith.
4. Review outputs in docs/architecture/ and validate that each major claim is backed by evidence citations.

### Governance expectations

- Every architectural claim should cite repository evidence.
- Missing evidence categories should be logged as explicit gaps.
- Previous architecture outputs should not be deleted.

### Behavior Baseline and Onboarding Agent

Use this agent to document how the system currently behaves so teams can:
- understand existing behavior during onboarding,
- identify ambiguous areas for product-team confirmation offline,
- create a source-grounded current-state behavior baseline.

Important scope boundary:
- It does not infer or define expected behavior.
- It does not judge correctness against product intent.
- It only documents observed behavior from available evidence.

What it generates (per run):
- behavior-baseline.md
- system-behavior-catalog.md
- onboarding-guide.md

Default output behavior:
- Writes latest artifacts to docs/behavior-baseline/
- Preserves run history in docs/behavior-baseline/history/<timestamp>/
- Updates docs/behavior-baseline/history/index.md for traceability

How to use in a client repo:
1. Copy [reusable-agents/behavior-baseline-and-onboarding.agent.md](reusable-agents/behavior-baseline-and-onboarding.agent.md) into the client repo at .github/agents/behavior-baseline-and-onboarding.agent.md.
2. Open Copilot Chat and select Behavior Baseline and Onboarding Agent.
3. Run one of these prompts:
	- Run Behavior Baseline and Onboarding Agent for this repository.
	- Document current behavior for services in /src and write to docs/behavior-baseline/.
	- Produce onboarding behavior docs from this monolith without expected-behavior comparison.
4. Share the generated ambiguity list with product stakeholders for offline validation.

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
