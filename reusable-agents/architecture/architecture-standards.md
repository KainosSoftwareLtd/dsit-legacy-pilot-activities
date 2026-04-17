# Project-Specific Architecture Standards Template

Use this file to define architecture checks for a specific project, programme, or delivery context. The reusable cross-project baseline now lives in the architecture orchestrator agent itself. This template is only for project-level additions, restrictions, and acceptance criteria.

## How To Use This Template
- Copy this file to a project-owned path such as `docs/architecture/standards/project-architecture-standards.md`.
- Provide that path to the Architecture Docs and Governance Orchestrator when you want project-specific checks.
- Treat this file as authoritative for the project once selected.
- If you intentionally omit a standards area, the agent should report `not-defined-in-project-standard` for that area.
- Keep the outcome vocabulary aligned with the reusable baseline unless you have a strong reason to change it.

## Project Profile Metadata
- Project name: `<replace>`
- Standards profile name: `<replace>`
- Scope: `<replace>`
- In-scope systems: `<replace>`
- Primary stakeholders: `<replace>`
- Regulatory or policy constraints: `<replace>`
- Required sign-off roles: `<replace>`

## Assessment Outcome Vocabulary
Use one of these outcomes for each standards area unless the project explicitly defines additional values:
- `pass`: evidence satisfies the standard
- `partial`: some evidence exists but coverage or quality is incomplete
- `fail`: evidence shows the standard is not met
- `not-applicable`: the standard does not apply to the system or scope
- `not-defined-in-project-standard`: the project intentionally omitted that area

## Project-Specific Standards Areas

### 1. System Context And Boundaries
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 2. Runtime And Deployment Architecture
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 3. Integration And Interface Design
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 4. Data Architecture
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 5. Security And Privacy By Design
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 6. Resilience, Reliability, And Operability
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 7. Scalability And Performance
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 8. Change Governance And Decision Records
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 9. Evidence, Confidence, And Traceability
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

### 10. Review Closure And Follow-Up
Project-specific requirements:
- `<replace>`

Additional required evidence:
- `<replace>`

Closure rule:
- `<replace>`

## Project-Specific Mandatory Artefacts
- `<replace>`

## Project-Specific Review Gates
- `<replace>`

## Approved Deviations Or Waivers
- `<replace>`

## Notes For Agent Invocation
- Standards file path: `<replace>`
- When invoking the agent, include the standards file path alongside mode, system name, and scope.