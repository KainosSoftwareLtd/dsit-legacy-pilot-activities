# Tool Report Parsers

How to extract accessibility failures from the output formats of common tools.
For each tool, the goal is to produce a normalised list of findings in this shape:

```
{
  rule_id:       string,   // e.g. "aria-allowed-attr"
  title:         string,   // human-readable rule name
  description:   string,
  impact:        "critical" | "serious" | "moderate" | "minor" | null,
  wcag_tags:     string[], // e.g. ["wcag2a", "wcag412"]
  elements:      [{ selector, snippet, explanation }],
  page_url:      string,
  source_file:   string    // path of report file
}
```

---

## Lighthouse JSON

Lighthouse writes a single JSON file per page run. Key structure:

```json
{
  "lighthouseVersion": "13.x.x",
  "finalDisplayedUrl": "https://...",
  "audits": {
    "<rule-id>": {
      "id": "...",
      "title": "...",
      "description": "...",
      "score": 0 | 1 | null,
      "scoreDisplayMode": "binary" | "notApplicable" | "informative",
      "details": {
        "type": "table",
        "items": [ { "node": { "selector", "snippet", "explanation" } } ],
        "debugData": {
          "impact": "critical" | "serious" | "moderate" | "minor",
          "tags": ["wcag2a", "wcag412", ...]
        }
      }
    }
  }
}
```

**Extraction rules:**
- Include only audits where `score === 0` AND `scoreDisplayMode === "binary"`.
- Skip audits where `scoreDisplayMode === "notApplicable"`.
- Impact and WCAG tags live in `audits[id].details.debugData`.
- Each failing element is in `details.items[n].node` with `selector`, `snippet`, `explanation`.
- `finalDisplayedUrl` is the page URL.
- Multiple Lighthouse files = multiple pages; group by rule ID across files.

**Lighthouse accessibility score:** The overall score is a weighted average — a score of 100
does not mean zero failures (some audits are not weighted). Always parse `score === 0` audits
regardless of the overall score.

---

## axe-core / axe DevTools JSON

axe writes results with a `violations` array. Typical shape:

```json
{
  "violations": [
    {
      "id": "color-contrast",
      "description": "...",
      "help": "...",
      "helpUrl": "...",
      "impact": "serious",
      "tags": ["cat.color", "wcag2aa", "wcag143"],
      "nodes": [
        {
          "html": "<button ...>",
          "target": ["button.btn-danger"],
          "failureSummary": "Fix any of the following: ...",
          "any": [...],
          "all": [...],
          "none": [...]
        }
      ]
    }
  ],
  "passes": [...],
  "incomplete": [...],
  "inapplicable": [...]
}
```

**Extraction rules:**
- Extract from `violations` array only (not `passes`, `inapplicable`).
- `incomplete` items are worth noting — they represent checks axe could not automate; flag
  them as Low confidence manual-check items.
- `nodes[n].target` is the CSS selector (array — join with space or ` > `).
- `nodes[n].html` is the snippet.
- `failureSummary` is the explanation.
- Tags include both category tags (e.g. `cat.aria`) and WCAG tags (e.g. `wcag412`); keep
  only WCAG-prefixed tags for SC mapping.

---

## pa11y JSON

pa11y can output an array of issues per page, or an object keyed by URL:

```json
[
  {
    "code": "WCAG2AA.Principle4.Guideline4_1.4_1_2.H91.InputText.Name",
    "type": "error" | "warning" | "notice",
    "message": "...",
    "context": "<input ...>",
    "selector": "html > body > ... > input",
    "runner": "htmlcs" | "axe"
  }
]
```

**Extraction rules:**
- Extract `type === "error"` items first; include `"warning"` items at lower priority.
- The `code` field encodes the WCAG SC: `WCAG2AA.Principle4.Guideline4_1.4_1_2` = SC 4.1.2.
  Parse: after `WCAG2AA.Principle<N>.Guideline<X_Y>.` the next segment is the SC in
  underscore notation (`4_1_2` → 4.1.2). `WCAG2A` codes are Level A; `WCAG2AA` are Level AA.
- `context` is the HTML snippet; `selector` is the CSS path.
- pa11y does not expose an `impact` field directly — map to impact using the WCAG SC level
  (Level A failures = treat as serious; Level AA = moderate) unless runner is axe, in which
  case the impact can be inferred from the axe rule ID using the axe section above.
- Multiple pa11y files or multi-URL outputs: group by rule code across URLs.

---

## pa11y CSV

pa11y can output CSV. Columns are typically:

```
type,code,message,context,selector
```

Read as CSV, then apply the same rules as the JSON format above.

---

## WAVE JSON

WAVE exports look like:

```json
{
  "status": { "success": true },
  "statistics": { ... },
  "categories": {
    "error": {
      "count": 4,
      "items": {
        "alt_missing": {
          "id": "alt_missing",
          "description": "Missing alternative text",
          "count": 2,
          "wcag": ["1.1.1"],
          "items": [
            { "id": "...", "description": "...", "xpath": "...", "selector": "..." }
          ]
        }
      }
    },
    "contrast": { ... },
    "alert": { ... },
    "feature": { ... },
    "structure": { ... },
    "aria": { ... }
  }
}
```

**Extraction rules:**
- Extract from `categories.error` and `categories.contrast` (failures).
- `categories.alert` = warnings — include at lower confidence.
- `item.wcag` gives SC numbers directly (e.g. `["1.1.1"]`); map to Level from the
  `references/wcag22-criteria.md` table.
- WAVE does not expose an axe-style `impact` field — treat `error` as serious/critical,
  `contrast` as serious (maps to SC 1.4.3 AA), `alert` as moderate.

---

## How to handle multiple tools on the same page

When two or more tools report the same underlying defect:

1. **Merge** into a single finding — don't list the same issue twice.
2. **Boost confidence** to High if two or more tools independently flag the same element.
3. **Use the most specific description** — prefer axe or Lighthouse explanations over pa11y's
   WCAG code descriptions, which tend to be generic.
4. Note all tool sources in the finding's metadata.

---

## Identifying the tool format

If the file type is ambiguous, use these heuristics:

| Signal | Tool |
|--------|------|
| Top-level `lighthouseVersion` key | Lighthouse |
| Top-level `violations` array | axe-core |
| Array of objects with `code` starting `WCAG2` | pa11y |
| Top-level `categories` with `error`/`contrast` | WAVE |

If none match, try to detect common structures and note the uncertainty in the output.
