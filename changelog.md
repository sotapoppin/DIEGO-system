# Diego Changelog

Every approved schema change to Diego, dated, with rationale. The full proposal lives in `proposals/`; this file is the chronological index.

Format:
```
## [YYYY-MM-DD] <short title>
**File:** <path> · **Proposal:** [[proposals/...]]
What changed. Why. What to watch for.
```

---

## [2026-04-27] initial schema (v0.1)
**File:** root + spaces/* · **Proposal:** none (initial design)

Created Diego as a system/vault split: schema and meta content in the version-controlled system repo, personal data in a local-only vault. Three spaces (life, work, meta) with a top-level router. Identity in root `CLAUDE.md`; operational schemas per-space.

What to watch for: routing failures (Diego picks the wrong space), meta-loop friction (proposal cycle too heavy or too light), and — most critically — any leakage of vault content into system files. The last would be a serious failure of the public-meta discipline rule.
