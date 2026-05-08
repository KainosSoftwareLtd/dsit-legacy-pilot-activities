# WCAG 2.2 Success Criteria Reference

Quick-reference for mapping tool-reported WCAG tags to WCAG 2.2 success criteria.
Tool tags use the format `wcag<chapter><criterion>` (e.g. `wcag412` = SC 4.1.2).

---

## Level A Criteria (must pass for minimum conformance)

| SC | Name | Common axe rule IDs |
|----|------|---------------------|
| 1.1.1 | Non-text Content | `image-alt`, `input-image-alt`, `area-alt`, `role-img-alt` |
| 1.2.1 | Audio-only and Video-only (Prerecorded) | *(manual)* |
| 1.2.2 | Captions (Prerecorded) | `video-caption` |
| 1.2.3 | Audio Description or Media Alternative (Prerecorded) | *(manual)* |
| 1.3.1 | Info and Relationships | `list`, `listitem`, `td-has-header`, `table-duplicate-name`, `landmark-*`, `label`, `select-name` |
| 1.3.2 | Meaningful Sequence | *(semi-manual)* |
| 1.3.3 | Sensory Characteristics | *(manual)* |
| 1.4.1 | Use of Color | *(manual)* |
| 1.4.2 | Audio Control | *(manual)* |
| 2.1.1 | Keyboard | `accesskeys` *(partial)* |
| 2.1.2 | No Keyboard Trap | *(manual)* |
| 2.1.4 | Character Key Shortcuts | *(manual)* — **NEW in WCAG 2.1** |
| 2.2.1 | Timing Adjustable | *(manual)* |
| 2.2.2 | Pause, Stop, Hide | *(manual)* |
| 2.3.1 | Three Flashes or Below Threshold | *(manual)* |
| 2.4.1 | Bypass Blocks | `bypass`, `landmark-one-main` *(partial)* |
| 2.4.2 | Page Titled | `document-title` |
| 2.4.3 | Focus Order | *(manual)* |
| 2.4.4 | Link Purpose (In Context) | `link-name` |
| 2.5.1 | Pointer Gestures | *(manual)* — **NEW in WCAG 2.1** |
| 2.5.2 | Pointer Cancellation | *(manual)* — **NEW in WCAG 2.1** |
| 2.5.3 | Label in Name | `label-content-name-mismatch` — **NEW in WCAG 2.1** |
| 2.5.4 | Motion Actuation | *(manual)* — **NEW in WCAG 2.1** |
| 3.1.1 | Language of Page | `html-has-lang`, `html-lang-valid` |
| 3.2.1 | On Focus | *(manual)* |
| 3.2.2 | On Input | *(manual)* |
| 3.3.1 | Error Identification | *(semi-manual)* |
| 3.3.2 | Labels or Instructions | `label`, `select-name`, `input-button-name` |
| 4.1.1 | Parsing | `duplicate-id`, `duplicate-id-active`, `duplicate-id-aria` |
| 4.1.2 | Name, Role, Value | `aria-allowed-attr`, `aria-required-attr`, `aria-roles`, `button-name`, `select-name`, `label`, `aria-hidden-focus` |

### WCAG 2.2 — New Level A criteria (not in 2.0 or 2.1)

| SC | Name | Notes |
|----|------|-------|
| 2.4.11 | Focus Not Obscured (Minimum) | Focused component not entirely hidden by sticky headers/overlays. Axe: no automatic rule yet — manual check. |
| 2.5.7 | Dragging Movements | Any drag operation must have a pointer alternative. Manual. |
| 2.5.8 | Target Size (Minimum) | Interactive targets ≥ 24×24 CSS px. Axe: `target-size` rule (experimental). |
| 3.2.6 | Consistent Help | Help mechanisms in consistent location across pages. Manual. |
| 3.3.7 | Redundant Entry | Don't ask for info already provided in same process. Manual. |

---

## Level AA Criteria (required for full WCAG 2.2 AA conformance)

| SC | Name | Common axe rule IDs |
|----|------|---------------------|
| 1.2.4 | Captions (Live) | *(manual)* |
| 1.2.5 | Audio Description (Prerecorded) | *(manual)* |
| 1.3.4 | Orientation | *(manual)* — **NEW in WCAG 2.1** |
| 1.3.5 | Identify Input Purpose | `autocomplete-valid` — **NEW in WCAG 2.1** |
| 1.4.3 | Contrast (Minimum) | `color-contrast` |
| 1.4.4 | Resize Text | *(manual)* |
| 1.4.5 | Images of Text | *(manual)* |
| 1.4.10 | Reflow | *(manual)* — **NEW in WCAG 2.1** |
| 1.4.11 | Non-text Contrast | `link-in-text-block` *(partial)* — **NEW in WCAG 2.1** |
| 1.4.12 | Text Spacing | *(manual)* — **NEW in WCAG 2.1** |
| 1.4.13 | Content on Hover or Focus | *(manual)* — **NEW in WCAG 2.1** |
| 2.4.5 | Multiple Ways | *(manual)* |
| 2.4.6 | Headings and Labels | *(semi-manual)* |
| 2.4.7 | Focus Visible | `focus-visible` (axe experimental) |
| 3.1.2 | Language of Parts | `html-xml-lang-mismatch` |
| 3.2.3 | Consistent Navigation | *(manual)* |
| 3.2.4 | Consistent Identification | *(manual)* |
| 3.3.3 | Error Suggestion | *(manual)* |
| 3.3.4 | Error Prevention (Legal, Financial, Data) | *(manual)* |
| 4.1.3 | Status Messages | `aria-live` patterns — **NEW in WCAG 2.1** |

### WCAG 2.2 — New Level AA criteria (not in 2.0 or 2.1)

| SC | Name | Notes |
|----|------|-------|
| 2.4.12 | Focus Not Obscured (Enhanced) | Stricter version of 2.4.11 — focused item entirely visible. Manual. |
| 2.4.13 | Focus Appearance | Focus indicator meets size and contrast requirements. Axe: no automatic rule yet — manual check. |
| 3.3.8 | Accessible Authentication (Minimum) | Cognitive tests (e.g. CAPTCHAs) must have alternatives. Manual. |

---

## Criteria removed or changed from WCAG 2.1 → 2.2

| SC | Change |
|----|--------|
| 2.4.11 (was 2.4.12 in 2.1 draft) | Renumbered; now formally published in 2.2 |
| 4.1.1 Parsing | **Obsolete in WCAG 2.2** — browsers handle malformed HTML gracefully; this SC is met by any page delivered as HTML. Still report duplicate IDs as they affect SC 4.1.2, but do not cite 4.1.1 as a WCAG 2.2 failure. |

---

## Tool tag → SC mapping cheat sheet

Most tools embed WCAG tags in the format `wcag<section><criterion>` with no dots:

| Tag | SC |
|-----|----|
| `wcag111` | 1.1.1 |
| `wcag131` | 1.3.1 |
| `wcag143` | 1.4.3 |
| `wcag211` | 2.1.1 |
| `wcag241` | 2.4.1 |
| `wcag311` | 3.1.1 |
| `wcag411` | 4.1.1 *(obsolete in 2.2)* |
| `wcag412` | 4.1.2 |

For tags not listed, split after the first digit: `wcag2aa` = Level AA, `wcag2a` = Level A
(these are level indicators, not SC references). Tags like `EN-9.4.1.2` are European standard
cross-references that map 1:1 to the equivalent SC (9.4.1.2 = SC 4.1.2).
