---
name: saas-goldmine
description: Audit projects to identify SaaS product potential with brutal honesty. Use when analyzing codebases, side projects, or client work to evaluate monetization viability. Performs competitive analysis, persona identification, market sizing, monetization planning with implementable billing logic, and extraction planning. Thinks like a business person, not a developer - evaluates what's actually sellable, not what's technically impressive.
---

# SaaS Goldmine: Project Audit & Monetization Skill

## Philosophy

**BE REAL. AND THOROUGH.**

An awesome project is NOT automatically gold. Technical excellence ≠ viable product. Evaluate from a business lens:
- Would someone PAY for this? Who exactly?
- How many competitors exist? Are they better? Why would anyone choose this?
- Can this actually be marketed? What's the acquisition strategy?
- Is the monetization plan enforceable and logical?

## Audit Workflow

### Phase 1: Project Reconnaissance

1. **Map the codebase structure**
   ```bash
   find . -type f -name "*.md" -o -name "*.json" -o -name "package.json" -o -name "requirements.txt" | head -50
   ```

2. **Identify what it does** - Read README, main entry points, config files

3. **Catalog features** - List every distinct capability:
   - Core features (the main value proposition)
   - Secondary features (nice-to-haves)
   - Infrastructure/glue code (not sellable)

4. **Assess technical state**:
   - Production-ready vs prototype
   - Test coverage existence
   - Documentation quality
   - Tech debt indicators

### Phase 2: Gold Identification (Brutal Honesty Required)

For each potential "gold nugget" identified, run through the **Value Validation Matrix**:

| Question | Red Flag | Green Flag |
|----------|----------|------------|
| Does this solve a PAINFUL problem? | "Nice to have" | "I need this NOW" |
| Would someone pay monthly for this? | One-time value | Recurring value |
| Can a non-technical person understand the value in 10 seconds? | Requires explanation | Obvious benefit |
| Is there existing demand? | "We'll create the market" | People searching for solutions |
| Can you reach buyers? | B2B enterprise (long sales) | Clear acquisition channel |

**Gold Categories**:
- **Pure Gold**: Complete, differentiated solution with clear market
- **Raw Gold**: Strong core that needs refinement  
- **Fool's Gold**: Technically impressive but not monetizable
- **Buried Gold**: Hidden value not obvious from surface

See `references/gold-evaluation.md` for detailed scoring framework.

### Phase 3: Competitive Analysis (No Delusions)

**REQUIRED**: Research and document actual competitors.

1. **Direct Competitors**: Same solution, same market
2. **Indirect Competitors**: Different solution, same problem  
3. **Substitutes**: How people solve this today without software

For each competitor, document:
- Pricing (exact tiers)
- Feature comparison
- Their weaknesses (your opportunity)
- Their strengths (your threats)
- Market position & funding

**The Honest Questions**:
- If [Competitor X] exists, why would anyone choose this?
- What's the defensible moat?
- Is this a feature of a bigger product, not a standalone?

See `references/competitive-analysis.md` for framework.

### Phase 4: Persona & Market Sizing

**Persona Requirements** (not optional):
- Job title/role
- Company size/type  
- Specific pain point this solves for THEM
- Where they hang out (acquisition channel)
- Willingness to pay (evidence-based)
- Decision-making authority

**Market Sizing Reality Check**:
- TAM/SAM/SOM with actual math
- Is this a $1M, $10M, or $100M opportunity?
- Be conservative. Then cut it in half.

See `references/persona-framework.md` for templates.

### Phase 5: Monetization Plan (Implementable, Not Theoretical)

**Critical Rule**: Only propose limits you can ENFORCE technically.

**Billing Model Selection**:

| Model | Works For | Enforcement | Complexity |
|-------|-----------|-------------|------------|
| Per seat | Team tools | Auth/invite system | Medium |
| Usage-based | APIs, compute | Metering system | High |
| Feature-gated | Clear tier differentiation | Feature flags | Low |
| Flat rate | Simple tools | Payment check | Lowest |

**Enforcement Reality Check**:
- "Per organization" → How do you detect organizations?
- "Per project" → What defines a project boundary?  
- "API calls" → Can they cache/bypass? Do you have metering?
- "Storage" → Do you have quota enforcement?

**Pricing Tier Design**:
```
FREE TIER PURPOSE: 
- Lead generation, not charity
- Must have friction point that pushes to paid
- Time-limited OR capability-limited (not both)

PAID TIER LOGIC:
- Price anchored to value delivered, not cost
- Each tier must have clear "why upgrade" trigger
- Enterprise tier = "call us" only if you can actually do sales
```

See `references/monetization-models.md` for detailed billing logic patterns.

### Phase 6: Extraction & SaaS-ification Plan

**What Needs to Change**:

1. **Multi-tenancy** - Data isolation, auth system, tenant provisioning
2. **Billing Integration** - Stripe/Paddle, webhooks, dunning
3. **Usage Metering** (if usage-based) - What/where to meter, quota enforcement
4. **Operational Requirements** - Monitoring, support, onboarding
5. **Legal/Compliance** - ToS, Privacy Policy, DPA if B2B

See `references/extraction-checklist.md` for full implementation guide.

## Output Format

Generate a report with these sections:

```markdown
# SaaS Goldmine Audit: [Project Name]

## Executive Summary
[One paragraph: Is this gold? What kind? What's the path?]

## The Verdict
🏆 GOLD TYPE: [Pure Gold / Raw Gold / Fool's Gold / Buried Gold / Not Gold]
💰 REVENUE POTENTIAL: [$X/month realistic, $Y/month optimistic]
⏱️ TIME TO REVENUE: [X weeks/months]
🎯 CONFIDENCE LEVEL: [High/Medium/Low with reasoning]

## What We Found

### The Gold
[What's actually valuable and why]

### The Dirt  
[What's NOT valuable despite looking good]

## Competitive Landscape
[Honest assessment with named competitors]

## Target Persona
[Specific, actionable persona with acquisition strategy]

## Monetization Plan

### Pricing Tiers
[Specific tiers with specific limits and specific prices]

### Billing Implementation
[How to actually implement this technically]

### Enforcement Mechanisms
[How each limit is enforced]

## Extraction Plan

### Phase 1: [X weeks]
[Specific tasks]

### Phase 2: [X weeks]  
[Specific tasks]

### Risks & Blockers
[What could go wrong]

## Go/No-Go Recommendation
[Final verdict with clear reasoning]
```

## Anti-Patterns to Avoid

❌ "This is a great idea!" without market validation  
❌ Comparing to successful companies without acknowledging their advantages  
❌ Pricing based on "what feels right"  
❌ Limits that can't be enforced  
❌ "Everyone needs this" (no one does)  
❌ Ignoring that incumbents exist  
❌ Assuming technical quality = market success
