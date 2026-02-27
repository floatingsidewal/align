# Decision: ML Training vs Context Engineering for Product Knowledge

**Status:** Accepted
**Date:** 2026-02-27
**Context:** How to make AI agents effective for product-specific work

## Summary

When augmenting AI agents with product-specific knowledge, **context injection (RAG) beats custom model training** for most use cases. The data you'd use to train a model is more valuable as retrievable context.

## The Question

What ML training data could be extracted from product codebases to augment AI agents' ability to support the product? And is it worth putting this into custom ML models or just making the data sources available to general purpose agents?

## Data Sources Worth Extracting

### High-Value (Structured Knowledge)

| Source | What It Captures | Format |
|--------|------------------|--------|
| **Git history + PR reviews** | Why decisions were made, what was rejected | Commit messages, review comments |
| **Issue → PR mappings** | Problem → solution patterns | Linked pairs |
| **Test cases + fixtures** | Expected behavior, edge cases | Code + assertions |
| **Error logs + resolutions** | Failure modes and fixes | Log patterns → commit pairs |
| **API call patterns** | How components interact | Trace data, sequence diagrams |
| **Schema evolution** | How data models change over time | Migration history |

### Medium-Value (Tribal Knowledge)

| Source | What It Captures |
|--------|------------------|
| **Slack/Teams threads** | Debug sessions, "how do I..." answers |
| **Incident postmortems** | Failure patterns, recovery procedures |
| **Onboarding docs decay** | What's actually still accurate |
| **Code comments vs. behavior** | Drift between intent and reality |

## Decision: Context Injection Wins

### When Context Injection (RAG) is Better

- Codebase < 10M tokens of relevant context
- Knowledge changes frequently (active development)
- You need explainability ("why did it suggest this?")
- Budget/complexity constraints
- You want to use frontier models

### When Custom Fine-tuning Might Help

- Highly specialized domain (medical devices, trading systems)
- Consistent patterns repeated thousands of times
- Latency-critical (can't afford retrieval step)
- Proprietary "taste" that's hard to articulate

## Recommended Architecture

```
┌─────────────────────────────────────────────┐
│           General Purpose LLM               │
├─────────────────────────────────────────────┤
│  Injected Context (per-request):            │
│  • Relevant standards (align/)              │
│  • Similar past PRs (vector search)         │
│  • Active overrides                         │
│  • Error pattern database                   │
├─────────────────────────────────────────────┤
│  Indexed Knowledge (searchable):            │
│  • Full codebase (embeddings)               │
│  • Issue/PR history                         │
│  • Documentation                            │
│  • Runbooks                                 │
└─────────────────────────────────────────────┘
```

## Rationale

### Why Not Custom Models

1. **Frontier models improve** — Your fine-tune becomes stale, but your indexed knowledge works with each new model release

2. **Debugging is possible** — When the agent suggests something wrong, you can trace which retrieved context caused it

3. **Incremental updates** — Add new knowledge without retraining

4. **The align framework already scaffolds this** — Standards, specs, overrides are all structured knowledge injection

### The Real Investment

Instead of training, invest in **structured extraction**:

1. **Build a "decision database"** — Every PR that had > 2 review rounds, capture the discussion as a training example

2. **Index error → fix pairs** — When an error appears in logs and gets fixed, link them

3. **Capture "negative examples"** — Code that was written then reverted, with the reason

4. **Structured runbooks** — Not prose, but step-by-step with decision points (this is what `align/support/` is for)

## How Align Implements This

The align framework is essentially a structured context injection system:

| Align Component | Knowledge Type |
|-----------------|----------------|
| `align/standards/` | Coding patterns, conventions |
| `align/features/` | Feature context, decisions made |
| `align/support/` | Troubleshooting, runbooks |
| `align/overrides/` | Temporary patches, production knowledge |
| `align/skills/` | Reusable procedures |

Commands like `/inject-standards` and `/align-override-check` inject this knowledge at the right time.

## Future Considerations

If considering custom training later, the extracted data should be:

- **Structured as pairs** — Input (problem/context) → Output (solution/decision)
- **Versioned** — Track when knowledge was valid
- **Scored** — Rate by outcome (did the fix work? was the PR merged?)

This data format works for both RAG retrieval and potential future fine-tuning.

## Conclusion

Don't train custom models. Invest in structured knowledge extraction and context injection. The align framework provides the scaffolding for this approach.
