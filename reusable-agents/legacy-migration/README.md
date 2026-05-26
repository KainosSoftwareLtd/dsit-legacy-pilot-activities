# Legacy Migration Agents

This folder defines the migration workflow for a simplified plan-and-iterate model.

## Prerequisites

Before running the migration agents, the project team must be able to perform the following on the target repository:

- Build the codebase successfully using the project-standard build command.
- Run integration and E2E tests locally or in a controlled CI-equivalent environment.
- Install and run Docker, including building images and running containers.
- Install project toolchain dependencies required by the repo (for example runtime SDKs, package managers, build tools, and test runners).
- Access repository manifests and lock files so dependency/version analysis can run.
- Provide write access for migration artefacts under .github/migrations/<migration-id>/.
- Provide approved technical preferences under target/preferences.md before baseline remediation and planning.
- Provide network and credential access needed for non-production test dependencies (such as local test databases or approved mocks).

Recommended readiness checks before kickoff:

- Verify build command returns success.
- Verify integration and E2E test commands execute and return results.
- Verify docker build and docker run commands work in the local environment.
- Verify required language/tool versions match repository expectations.
- Verify OpenRewrite execution path is available for recipe-supported uplifts where applicable.

## Lifecycle

The orchestrated lifecycle is:

1. Discover
2. Target
3. Baseline
4. Planning
5. Execution
6. Evaluate

## Human-In-The-Loop Gates

Human approval is required at:

- Discover completion
- Target completion
- Migration plan approval before Execution
- Final completion approval after unified release-readiness gate pass

## Baseline Policy

Baseline is a hard gate before Planning.

Baseline must:

- verify build and test commands
- map Discover functionality to existing E2E and integration tests
- add missing high-risk E2E or integration tests following existing repository standards
- execute and record evidence for added tests

Execution must use the baseline test set for evaluation.

## Planning Policy

Planning is unified, not slice-based.

Planning outputs are:

- .github/migrations/<migration-id>/planning/plan.md
- .github/migrations/<migration-id>/planning/version-uplift-inventory.md
- .github/migrations/<migration-id>/planning/containerization-plan.md

OpenRewrite rule:

- if a public OpenRewrite recipe exists for an uplift, OpenRewrite is mandatory
- if no public recipe exists, manual path must be documented with rationale

## Execution Policy

Execution is iterative until required tests pass.

Execution must:

- apply OpenRewrite-supported uplifts early
- implement remaining plan changes in bounded batches
- run build and required tests after each batch
- continue until existing baseline integration and E2E tests pass

Execution must not create new tests for evaluation.

## Containerized End-State Criteria

Execution gate requires:

- docker build success
- tests run in container context
- documented runtime command

## Agent Set

Primary agents:

- migration-orchestrator.agent.md
- legacy-system-analyst.agent.md
- target-architecture-intent.agent.md
- behaviour-baseline-characterisation-testing.agent.md
- e2e-test-assessment-remediation.agent.md
- migration-plan.agent.md
- openrewrite-version-uplift.agent.md
- migration-implementation.agent.md
- release readiness gate agent
- drift-retrospective-learning.agent.md

## Evidence Contract

For command execution evidence, record:

- exact command
- exit code
- execution timestamp
- pass/fail summary
- failure classification when applicable
