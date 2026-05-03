# Gold Evaluation Framework

## Scoring System

Rate each dimension 1-5. Total score determines gold type.

### 1. Problem Severity (Weight: 3x)

| Score | Description | Evidence |
|-------|-------------|----------|
| 1 | Mild inconvenience | "Would be nice" |
| 2 | Annoying but tolerable | Manual workarounds exist and are used |
| 3 | Significant friction | People complain about it actively |
| 4 | Major pain point | People already paying for partial solutions |
| 5 | Hair-on-fire problem | Urgent, frequent, costly when unsolved |

**Questions to Ask**:
- How often does this problem occur? (Daily = good)
- What happens if unsolved? (Money/time lost = good)
- Are people actively searching for solutions? (Google trends, forums)

### 2. Solution Completeness (Weight: 2x)

| Score | Description |
|-------|-------------|
| 1 | Proof of concept only |
| 2 | Works but missing critical features |
| 3 | Core functionality complete, needs polish |
| 4 | Production-ready with gaps |
| 5 | Complete, polished, differentiated |

### 3. Market Accessibility (Weight: 2x)

| Score | Description |
|-------|-------------|
| 1 | No clear path to customers |
| 2 | Expensive channels only (paid ads, enterprise sales) |
| 3 | Some organic channels possible |
| 4 | Clear community/content strategy |
| 5 | Viral potential or existing audience |

### 4. Competitive Moat (Weight: 2x)

| Score | Description |
|-------|-------------|
| 1 | Trivially replicable, giants in space |
| 2 | Some effort to replicate, weak differentiation |
| 3 | Meaningful differentiation or niche |
| 4 | Significant switching costs or network effects |
| 5 | Proprietary data, patents, or strong brand |

### 5. Revenue Model Clarity (Weight: 1x)

| Score | Description |
|-------|-------------|
| 1 | No idea how to charge |
| 2 | Charging model unclear or unenforceable |
| 3 | Clear model but unvalidated pricing |
| 4 | Comparable products validate pricing |
| 5 | Obvious value-based pricing with willing buyers |

## Score Interpretation

**Total Possible**: 50 points (after weighting)

| Score Range | Gold Type | Recommendation |
|-------------|-----------|----------------|
| 40-50 | **Pure Gold** | Ship it. Now. |
| 30-39 | **Raw Gold** | Worth refining with clear plan |
| 20-29 | **Buried Gold** | Pivot or find the hidden angle |
| 10-19 | **Fool's Gold** | Probably not worth it |
| <10 | **Not Gold** | Walk away |

## Red Flags That Override Scores

Even high scores can be invalidated by:

- **Winner-take-all market with established winner**: Stripe for payments, Slack for chat
- **Regulatory barriers**: Healthcare, finance without expertise
- **Requires behavior change**: People don't change unless pain is extreme
- **Two-sided marketplace**: Nearly impossible cold-start problem
- **Hardware dependency**: Capital intensive, distribution nightmare
- **B2B Enterprise only**: Long sales cycles, need sales team

## Gold Type Definitions

### Pure Gold ⭐⭐⭐⭐⭐
Complete, differentiated solution solving a validated problem with clear path to customers and revenue. Ship immediately.

### Raw Gold ⭐⭐⭐⭐
Strong core value but needs work. Missing features, unclear positioning, or needs market validation. Worth 2-8 weeks of refinement.

### Buried Gold ⭐⭐⭐
Value exists but not obvious. Might be:
- Wrong market positioning
- Feature buried in larger project
- Adjacent opportunity more valuable
- Need to pivot use case

### Fool's Gold ⭐⭐
Looks valuable due to:
- Technical impressiveness
- Personal attachment
- Sunk cost fallacy
- Imagined demand

Reality: No clear path to revenue.

### Not Gold ⭐
Learning project, portfolio piece, or technical exercise. Valuable for experience, not for business.
