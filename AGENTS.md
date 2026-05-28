# AGENTS.md

## Purpose

This repository is a markdown-based instruction pack for DSIT legacy-modernisation pilots. It is primarily documentation, reusable agent definitions, and pilot-planning material. It is not a runnable application repository with a standard build, test, or deploy loop.

## Start Here

- Read [README.md](README.md) for the main operating guide and the supported agent entrypoints.
- Read [index.md](index.md) for the quick navigation page across all activity packs.
- Read [Pilot-Planning-Guide.md](Pilot-Planning-Guide.md) when the task is activity selection, sequencing, clustering, or pilot composition.
- Read [Metrics.md](Metrics.md) when the task depends on pilot measurement, evidence, or P1 to P8 definitions.

## Repo Shape

- `L1-...` to `L7-...` contain the execution-ready activity pages grouped by LITRAF legacy type.
- `.github/agents/` contains the pilot orchestration agents used directly in this repository.
- `reusable-agents/architecture/` contains reusable architecture workflow agents and support tooling.
- `reusable-agents/legacy-migration/` contains the migration orchestrator and its skills.
- `.github/pilot-templates/` contains the pilot state and tracker templates.

## Working Rules

- Do not invent build, test, or runtime commands for this repository. If validation is needed, prefer markdown/frontmatter checks and targeted file review.
- Prefer links to existing documentation over copying guidance into new files.
- Preserve the existing naming and folder scheme for activity pages. The L1 to L7 folders and file names are part of the published pack structure.
- Treat reusable agents as reusable templates. Do not move or rename them unless the user explicitly wants the reusable workflow changed.
- When editing agent frontmatter with `handoffs`, preserve the existing indentation style exactly. This repo is sensitive to YAML spacing in agent files.

## Routing

- Use [`.github/agents/pilot-manager.agent.md`](.github/agents/pilot-manager.agent.md) when the user wants to start, resume, sequence, or close out a pilot.
- Use [`reusable-agents/architecture/architecture-docs-governance.agent.md`](reusable-agents/architecture/architecture-docs-governance.agent.md) as the single manual entrypoint for architecture generation, review, ADR governance, and drift validation.
- Use [`reusable-agents/legacy-migration/migration-orchestrator.agent.md`](reusable-agents/legacy-migration/migration-orchestrator.agent.md) for controlled migration workflows with tracker-backed phases and gates.
- Do not route users directly to architecture specialist subagents in normal use; the architecture orchestrator delegates to them.

## Source Of Truth

- For pilot orchestration, use `.github/pilots/<pilot-id>/state.yaml` as machine-readable truth and `.github/pilots/<pilot-id>/tracker.md` as the human-readable operating view.
- For pilot activity selection and sequencing, defer to [Pilot-Planning-Guide.md](Pilot-Planning-Guide.md) rather than recreating cluster logic in ad hoc responses.
- For architecture outputs, store artefacts under `docs/architecture/<system-name>/` when running the architecture workflow described in [README.md](README.md).

## Editing Guidance

- Keep changes focused on documentation, agent definitions, skills, templates, and related markdown assets unless the user explicitly asks for broader repo restructuring.
- When asked to improve agent usability, prefer updating the relevant customization file or adding a small repo-level instruction rather than duplicating workflow content already documented elsewhere.
- If a task is really about applying these materials inside another pilot codebase, make that explicit and avoid treating this repository itself as the target system under analysis.