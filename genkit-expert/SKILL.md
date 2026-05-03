---
name: genkit-expert
description: Firebase Genkit expert for building AI-powered features in Angular 21 + Firebase/GCP apps, and Python FastAPI services on Cloud Run. Handles flows, tools, agents, RAG, prompts, chat, MCP, deployment, and evaluation. Consult this skill when implementing any Genkit-based AI feature.
---

# Genkit Expert: AI Features for Angular 21 + Firebase/GCP

## Identity

You are a Firebase Genkit expert specializing in building production AI features for:
- **Primary stack:** Angular 21 frontend + Firebase backend (Cloud Functions, Firestore, Hosting)
- **Secondary stack:** Python FastAPI services on Cloud Run
- **Platform:** Google Cloud (Vertex AI, Cloud Run, Firestore, Cloud Storage)

You know every Genkit API, pattern, and deployment strategy. You bridge the gap between raw LLM capabilities and production-ready AI features that integrate into the user's existing ecosystem.

## Reference Documentation

All Genkit docs are at: `docs/genkit/` in the project root. Key files:
- `genkit-reference.md` — Consolidated API reference (flows, models, tools, prompts, chat, RAG, MCP, evaluation, plugins)
- `deploy-firebase.md` / `deploy-cloud-run.md` — Deployment guides
- `multi-agent.md` — Multi-agent systems
- `integration-cloud-firestore.md` — Firestore vector store for RAG
- `integration-google-cloud.md` — Google Cloud plugin (telemetry, monitoring)

**Always consult these docs before answering questions or writing code.** Read the specific file relevant to the task.

---

## Core Genkit Concepts (Quick Reference)

### Initialization
```typescript
import { genkit, z } from 'genkit';
import { googleAI } from '@genkit-ai/google-genai';

const ai = genkit({
  plugins: [googleAI()],
  model: googleAI.model('gemini-2.5-flash'),
});
```

### Flows (Type-safe AI workflows)
```typescript
export const myFlow = ai.defineFlow(
  {
    name: 'myFlow',
    inputSchema: z.object({ query: z.string() }),
    outputSchema: z.object({ answer: z.string() }),
  },
  async ({ query }) => {
    const { text } = await ai.generate({ prompt: query });
    return { answer: text };
  },
);
```

### Tools (Give LLMs abilities)
```typescript
const myTool = ai.defineTool(
  {
    name: 'myTool',
    description: 'Does something useful',
    inputSchema: z.object({ param: z.string() }),
    outputSchema: z.string(),
  },
  async ({ param }) => { return `result for ${param}`; },
);

// Use in generate
const { text } = await ai.generate({
  prompt: 'Do the thing',
  tools: [myTool],
});
```

### Structured Output
```typescript
const schema = z.object({ name: z.string(), score: z.number() });
const { output } = await ai.generate({
  prompt: 'Generate a character',
  output: { schema },
});
```

### Streaming
```typescript
const { stream, response } = ai.generateStream({ prompt: 'Tell a story' });
for await (const chunk of stream) { console.log(chunk.text); }
```

### Dotprompt (.prompt files)
```dotprompt
---
model: googleai/gemini-2.5-flash
input:
  schema:
    topic: string
output:
  schema:
    title: string
    content: string
---
{{role "system"}}
You are a helpful assistant.
{{role "user"}}
Write about {{topic}}.
```

### Chat Sessions
```typescript
import { genkit } from 'genkit/beta';
const chat = ai.chat({ system: 'You are helpful.' });
const { text } = await chat.send('Hello');
```

### Interrupts (Human-in-the-loop)
```typescript
const confirm = ai.defineInterrupt({
  name: 'confirm',
  description: 'Ask user to confirm',
  inputSchema: z.object({ question: z.string() }),
  outputSchema: z.boolean(),
});
```

### RAG
```typescript
const docs = await ai.retrieve({ retriever: myRetriever, query, options: { k: 3 } });
const { text } = await ai.generate({ prompt: query, docs });
```

### Context Propagation
```typescript
await myFlow(input, { context: { auth: currentUser } });
// Access in flow: ({ context }) => context.auth.uid
// Access in dotprompt: {{@auth.name}}
```

### Middleware
```typescript
import { retry, fallback } from 'genkit/model/middleware';
await ai.generate({
  prompt: 'Hello',
  use: [
    retry({ maxRetries: 3 }),
    fallback(ai, { models: [googleAI.model('gemini-2.5-flash')] }),
  ],
});
```

---

## Deployment Patterns

### Firebase Cloud Functions (Primary)
```typescript
import { onCallGenkit } from 'firebase-functions/https';
import { defineSecret } from 'firebase-functions/params';

const apiKey = defineSecret('GEMINI_API_KEY');

export const myAiFunction = onCallGenkit(
  { secrets: [apiKey], authPolicy: hasClaim('email_verified') },
  myFlow,
);
```

### Express.js / Cloud Run
```typescript
import { startFlowServer } from '@genkit-ai/express';

startFlowServer({
  flows: [myFlow],
  port: parseInt(process.env.PORT || '3400'),
  cors: { origin: '*' },
});
```

### Python FastAPI + Genkit
For Python FastAPI services, Genkit flows can be called via HTTP:
```bash
curl -X POST "https://your-service.run.app/myFlow" \
  -H "Content-Type: application/json" \
  -d '{"data": {"query": "hello"}}'
```

Or use the Genkit JS client from the Angular app to call deployed flows.

### Client-Side (Angular)
Read `docs/genkit/client.md` for the `runFlow()` and `streamFlow()` client functions.

---

## Architecture Patterns

### Pattern 1: Angular Frontend → Firebase Cloud Function (Genkit Flow)
Best for: Simple AI features, chat, content generation
```
Angular 21 App → callable function → Genkit Flow → Gemini API
```

### Pattern 2: Angular Frontend → BFF (FastAPI) → Genkit
Best for: Complex orchestration, existing Python backend
```
Angular 21 App → FastAPI on Cloud Run → Genkit Express server → Gemini API
```

### Pattern 3: Agentic with Tools
Best for: AI agents that need to read/write data
```
Angular 21 App → Cloud Function → Genkit Flow + Tools (Firestore, APIs) → Gemini
```

### Pattern 4: RAG with Firestore Vector Store
Best for: Q&A over documents, knowledge bases
```
Indexing: PDF/docs → chunking → embeddings → Firestore vector store
Query: User question → retrieve docs → generate answer
```

### Pattern 5: Multi-Agent
Best for: Complex tasks requiring specialized agents
Read `docs/genkit/multi-agent.md` for delegation, routing, and handoff patterns.

---

## Decision Framework

### Which model to use?
| Use Case | Model | Why |
|---|---|---|
| Fast responses, simple tasks | `gemini-3-flash-preview` / `gemini-2.5-flash` | Speed, cost |
| Simple classification/routing | `gemini-2.5-flash-lite` | Cheapest |
| Complex reasoning, coding | `gemini-3.1-pro-preview` / `gemini-2.5-pro` | Best quality |
| Image generation (native) | `gemini-3-pro-image-preview` | Native multimodal gen |
| Image generation (dedicated) | `imagen-4.0-generate-001` | Best images |
| Embeddings | `gemini-embedding-001` | Best embeddings |
| TTS | `gemini-2.5-flash-preview-tts` | Speech |
| Computer use | `gemini-2.5-computer-use-preview-10-2025` | Browser automation |
| Deep Research (agent) | `deep-research-pro-preview-12-2025` | Long-form research |

### Flow vs generate() vs chat vs Interactions API?
- **Flow:** When you need type-safe I/O, deployment as API, tracing, testability (Genkit)
- **generate():** Quick one-off calls inside flows or scripts (Genkit)
- **Chat:** Multi-turn conversations with history management (Genkit)
- **Interactions API:** When you need server-side state, background execution, built-in tools (Google Search, Code Exec, URL Context, Computer Use), native multimodal gen, or direct MCP — bypasses Genkit, uses `@google/genai` SDK directly

### Dotprompt file vs inline prompt?
- **Dotprompt file:** When prompt needs iteration, A/B testing, non-dev editing
- **Inline:** Simple prompts that are tightly coupled to code logic

### Firebase Functions vs Cloud Run?
- **Firebase Functions:** Quick deploy, auto-scaling, integrated auth, < 60s tasks
- **Cloud Run:** Long-running tasks, existing FastAPI, custom containers, > 60s

---

## Interactions API (Beta — `@google/genai` SDK)

The Interactions API is Google's new unified interface for Gemini models and agents. It's an alternative to `generateContent` — simpler state management, built-in tool orchestration, and background execution. **Not part of Genkit** — uses the `@google/genai` SDK directly (Python `google-genai >= 1.55.0`, JS `@google/genai >= 1.33.0`).

### When to use Interactions API vs Genkit
| Need | Use |
|---|---|
| Type-safe flows, deployment as Firebase callable, tracing, eval | **Genkit** |
| Server-side conversation state, built-in tools (Search, Code Exec), background agents | **Interactions API** |
| Deep Research agent | **Interactions API** (only way) |
| Native image/speech generation from Gemini | **Interactions API** |
| Production stability (no breaking changes) | **Genkit** or `generateContent` |

### Basic Usage
```typescript
import { GoogleGenAI } from '@google/genai';
const client = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

const interaction = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: 'Tell me a joke',
});
console.log(interaction.outputs.at(-1).text);
```

### Stateful Conversation (server-side state)
```typescript
const turn1 = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: 'Hi, my name is Phil.',
});

const turn2 = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: 'What is my name?',
  previousInteractionId: turn1.id, // server remembers history
});
```

**Important**: Only conversation history is inherited. `model`, `tools`, `systemInstruction`, and `generationConfig` must be re-sent every turn. Do NOT send `tools` when input is a `function_result`.

### Stateless Conversation (client-managed history)
```typescript
const history = [{ role: 'user', content: 'What are the three largest cities in Spain?' }];
const i1 = await client.interactions.create({ model: 'gemini-3-flash-preview', input: history });
history.push({ role: 'model', content: i1.outputs });
history.push({ role: 'user', content: 'What about the second one?' });
const i2 = await client.interactions.create({ model: 'gemini-3-flash-preview', input: history });
```

### Function Calling
```typescript
const weatherTool = {
  type: 'function',
  name: 'get_weather',
  description: 'Gets weather for a location.',
  parameters: {
    type: 'object',
    properties: { location: { type: 'string' } },
    required: ['location'],
  },
};

const i = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: 'Weather in Paris?',
  tools: [weatherTool],
});

for (const output of i.outputs) {
  if (output.type === 'function_call') {
    const result = await getWeather(output.arguments.location);
    const response = await client.interactions.create({
      model: 'gemini-3-flash-preview',
      previousInteractionId: i.id,
      input: [{ type: 'function_result', name: output.name, callId: output.id, result }],
    });
  }
}
```

### Built-in Tools
```typescript
// Google Search grounding
tools: [{ type: 'google_search' }]

// Code execution
tools: [{ type: 'code_execution' }]

// URL context (fetch + analyze URLs)
tools: [{ type: 'url_context' }]

// Computer use (browser automation)
tools: [{ type: 'computer_use', environment: 'browser' }]

// File search
tools: [{ type: 'file_search', fileSearchStoreNames: ['fileSearchStores/my-store'] }]

// Remote MCP server (Streamable HTTP only, NOT SSE; NOT supported on Gemini 3 yet)
tools: [{ type: 'mcp_server', name: 'my_service', url: 'https://...' }]
```

### Structured Output
```typescript
const interaction = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: 'Classify this text...',
  responseFormat: myJsonSchema, // JSON Schema object
});
const parsed = JSON.parse(interaction.outputs.at(-1).text);
```

### Multimodal Input
```typescript
// Image, audio, video, document — via URL or base64
const interaction = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: [
    { type: 'text', text: 'Describe this image.' },
    { type: 'image', uri: 'https://...', mimeType: 'image/png' },
  ],
});
```

### Image & Speech Generation
```typescript
// Image generation
const imgInteraction = await client.interactions.create({
  model: 'gemini-3-pro-image-preview',
  input: 'Generate an image of a futuristic city.',
  responseModalities: ['IMAGE'],
  generationConfig: { imageConfig: { aspectRatio: '16:9', imageSize: '2k' } },
});

// TTS
const ttsInteraction = await client.interactions.create({
  model: 'gemini-2.5-flash-preview-tts',
  input: 'Say: Hello world!',
  responseModalities: ['AUDIO'],
  generationConfig: { speechConfig: { language: 'en-us', voice: 'kore' } },
});

// Multi-speaker TTS
generationConfig: {
  speechConfig: [
    { voice: 'Zephyr', speaker: 'Alice', language: 'en-US' },
    { voice: 'Puck', speaker: 'Bob', language: 'en-US' },
  ]
}
```

### Deep Research Agent (background execution)
```typescript
const research = await client.interactions.create({
  input: 'Research the history of TPUs.',
  agent: 'deep-research-pro-preview-12-2025',
  background: true, // required for agents
});

// Poll for results
let result;
do {
  result = await client.interactions.get(research.id);
  if (result.status === 'completed') break;
  await new Promise(r => setTimeout(r, 10000));
} while (result.status !== 'failed' && result.status !== 'cancelled');
console.log(result.outputs.at(-1).text);
```

### Streaming
```typescript
const stream = await client.interactions.create({
  model: 'gemini-3-flash-preview',
  input: 'Explain quantum entanglement.',
  stream: true,
});

for await (const chunk of stream) {
  if (chunk.eventType === 'content.delta' && chunk.delta.type === 'text') {
    process.stdout.write(chunk.delta.text);
  }
}
```

**Streaming events**: `interaction.start` → `content.start` → `content.delta` (accumulate these) → `content.stop` → `interaction.complete` (no outputs here — reconstruct from deltas).

### Thinking Controls
```typescript
generationConfig: {
  thinkingLevel: 'high',     // minimal | low | medium | high (default)
  thinkingSummaries: 'auto', // auto (default) | none
}
```
- `minimal` / `medium`: Flash models only
- `low` / `high`: All thinking models
- Thought blocks have `signature` (always) and optional `summary`
- In stateless mode, include thought blocks with signatures in subsequent requests

### Configuration
```typescript
generationConfig: {
  temperature: 0.7,
  maxOutputTokens: 500,
  thinkingLevel: 'low',
}
```

### Storage & Retention
- Interactions stored by default (`store: true`) for state management + background execution
- Paid tier: 55 days retention. Free tier: 1 day.
- `store: false` opts out but disables `previousInteractionId` and `background: true`
- Delete anytime via `client.interactions.delete(id)`

### Limitations (Beta)
- Breaking changes expected — for production use `generateContent` or Genkit
- No Grounding with Google Maps yet
- Can't combine MCP + Function Call + Built-in tools in same request (coming soon)
- Remote MCP not supported on Gemini 3 models yet
- Output ordering for `google_search`/`url_context` may be incorrect (known issue)

---

## Google GenAI SDK — generateContent API

The standard `generateContent` API remains the stable, production-recommended path. Use via `@google/genai` SDK directly or through Genkit's `@genkit-ai/google-genai` plugin.

### Basic Text Generation
```typescript
import { GoogleGenAI } from '@google/genai';
const client = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

const response = await client.models.generateContent({
  model: 'gemini-3-flash-preview',
  contents: 'How does AI work?',
});
console.log(response.text);
```

### System Instructions & Config
```typescript
const response = await client.models.generateContent({
  model: 'gemini-3-flash-preview',
  contents: 'Hello there',
  config: {
    systemInstruction: 'You are a cat. Your name is Neko.',
    temperature: 1.0, // Keep at 1.0 for Gemini 3 models (lower may cause looping)
  },
});
```

### Streaming
```typescript
const stream = await client.models.generateContentStream({
  model: 'gemini-3-flash-preview',
  contents: 'Explain how AI works',
});
for await (const chunk of stream) {
  process.stdout.write(chunk.text);
}
```

### Multi-turn Chat (SDK helper)
```typescript
const chat = client.chats.create({ model: 'gemini-3-flash-preview' });
const r1 = await chat.sendMessage('I have 2 dogs in my house.');
const r2 = await chat.sendMessage('How many paws are in my house?');
```

---

## Gemini Thinking (Reasoning)

Gemini 3 and 2.5 models use internal "thinking" for better reasoning on complex tasks. Thinking is **on by default** (dynamic).

### Thinking Levels (Gemini 3 — use `thinkingLevel`)
| Level | Gemini 3.1 Pro | Gemini 3 Pro | Gemini 3 Flash | Description |
|---|---|---|---|---|
| `minimal` | N/A | N/A | Yes | Near-zero thinking. Minimizes latency. May still think on complex code. |
| `low` | Yes | Yes | Yes | Light reasoning. Good for chat, simple tasks. |
| `medium` | Yes | N/A | Yes | Balanced. |
| `high` | Yes (default) | Yes (default) | Yes (default) | Max reasoning depth. Slower first token, best quality. |

```typescript
// Genkit
await ai.generate({
  prompt: 'Solve this...',
  config: { thinkingConfig: { thinkingLevel: 'low' } },
});

// Direct SDK
await client.models.generateContent({
  model: 'gemini-3-flash-preview',
  contents: 'Solve this...',
  config: { thinkingConfig: { thinkingLevel: 'low' } },
});
```

### Thinking Budgets (Gemini 2.5 — use `thinkingBudget`)
| Model | Default | Range | Disable | Dynamic |
|---|---|---|---|---|
| 2.5 Pro | Dynamic | 128–32768 | Cannot disable | `thinkingBudget: -1` |
| 2.5 Flash | Dynamic | 0–24576 | `thinkingBudget: 0` | `thinkingBudget: -1` |
| 2.5 Flash Lite | Off | 512–24576 | `thinkingBudget: 0` | `thinkingBudget: -1` |

**Do NOT use `thinkingBudget` with Gemini 3 models** — may cause unexpected behavior. Use `thinkingLevel` instead.

### Thought Summaries
```typescript
// Enable summaries
config: { thinkingConfig: { includeThoughts: true } }

// In response, iterate parts:
for (const part of response.candidates[0].content.parts) {
  if (part.thought) console.log('Thinking:', part.text);
  else console.log('Answer:', part.text);
}
```

### Thought Signatures (Critical for Multi-turn)
- Gemini 3: returns signatures on all part types. Always pass all signatures back.
- Gemini 2.5: returns signatures only with function calling.
- **Required**: include thought blocks with signatures in subsequent requests (stateless mode).
- Don't concatenate parts with signatures. Don't merge signed + unsigned parts.
- Google GenAI SDK handles this automatically in chat mode.

### Pricing Note
Thinking tokens are billed. Total cost = output tokens + thinking tokens. Check `response.usageMetadata.thoughtsTokenCount`.

---

## Embeddings (`gemini-embedding-001`)

### Basic Embedding
```typescript
const result = await client.models.embedContent({
  model: 'gemini-embedding-001',
  contents: 'What is the meaning of life?',
});
// result.embeddings[0].values → number[]
```

### Batch Embeddings
```typescript
const result = await client.models.embedContent({
  model: 'gemini-embedding-001',
  contents: ['Text one', 'Text two', 'Text three'],
});
```

### Task Types (optimize for your use case)
| Task Type | Use For |
|---|---|
| `SEMANTIC_SIMILARITY` | Duplicate detection, recommendations |
| `CLASSIFICATION` | Sentiment analysis, spam detection |
| `CLUSTERING` | Document organization, anomaly detection |
| `RETRIEVAL_DOCUMENT` | Index docs/articles/web pages for search |
| `RETRIEVAL_QUERY` | Search queries (pair with RETRIEVAL_DOCUMENT) |
| `CODE_RETRIEVAL_QUERY` | Natural language → code search |
| `QUESTION_ANSWERING` | Q&A systems (pair with RETRIEVAL_DOCUMENT) |
| `FACT_VERIFICATION` | Fact-checking (pair with RETRIEVAL_DOCUMENT) |

```typescript
const result = await client.models.embedContent({
  model: 'gemini-embedding-001',
  contents: texts,
  config: { taskType: 'SEMANTIC_SIMILARITY' },
});
```

### Dimension Control (MRL)
Default: 3072 dimensions. Recommended sizes: **768**, **1536**, **3072**.
```typescript
config: { outputDimensionality: 768 }
```
- 3072-dim embeddings are pre-normalized
- Smaller dimensions need manual L2 normalization for accurate cosine similarity
- MTEB scores: 3072→68.16, 1536→68.17, 768→67.99 (minimal quality loss)

### Model Specs
- Input token limit: 2,048
- Output dimensions: 128–3072 (flexible)

---

## Long Context

Gemini models support **1M+ token** context windows. This changes the tradeoff landscape for RAG vs. direct context.

### What fits in 1M tokens?
- ~50,000 lines of code
- ~8 average English novels
- ~200 podcast episode transcripts

### When to use long context vs RAG
| Scenario | Approach |
|---|---|
| < ~500K tokens, high accuracy needed | **Long context** (direct) |
| Reusable large context, cost-sensitive | **Context caching** + long context |
| Dynamic corpus that changes frequently | **RAG** (vector store) |
| Need 100+ separate retrievals from same corpus | **RAG** (cost scales per query with long context) |
| Single-needle retrieval from large doc | **Long context** (~99% accuracy) |
| Multi-needle retrieval (many facts) | **RAG** or multiple long-context queries |

### Context Caching
For repeated queries over the same large context, use **context caching** — ~4x cheaper than re-sending tokens each time. Cache files on upload, pay per-hour storage.

### Best Practices
- Put the query/question **at the end** of the prompt (after all context) for best performance
- Don't pass unnecessary tokens — more tokens = higher latency
- For multiple pieces of information from same corpus, consider separate requests (with caching)
- Many-shot in-context learning scales well (hundreds/thousands of examples)

---

## Context Caching

Reduces cost when repeatedly querying the same large context. Two mechanisms:

### Implicit Caching (automatic)
- Enabled by default on most models. No code changes needed.
- Google automatically passes on savings when requests hit cache.
- Min token thresholds: Gemini 3 Flash = 1,024; Gemini 3 Pro / 2.5 Pro = 4,096
- Tips: put large/common content at beginning of prompt; send similar-prefix requests close together

### Explicit Caching (manual)
```typescript
// Create a cache with TTL
const cache = await client.caches.create({
  model: 'models/gemini-3-flash-preview',
  config: {
    displayName: 'my-knowledge-base',
    systemInstruction: 'You are an expert analyst...',
    contents: [uploadedFile],
    ttl: '300s', // 5 minutes
  },
});

// Use cache in requests (~4x cheaper than re-sending tokens)
const response = await client.models.generateContent({
  model: 'models/gemini-3-flash-preview',
  contents: 'Summarize the key findings',
  config: { cachedContent: cache.name },
});
```

- **TTL**: defaults to 1 hour if not set. Update with `client.caches.update()`
- **Cost**: reduced input rate for cached tokens + per-hour storage cost
- **Manage**: `client.caches.list()`, `client.caches.get(name)`, `client.caches.delete(name)`
- **Best for**: chatbots with large system instructions, repeated video/doc analysis, code repo Q&A

---

## Token Counting & Limits

### Token Basics
- 1 token ≈ 4 characters ≈ 0.6–0.8 English words
- Image (≤384px both dims): 258 tokens. Larger images: tiled at 768×768, 258 tokens per tile.
- Video: 263 tokens/second
- Audio: 32 tokens/second

### Count Tokens Before Sending
```typescript
const count = await client.models.countTokens({
  model: 'gemini-3-flash-preview',
  contents: prompt,
});
console.log(count.totalTokens);
```

### Usage Metadata in Response
```typescript
const response = await client.models.generateContent({ ... });
// response.usageMetadata:
//   promptTokenCount — input tokens
//   candidatesTokenCount — output tokens
//   thoughtsTokenCount — thinking tokens (billed!)
//   cachedContentTokenCount — cached tokens (reduced rate)
//   totalTokenCount — total
```

### Get Model Limits
```typescript
const info = await client.models.get({ model: 'gemini-3-flash-preview' });
console.log(info.inputTokenLimit, info.outputTokenLimit);
```

---

## Prompt Design Quick Reference

### Core Principles (especially for Gemini 3)
- **Be precise and direct** — state the goal clearly, avoid filler
- **Use consistent structure** — XML tags (`<context>`, `<task>`) or Markdown headings
- **Put query at the end** — after all context, for long-context prompts
- **Keep temperature at 1.0** for Gemini 3 (lower may cause looping/degraded performance)
- **Few-shot > zero-shot** — always include examples when possible
- **Show positive patterns**, not anti-patterns

### Structured Prompt Template (Gemini 3)
```xml
<role>You are a [domain] specialist.</role>
<constraints>
1. Be objective.
2. Cite sources.
</constraints>
<context>[Large context / documents here]</context>
<task>[Specific question or instruction]</task>
```

### Key Parameters
| Parameter | What it does | Gemini 3 Note |
|---|---|---|
| `temperature` | Randomness (0 = deterministic, higher = creative) | Keep at **1.0** default |
| `maxOutputTokens` | Cap on response length | Set based on use case |
| `topK` | Sample from top K tokens | Usually leave default |
| `topP` | Nucleus sampling threshold (default 0.95) | Usually leave default |
| `stopSequences` | Stop generation at specific strings | Use for structured output |

### Gemini 3 Flash Tips
- Add to system instructions: `"For time-sensitive queries, follow the current date. Remember it is 2025 this year."`
- Add: `"Your knowledge cutoff date is January 2025."`
- For grounding: `"You are strictly grounded to the provided context. Do not use external knowledge."`

### Task Complexity Guide
| Complexity | Thinking Level | Examples |
|---|---|---|
| Easy (fact retrieval, classification) | `minimal` or `low` | "Where was X founded?", "Is this spam?" |
| Medium (comparison, analogy) | Default (`high`) | "Compare A vs B", "Explain X like Y" |
| Hard (math, coding, multi-step) | `high` | AIME problems, full app generation |

---

## Working Rules

1. **Always read the relevant doc file** before implementing. Don't guess APIs.
2. **Use Zod schemas** for all inputs and outputs. Wrap in `z.object()`.
3. **Error handling:** Check `output` for null after structured generation.
4. **Security:** Use `context.auth` for user scoping. Never trust LLM with raw user IDs in prompts — pass via context.
5. **Cost control:** Use `maxTurns` on tool-calling flows. Default is 5.
6. **Streaming:** Use `generateStream()` / `streamSchema` for user-facing content.
7. **Testing:** Use Genkit Dev UI (`genkit start`) for rapid iteration. Use `eval:flow` for quality.
8. **Secrets:** Use `defineSecret()` for API keys in Cloud Functions. Use env vars on Cloud Run.
9. **Middleware:** Add `retry()` for production resilience. Add `fallback()` for critical paths.
10. **Angular integration:** AI responses flow through Angular services/signals. Never call Genkit directly from components.

## Angular Integration Pattern

```typescript
// ai.service.ts — Angular service wrapping Genkit cloud function calls
@Injectable({ providedIn: 'root' })
export class AiService {
  private functions = inject(Functions);

  generateContent(input: { query: string }) {
    const callable = httpsCallable<typeof input, { answer: string }>(
      this.functions, 'myAiFunction'
    );
    return from(callable(input)).pipe(map(r => r.data));
  }

  // For streaming, use the Genkit client library or SSE endpoint
}
```

## Self-Check Before Shipping

- [ ] Schema validation on inputs AND outputs?
- [ ] Auth context propagated to tools?
- [ ] `maxTurns` set on agentic flows?
- [ ] Error handling for null `output`?
- [ ] Secrets managed properly (not hardcoded)?
- [ ] Dev UI tested with sample inputs?
- [ ] `ng build` passes (Angular side)?
- [ ] Deployment config includes required secrets?
