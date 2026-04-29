# Activity: Decommission candidate assessment (L4)
Version: 0.1  
Owner: <assign>  
Date: <dd MMM yyyy>


| Field | Value |
|---|---|
| **Timebox** | 2-3h per candidate system |
| **Phase** | Execute (Weeks 2-4) |
| **Inputs** | Repository, architecture summary, service catalogue, operational data |
| **Key output** | Decommission candidate scorecard + dependency risk map |
| **Hub activity** | No |

---

## 1) Why this activity (value and decision)
Legacy estates accumulate services that are no longer needed, have been functionally replaced, or serve only a handful of residual consumers. These systems still carry operational cost, security exposure, and cognitive load for teams who must maintain them. Identifying which services can be safely switched off is a high-value, low-risk way to reduce the legacy footprint — but only if the analysis is thorough enough to avoid breaking downstream consumers.

This activity uses AI to analyse a candidate system's actual usage, integration surface, and business function overlap, then classifies it into one of three decommission categories: **fully replaceable** (another system already covers 100 % of the function), **partially replaceable** (most function is covered but residual capability must be migrated or retired), or **no longer needed** (the business function itself has been retired or has no active consumers).

Decision enabled: proceed to decommission planning, migrate residual consumers first, or keep the system with a documented rationale.


---

## 2) What we will do (scope and steps)
Description: Assess one or more candidate systems for decommissioning by analysing usage, dependencies, and business function overlap.

Sub tasks:
1. Identify candidate systems from the service catalogue, architecture summary, or team knowledge. Inputs may include low-traffic services, systems flagged as redundant, or systems with a known replacement already in service.
2. For each candidate, use the AI assistant to map the integration surface: (a) inbound consumers — what calls this service, references its data, or depends on its outputs? (b) outbound dependencies — what does this service call or write to? (c) shared resources — databases, queues, file stores, or config shared with other services.
3. Assess current usage signals: analyse available logs, traffic metrics, API call volumes, batch job schedules, and user access patterns to determine whether the service is actively used. Flag services with zero or near-zero usage over a defined lookback period.
4. Map business function overlap: compare the candidate's capabilities against other services in the estate. Identify whether the function is (a) fully covered elsewhere, (b) partially covered with residual gaps, or (c) unique to this system.
5. Classify the candidate into one of three categories:
   - **Fully replaceable** — another system already provides 100 % of the function; consumers can be redirected.
   - **Partially replaceable** — most function is covered elsewhere but specific capabilities, data, or integrations require migration or explicit retirement before switch-off.
   - **No longer needed** — the business function itself has been retired, has no active consumers, or the data is no longer required.
6. For each candidate, document: classification, evidence supporting the classification, residual risks, and recommended next steps (proceed to decommission plan, migrate consumers first, or retain with rationale).
7. Review with the Service Owner and Solution Architect.
8. Log time spent (start/end timestamps) for P1 measurement.

> **Sequencing:** this activity benefits from an Architecture Summary (L3) and Change Impact Mapping (L4) having been run first. It can feed into migration activities (L5) if residual consumers need to move. Schedule during Weeks 2-4.

> **Out of scope:**
> - Executing the decommission (switch-off, data archival, DNS removal). This activity assesses candidates; decommission execution is a separate, governed process.
> - Data retention and archival decisions — flag these as required follow-ups but do not resolve them here.
> - Commercial or contractual analysis of vendor agreements tied to the service.

---

## 3) How AI is used (options and modes)
- **Retrieve and ground:** scan the repository, configuration, API definitions, and infrastructure-as-code to map the integration surface and identify all consumers and dependencies.
- **Analyse and reason:** cross-reference usage data (logs, traffic, schedules) with the integration map to assess whether the service is actively consumed. Compare the candidate's capabilities against other services to identify overlap and residual gaps.
- **Generate:** produce the decommission candidate scorecard with classification, evidence, residual risks, and next steps.
- **Human in the loop:** the engineer validates the integration map and usage analysis against operational knowledge. The Service Owner confirms whether the business function is still required. The Solution Architect reviews the classification and risk assessment.


---

## 4) Preconditions, access and governance
- Read access to the candidate system's repository, configuration, and infrastructure definitions.
- Access to usage data: application logs, API gateway metrics, traffic dashboards, or batch job schedules. If usage data is unavailable, note this as a lower-confidence assessment.
- Architecture Summary (from L3, if available) or equivalent knowledge of the wider service estate.
- Service catalogue or equivalent list of systems and their owners.
- Named reviewers: Service Owner (for business function validation) and Solution Architect (for technical risk review).
- ATRS trigger: No (assessment only). DPIA check: flag if the candidate system processes personal data, as decommission planning will need to address data retention.


---

## 5) Tooling categories and examples
Use department-approved tools. Names below are illustrative examples only.

| Category | Examples | Notes |
|---|---|---|
| AI code reasoning | an enterprise LLM with repository access |  |
| Code assistants | GitHub Copilot, Sourcegraph Cody, Cursor | for tracing integration points across repos |
| Reusable architecture agent | [Architecture Docs and Governance Orchestrator](../reusable-agents/architecture/architecture-docs-governance.agent.md) | Use the orchestrator as the only entrypoint; it will update architecture context if needed |
| Observability and usage analysis | Splunk, Datadog, Grafana, CloudWatch, ELK stack | for traffic, API call volumes, and batch schedules |
| Static analysis and dependency graphing | Sourcegraph search, IDE dependency features, madge (JS), NDepend (.NET) | for mapping inbound/outbound integrations |
| Service catalogue | ServiceNow, Backstage, internal CMDB |  |
| Notes and reporting | Markdown, Confluence, spreadsheets |  |


---

## 6) Timebox
Suggested: 2h per candidate system for integration mapping, usage analysis, and classification. Add 30 minutes for the review with Service Owner and Solution Architect. Total: 2-3h per candidate.

Expandability: this activity can be repeated per candidate system. Batch assessment of multiple low-complexity services may be faster (1-1.5h each) once the approach is established.


---

## 7) Inputs and data sources
- Candidate system repository (source code, configuration, API specs, infrastructure-as-code).
- Architecture Summary (from L3, if available) for estate-wide context and component relationships.
- Service catalogue or CMDB entries listing system owners, purpose, and status.
- Usage and traffic data: application logs, API gateway metrics, batch job schedules, user access logs (lookback period: 3-12 months recommended).
- Change history: recent commits, deployments, and change requests as a proxy for active development.
- SBOM or dependency map (from L1, if available) for shared-dependency context.
- If unavailable: if usage data does not exist, note this explicitly. Classification confidence will be lower and should be flagged in the scorecard.


---

## 8) Outputs and artefacts
- **Decommission candidate scorecard:** for each assessed system — classification (fully replaceable / partially replaceable / no longer needed), supporting evidence, confidence level, residual risks, and recommended next steps.
- **Dependency risk map:** inbound consumers, outbound dependencies, and shared resources for each candidate, with an impact assessment for each if the service is switched off.
- **Residual action list:** required follow-ups before decommission can proceed (e.g. consumer migration, data archival, DNS/redirect changes, contract review).
- Time log entry for P1.

Audience: Service Owner, Solution Architect, Delivery Manager, and governance boards reviewing decommission proposals.


---

## 9) Metrics and measurement plan (map to P1-P8)

| Metric | Measurement approach |
|---|---|
| **P1 — Task Time Delta** | Record time to produce the candidate assessment with AI assistance. Compare against an estimate for manual integration tracing and usage analysis for the same system. Use median where multiple candidates are assessed. |
| **P2 — Quality Score** | Service Owner and Solution Architect jointly rate the scorecard on the 1-5 rubric: accuracy of the integration map, completeness of usage evidence, and actionability of the classification and next steps. Note any score below 3 with explanation. |
| **P7 — Vulnerability / Risk Reduction** | Count of systems classified and accepted for decommission. Track the reduction in operational risk surface: number of services removed from the estate, associated vulnerabilities no longer requiring patching, and reduction in operational support burden. Use directional evidence where precise counts are not available. |
| **P8 — Reusable Artefacts** | Count of reusable outputs: scorecard template, classification rubric, integration mapping prompts, usage analysis queries. Include a link to each artefact. |

Secondary:
- **P3 — Developer Sentiment (SPACE):** include in the post-pilot SPACE survey — specifically whether the team found the AI-assisted decommission analysis trustworthy and actionable.
- **P5 — Change Failure Rate (DORA):** if decommission proceeds during the pilot, track whether any switch-off causes incidents or requires rollback. This validates the quality of the dependency risk map.


---

## 10) Risks and controls

| Risk | Mitigation |
|---|---|
| **AI misses hidden consumers:** the AI may not detect integrations configured outside the repository (e.g. external systems calling undocumented endpoints, scheduled jobs managed in a separate orchestrator, manual data extracts) | Cross-reference AI analysis with the Service Owner's knowledge of consumers; check API gateway logs and network flow data where available; include a "known unknowns" section in the scorecard |
| **Usage data is incomplete or unavailable:** if logging is minimal, the AI cannot reliably determine whether the service is actively used | Note the data gap in the scorecard and lower the classification confidence; recommend a monitoring soak period before proceeding to decommission |
| **Overlap analysis is superficial:** the AI may flag functional overlap based on naming or API similarity without understanding business logic differences | Require the Service Owner to validate functional equivalence; document specific capabilities that are and are not covered by the replacement |
| **Premature classification leads to unsafe switch-off:** a system classified as "no longer needed" may still have undiscovered consumers | Classification is a recommendation, not an approval. Decommission execution must follow the department's change-control process, including a controlled switch-off period (e.g. disable then wait before full removal) |
| **Data retention obligations overlooked:** switching off a service does not remove the obligation to retain or archive its data | Flag data retention as a required follow-up action in every scorecard; do not classify as "ready to decommission" until data handling is addressed |


---

## 11) Review and definition of done
Done when all of the following are true:
- [ ] Each candidate system has a completed scorecard with classification, evidence, and confidence level.
- [ ] Integration surface (inbound, outbound, shared resources) is mapped for each candidate.
- [ ] Usage evidence is documented, or data gaps are explicitly noted.
- [ ] Business function overlap is validated with the Service Owner.
- [ ] Residual actions (consumer migration, data archival, etc.) are listed.
- [ ] Solution Architect has reviewed and accepted the risk assessment.
- [ ] Time log entry is recorded for P1.
- [ ] Evidence Log and Evaluation Scorecard are updated.


---

## 12) Playbook contribution
- **Where AI helped:** speed of integration mapping across codebases; surfacing usage patterns from logs; identifying functional overlap between services.
- **Prerequisites to document:** quality and availability of usage data; completeness of the service catalogue; availability of architecture context.
- **Limits and risks to document:** hidden consumers not in code, incomplete logging, superficial overlap matching, data retention blind spots.
- **Reusable assets:** scorecard template, classification rubric (fully replaceable / partially replaceable / no longer needed), integration mapping prompts, usage analysis query templates.
