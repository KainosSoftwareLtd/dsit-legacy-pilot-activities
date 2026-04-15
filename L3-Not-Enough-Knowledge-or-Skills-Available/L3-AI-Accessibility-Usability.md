# Activity: Using AI to Address Accessibility & Usability in a Legacy System

## 1) Why this activity (value and decision)

Use this activity to quickly establish an accessibility and usability baseline in a legacy system, prioritise remediation by user impact, and reduce rework/regressions through automated testing.

**Decision:** Run when you need an evidence-based plan for what accessibility issues you need to fix first, and when you want AI to accelerate analysis and pattern-based remediation while keeping human review as the release gate.

## 2) What we will do (scope and steps)

**Scope:** A focused accessibility and usability improvement pass on priority user journeys in a legacy system (WCAG 2.2 A/AA), balancing quick wins with high-impact fixes.

**Steps:**
1. Establish baseline (automated scan + targeted manual checks).
2. Triage and prioritise issues by journey impact and effort.
3. Remediate repeated patterns at scale with assisted code changes.
4. Add automated regression checks in CI/CD to prevent reintroducing issues.
5. Validate with assistive technology and keyboard-only testing (and user feedback where possible).
6. Capture learnings as reusable guidance (patterns, do/don't, examples).

## 3) How AI is used

**A — AI-assisted audit & triage:** Generate an initial issue list, map to WCAG 2.2 A/AA, and rank by user impact.

**B — AI-assisted remediation:** Propose fixes for repeated patterns; a human accessibility reviewer remains the approval gate.

**C — AI-assisted synthesis:** Summarise feedback/support tickets to uncover usability barriers automated tools miss.

**D — AI-assisted regression prevention:** Suggest tests and checks to reduce regressions over time.

## 4) Preconditions, access and governance

**Preconditions:** Confirm target journeys/pages, definition of system boundary, and the WCAG target (2.2 A/AA). Ensure you can build/run the system locally or in a test environment.

**Access:** Source repo access, ability to run automated scanners in the relevant environments, and access to representative UI states (roles, permissions, sample accounts).

**Governance:** Human accessibility review is mandatory before release. Record decisions (accepted risk, deferred items) and ensure changes follow established change-control and release processes.

## 5) Tooling categories and examples

- **Automated accessibility testing:** axe DevTools, Deque tools, Lighthouse, Pa11y.
- **Assistive technology for validation:** NVDA + Firefox, JAWS + Chrome/Edge, VoiceOver + Safari, keyboard-only testing.
- **Code assistance:** GitHub Copilot (or equivalent) for pattern-based remediation suggestions.
- **CI/CD integration:** Automated accessibility checks in pipelines; unit/integration tests for components and key flows.
- **Issue tracking:** Backlog tickets with WCAG mapping, severity, and reproducible steps.

## 6) Timebox

**Typical timebox:** Depends on system size and number of priority journeys.

**Suggested breakdown:** 1 day to baseline + triage, 1 day to trial remediation, 1 day to setup validation and regression, 0.5 days documentation updates.

## 7) Inputs and data sources

Source code (templates/components/styles), design system or UI standards (if any), user journey maps, analytics on top tasks, support tickets/feedback, existing audit reports, and CI/CD pipeline configuration. Include representative test data/accounts for different roles and states.

## 8) Outputs and artefacts

Baseline accessibility report (WCAG 2.2 A/AA mapped), prioritised remediation backlog, implemented code changes (PRs) with review notes, updated automated regression checks, validation notes (AT matrix + evidence), and reusable guidance (patterns, component examples, do/don't list).

## 9) Metrics and measurement plan

> Track metrics before/after and at each release thereafter.

| Metric area | What to measure |
|---|---|
| **Coverage** | % of priority journeys/pages scanned and manually spot-checked |
| **Compliance** | Count of WCAG 2.2 A/AA issues open vs fixed; pass rate in automated checks |
| **Severity** | Critical/Major/Minor issues by journey; number of blockers to task completion |
| **Regression** | New a11y issues introduced per release; pipeline a11y gate pass rate |
| **User impact** | Reduction in a11y-related support tickets; qualitative feedback from testing |
| **Delivery** | Lead time to fix top issues; % issues fixed within the timebox |
| **Quality of fixes** | Reopen rate; reviewer rejection rate; consistency with component standards |
| **Sustainability** | % components covered by a11y tests; number of reusable patterns added |

## 10) Risks and controls

| Risk | Control |
|---|---|
| Legacy systems often have deeply coupled UI and business logic, so even small accessibility fixes can have unintended side effects | Scope changes carefully, add regression tests, and test thoroughly in realistic environments |
| AI hallucination or incorrect WCAG mapping | Human accessibility review; validate against WCAG text and real AT behaviour |
| Over-reliance on automated scanners (misses focus order, labels, cognitive load) | Add targeted manual test script and AT validation matrix |
| Inconsistent fixes across the codebase | Prefer shared components/patterns; document "golden" examples; code review checklist |

## 11) Review and definition of done

**Review:** Accessibility reviewer validates fixes with automated checks plus AT/keyboard testing on priority journeys; engineering reviewer validates code quality and no functional regressions.

**Done when:** Baseline created; top-priority issues remediated or explicitly deferred with rationale; automated regression checks running in CI/CD; evidence captured (screenshots/logs where appropriate); and guidance updated for repeatability.

## 12) Playbook contribution

Add to the playbook:
1. The prompt(s) used and what worked
2. The triage model (severity + journey impact)
3. The AT validation checklist
4. CI/CD regression approach
5. Reusable remediated patterns/components with examples
