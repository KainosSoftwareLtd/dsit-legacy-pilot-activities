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

This repository includes reusable custom agents under [reusable-agents/legacy-architecture-docs.agent.md](reusable-agents/legacy-architecture-docs.agent.md).

Use this agent when a pilot codebase has limited or outdated architecture information and you need a living architecture pack plus C4 DSL diagrams that can be updated over time.

### Copy to a pilot codebase repository

1. In the pilot repository, create the target folder: `.github/agents/`.
2. Copy [reusable-agents/legacy-architecture-docs.agent.md](reusable-agents/legacy-architecture-docs.agent.md) from this repo into the pilot repo as `.github/agents/legacy-architecture-docs.agent.md`.
3. Commit the new agent file so the whole team can use the same architecture-documentation workflow.

### Use the agent for an initial architecture baseline

1. In Copilot Chat, switch to the `Legacy Architecture Living Docs` agent.
2. Provide system scope and known evidence sources (repo paths, config files, infra manifests, APIs, ops docs, contracts, SME notes).
3. Ask for a first-pass architecture pack with strict evidence tagging and confidence levels.

Example prompt:

"Create an initial living architecture pack for <system-name>. Use strict evidence policy, produce C4 Context and Container DSL, and capture unknowns/questions for validation."

Expected outputs:

1. `architecture/<system-name>/` document set.
2. C4 DSL files for context and container views.
3. Confidence summary and an explicit unknowns/assumptions list.

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
