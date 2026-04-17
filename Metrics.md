# Metrics and Measurement Guidance

This page is the published canonical reference for pilot metrics in this repository. Activity pages should use section 9 to map their measurement plan to the metric set defined here.

## Purpose

Use a small, consistent metric set so pilot results can be compared across departments, systems, and legacy types. The aim is not to force every activity to use every metric. The aim is to capture the same metrics in the same way when they are relevant.

## Measurement principles

- Compare baseline versus observed values so deltas can be explained, not just reported.
- Keep evidence links with every metric entry so findings can be audited later.
- Use the smallest metric set that still supports the decision the activity is meant to inform.
- Prefer medians for P1 when the same activity is repeated across multiple units such as repositories, findings, incidents, or change requests.
- Use reviewer scoring consistently for P2. Rate accuracy, completeness, and actionability on the standard 1 to 5 rubric unless an activity page defines a tighter variant.
- Record only the metrics that are applicable to the activity. Not every activity needs all eight metrics.
- Count reusable artefacts in P8 and include links to where they are stored.

## Collection timing

- Baseline (Week 1): P3 survey, P4 to P7 current-state measures, and manual task estimates for P1.
- During pilot (Weeks 2 to 4): P1, P2, and P8.
- Post-pilot (Week 5): repeat P3, update P4 to P7, finalise P8, and complete the Four-Box summary.

## Minimum evidence to capture

For each metric recorded, capture:

- activity name or ID
- system or scope assessed
- baseline value or baseline estimation method
- observed value after AI-assisted execution
- unit of measure
- evidence links such as PRs, dashboards, scorecards, survey outputs, or notes
- reviewer or owner name where a human judgement is involved

## Metric definitions

### P1 Task Time Delta

**What it measures:** The percentage change between the baseline time for completing a task and the observed time when the task is completed with AI assistance.

**Why it matters:** This is the main productivity measure for pilot execution. It shows whether AI reduces effort for repeatable work.

**How to measure it:**

- Capture a baseline before execution. This can be a recent historical example, a department estimate from the delivery team, or a manual trial if one is available.
- Record observed wall-clock time for the AI-assisted task.
- When multiple runs exist, use the median baseline and median observed time.
- Report the percentage change, not just the raw times.

**Typical evidence:** timestamps from GitHub or Azure DevOps, workshop notes, analyst or engineer time logs, evidence logs.

### P2 Quality Score

**What it measures:** A reviewer score on a 1 to 5 rubric for the quality of the output.

**Why it matters:** Speed alone is not useful if the resulting output is inaccurate, incomplete, or hard to use.

**How to measure it:**

- Use a human reviewer appropriate to the activity, such as a tech lead, architect, SRE, security reviewer, or commercial lead.
- Score the output against three dimensions: accuracy, completeness, and actionability.
- Keep the rubric consistent across repeated runs of the same activity.
- Record short notes explaining any score below 3.

**Typical evidence:** review checklists, PR review comments, sign-off notes, scoring spreadsheets.

### P3 Developer Sentiment (SPACE)

**What it measures:** Team sentiment on the AI-assisted way of working using the SPACE survey.

**Why it matters:** Pilot success depends on whether practitioners found the approach useful, usable, and trustworthy enough to adopt.

**How to measure it:**

- Run the SPACE survey at baseline and again during evaluation.
- Keep the question set stable for the pilot so responses are comparable.
- Use it as a cross-pilot measure rather than forcing per-activity collection.
- Include qualitative comments when sentiment is mixed.

**Typical evidence:** survey forms, forms export, workshop retro notes.

### P4 Lead Time for Changes (DORA)

**What it measures:** The elapsed time for a change to move from commit to deploy, using the DORA definition where it fits the activity.

**Why it matters:** Some activities are valuable because they speed up safe change delivery, not just analysis or documentation.

**How to measure it:**

- Use only where an activity produces or accelerates a change flow such as a PR, configuration update, or fix.
- Measure from commit to deploy when the delivery data exists. If deploy timing is not available in the pilot, use the nearest defensible proxy and record that assumption.
- Compare against the current-state baseline for similar changes where possible.
- If precise measurement is not possible, note the expected lead-time effect qualitatively and do not force a weak number.

**Typical evidence:** Git history, PR timestamps, deployment records, change tickets.

### P5 Change Failure Rate (DORA)

**What it measures:** The proportion of changes that introduce failures, regressions, rollbacks, or follow-up fixes, using the DORA concept where it fits.

**Why it matters:** Faster change is only useful if it does not increase operational risk.

**How to measure it:**

- Use where an activity influences how changes are made or validated.
- Track whether changes associated with the activity produce test failures, incidents, rollbacks, or hotfixes.
- Compare against the current baseline for similar changes if historic data exists.
- Where data is thin, capture the direction of effect and the evidence source rather than overstating confidence.

**Typical evidence:** CI results, incident logs, rollback records, post-deployment review notes.

### P6 Test Coverage Delta

**What it measures:** The change in automated test coverage for the targeted scope before and after the activity.

**Why it matters:** Several activities create value by making risky change safer through additional tests.

**How to measure it:**

- Capture the baseline coverage for the relevant module, service, or change area.
- Capture the post-activity coverage using the same tool and scope.
- Record both numeric delta and any scope caveats, such as partial coverage or unreliable legacy tooling.
- Use only where the activity genuinely affects tests.

**Typical evidence:** coverage reports, CI output, testing dashboards.

### P7 Vulnerability / Risk Reduction

**What it measures:** The reduction in identified technical, security, operational, or commercial risk that results from the activity.

**Why it matters:** Many legacy activities create value by surfacing, prioritising, or reducing risk rather than by shipping a feature.

**How to measure it:**

- Define the relevant risk unit for the activity, such as vulnerable components, reachable findings, architectural risks, undocumented blockers, commercial constraints, or DSIT legacy risk score.
- Capture the baseline known-risk position before the activity.
- Record what new risks were identified, what risks were reduced, and what evidence supports that claim.
- Use counts where possible, but allow supported qualitative statements when the reduction is directional rather than directly countable.

**Typical evidence:** SCA tools, scanner outputs, SBOMs, risk registers, DSIT legacy risk assessment outputs, triage notes, decision logs.

### P8 Reusable Artefacts

**What it measures:** The prompts, scripts, templates, agents, or workflows produced by the activity that can be reused after the pilot, together with links to those outputs.

**Why it matters:** DSIT wants publishable, reusable assets that other departments can adopt, not just one-off pilot results.

**How to measure it:**

- Count only artefacts that another team could reuse with minor adaptation.
- Include links to each artefact so the count can be verified.
- Examples include prompt templates, scripts, checklists, PR templates, dashboards, scoring rubrics, runbook formats, agents, workflows, and report templates.
- Avoid inflating the count with drafts or low-value duplicates.

**Typical evidence:** repository paths, shared folders, published markdown pages, dashboard links.

## Four-Box Summary template

Use this at the end of the pilot for governance reporting and cross-pilot comparison.

### 1. Where AI Helped

- Time saved as a percentage or hours
- Risk reduction
- Quality uplift
- Team confidence change

### 2. Prerequisites and Enablers

- Required tools and access
- Environment readiness
- Governance and security approvals
- Team skill needs

### 3. Limits, Risks and Oversight

- Where AI underperformed
- New risks introduced
- Human approval points
- Whether issues were pilot-specific or structural

### 4. Reusable Assets and Scale Potential

- Prompts and templates validated
- Patterns suitable for playbook inclusion
- Reusability rating such as local, adaptable, or broad
- Departmental or cross-government scaling options

## Using this page in activity design

- Activity pages should keep their section 9 table and map only the metrics that matter for that activity.
- Pilot-level plans should use this page when setting baseline capture, evidence pack structure, and evaluation criteria.
- If a Confluence planning page remains in use, keep the metric titles and ordering aligned with this page so GitHub remains self-contained.