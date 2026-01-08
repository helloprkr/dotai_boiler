# DotAI 2.0 Product Requirements Document

## Executive Summary

DotAI 2.0 represents a fundamental paradigm shift from a **manual, file-based AI memory system** to an **invisible, automatic context synchronization engine**. This document outlines the comprehensive implementation plan for transforming DotAI Boiler from its current architecture-first approach to an insight-first system.

### The Core Insight

> **"AI-assisted development is bottlenecked by context synchronization, not AI capability. The bandwidth and accuracy of intent→understanding transfer determines outcome quality."**

The current DotAI system works in principle but fails in practice because it requires humans to do what humans are bad at: consistent, low-reward administrative maintenance. The 2.0 system inverts this by making context management **invisible, automatic, and zero-friction**.

---

## Part 1: Analysis Summary

### Current State Assessment

The existing DotAI Boiler (v1.x) implements an "architecture-first" approach:

| Component | Current Implementation | Friction Level |
|-----------|----------------------|----------------|
| Codex | Manual markdown files in `.ai/codex/` | High - requires explicit authoring |
| Sessions | Manual start/end protocols | High - relies on ritual discipline |
| Blueprints | Static markdown guides | Medium - useful but rarely referenced |
| Rules | Static configuration files | Low - once set, persists |
| Snippets | Code templates | Medium - requires discovery |
| Status | Manual session tracking | High - often forgotten |

### Identified Failure Modes

1. **Context Loading Problem**: Manual `@import` references rely on human memory
2. **Knowledge Capture Friction**: Manual creation breaks development flow
3. **Hierarchy Problem**: Flat file structure limits discoverability at scale
4. **Validation Problem**: No mechanism to verify AI rule adherence
5. **Discoverability Problem**: New users don't know what's available
6. **Cross-Project Learning**: Each project is an isolated knowledge island
7. **Metrics Void**: No way to measure framework effectiveness

### The Insight Hierarchy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ FUNDAMENTAL INSIGHT                                                          │
│                                                                              │
│ "AI-assisted development is bottlenecked by context synchronization,        │
│  not AI capability. The bandwidth and accuracy of intent→understanding      │
│  transfer determines outcome quality."                                       │
└────────────────────────────────┬────────────────────────────────────────────┘
                                 │
┌────────────────────────────────▼────────────────────────────────────────────┐
│ DOMAIN INSIGHT                                                               │
│                                                                              │
│ "Context retrieval quality matters more than context storage volume.         │
│  The right 10 lines surfaced automatically beat 1000 lines loaded manually." │
└────────────────────────────────┬────────────────────────────────────────────┘
                                 │
┌────────────────────────────────▼────────────────────────────────────────────┐
│ MECHANISM INSIGHT                                                            │
│                                                                              │
│ "Human-maintained knowledge systems fail because capture friction exceeds    │
│  perceived value. Only automatic capture survives real workflows."           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Part 2: Component Migration Map

### Old → New Component Routing

| v1 Component | v2 Replacement | Migration Strategy |
|--------------|----------------|-------------------|
| `.ai/codex/*.md` | `.ai/core/knowledge.db` | Auto-extract from git history + manual entries preserved |
| `.ai/session/start-session.md` | **Deprecated** → Auto-detection | Session detection via project/directory context |
| `.ai/session/end-session.md` | **Deprecated** → Auto-extraction | Learnings extracted from conversation/diffs |
| `.ai/blueprints/*` | `.ai/core/blueprints/` | Preserved, indexed for semantic search |
| `.ai/rules/*` | `.ai/core/rules/` | Preserved, with validation engine |
| `.ai/snippets/*` | `.ai/core/snippets/` | Preserved, indexed for semantic search |
| `.ai/status/*` | `.ai/captured/sessions/` | Auto-generated from activity observation |
| `.ai/plugins/*` | `.ai/integrations/` | Refactored as integration adapters |
| `.ai/scripts/*` | `.ai/daemon/` | Consolidated into daemon service |

### Directory Structure Migration

```
v1 (Current)                          v2 (Target)
─────────────────────────────────     ─────────────────────────────────
.ai/                                  .ai/
├── actions/                          ├── core/                    # Core system
├── blueprints/                       │   ├── config.yaml          # System config
│   ├── supabase-drizzle/            │   ├── knowledge.db         # Vector/SQLite store
│   ├── flux-replicate/              │   ├── blueprints/          # Indexed blueprints
│   └── nextjs-complete/             │   ├── rules/               # Validated rules
├── codex/                            │   └── snippets/            # Indexed snippets
│   ├── codex.md                      │
│   ├── learn.md                      ├── captured/                # Auto-captured
│   └── errors/                       │   ├── commits/             # Git commit analysis
├── components/                       │   ├── errors/              # Terminal errors
├── lib/                              │   ├── patterns/            # Code patterns
├── plugins/                          │   ├── decisions/           # Inferred decisions
├── rules/                            │   └── sessions/            # Auto-session logs
├── scripts/                          │
├── session/                          ├── daemon/                  # Background service
│   ├── start-session.md             │   ├── observer.ts          # File watcher
│   ├── end-session.md               │   ├── analyzer.ts          # Content analyzer
│   └── template.md                  │   ├── indexer.ts           # Semantic indexer
├── snippets/                         │   └── injector.ts          # Context injector
└── status/                           │
                                      ├── integrations/            # External tools
                                      │   ├── git/                 # Git hooks
                                      │   ├── editor/              # Editor plugins
                                      │   └── ai/                  # AI providers
                                      │
                                      └── legacy/                  # v1 compatibility
                                          └── [migrated v1 files]
```

---

## Part 3: Technical Architecture

### System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DotAI 2.0 Architecture                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │   Passive    │    │   Semantic   │    │  Invisible   │                  │
│  │  Observation │───▶│    Index     │───▶│   Session    │                  │
│  │    Layer     │    │    Layer     │    │    Layer     │                  │
│  └──────────────┘    └──────────────┘    └──────────────┘                  │
│         │                   │                   │                           │
│         ▼                   ▼                   ▼                           │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │  Predictive  │    │ Evolutionary │    │   Context    │                  │
│  │   Context    │◀───│   Learning   │◀───│  Injection   │                  │
│  │    Layer     │    │    Layer     │    │    Layer     │                  │
│  └──────────────┘    └──────────────┘    └──────────────┘                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Layer 1: Passive Observation Layer

**Purpose**: Capture knowledge automatically with zero user friction.

**Components**:

| Observer | Source | Extracts |
|----------|--------|----------|
| Git Observer | Commits, diffs, messages | Changes, decisions, patterns |
| File Observer | File modifications | Code patterns, style preferences |
| Terminal Observer | Shell history, stderr | Commands, errors, solutions |
| Conversation Observer | AI chat logs (opt-in) | Decisions, learnings, context |

**Implementation**:

```typescript
// .ai/daemon/observer.ts
interface ObservationEvent {
  type: 'git' | 'file' | 'terminal' | 'conversation';
  timestamp: Date;
  source: string;
  content: string;
  metadata: Record<string, unknown>;
}

interface Observer {
  name: string;
  init(): Promise<void>;
  observe(): AsyncIterator<ObservationEvent>;
  stop(): Promise<void>;
}
```

### Layer 2: Semantic Index Layer

**Purpose**: Enable retrieval-first access to knowledge.

**Components**:

| Component | Technology | Purpose |
|-----------|------------|---------|
| Vector Store | SQLite + sqlite-vss | Semantic similarity search |
| Embedding Engine | Local (MiniLM) or API | Convert text to embeddings |
| Index Manager | Custom | Incremental index updates |

**Schema**:

```sql
-- .ai/core/knowledge.db

CREATE TABLE knowledge (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,           -- 'error', 'pattern', 'decision', 'learning'
  source TEXT NOT NULL,         -- 'git', 'terminal', 'manual', 'inferred'
  content TEXT NOT NULL,
  embedding BLOB,               -- Vector embedding
  created_at DATETIME,
  accessed_at DATETIME,
  access_count INTEGER DEFAULT 0,
  relevance_score REAL DEFAULT 0.5
);

CREATE TABLE context_cache (
  project_path TEXT PRIMARY KEY,
  current_context TEXT,
  active_files TEXT,            -- JSON array
  recent_queries TEXT,          -- JSON array
  last_updated DATETIME
);

CREATE TABLE feedback (
  id TEXT PRIMARY KEY,
  knowledge_id TEXT REFERENCES knowledge(id),
  action TEXT,                  -- 'accepted', 'rejected', 'modified'
  timestamp DATETIME
);
```

### Layer 3: Invisible Session Layer

**Purpose**: Automatic session detection and context management.

**Detection Signals**:

| Signal | Detection Method | Action |
|--------|-----------------|--------|
| Project Entry | `pwd` change, editor focus | Load project context |
| File Focus | Active file change | Surface relevant knowledge |
| Error Occurrence | stderr pattern match | Retrieve error solutions |
| Conversation Start | AI prompt detected | Inject relevant context |

**Implementation**:

```typescript
// .ai/daemon/session.ts
interface SessionState {
  projectPath: string;
  activeFiles: string[];
  currentTask: string | null;      // Inferred from activity
  relevantContext: KnowledgeItem[];
  startedAt: Date;
  lastActivity: Date;
}

class InvisibleSessionManager {
  async detectContext(): Promise<SessionState>;
  async surfaceRelevantKnowledge(query: string): Promise<KnowledgeItem[]>;
  async injectContext(prompt: string): Promise<string>;
  async captureOutcome(action: 'accepted' | 'rejected'): Promise<void>;
}
```

### Layer 4: Predictive Context Layer

**Purpose**: Anticipate user needs and preload relevant context.

**Prediction Model**:

```typescript
interface PredictionInput {
  currentFile: string;
  recentFiles: string[];
  lastCommit: string;
  terminalHistory: string[];
  timeOfDay: number;
}

interface PredictionOutput {
  likelyTask: string;
  relevantKnowledge: KnowledgeItem[];
  suggestedBlueprints: string[];
  anticipatedErrors: ErrorPattern[];
}
```

### Layer 5: Evolutionary Learning Layer

**Purpose**: Improve retrieval quality through usage observation.

**Feedback Signals**:

| Signal | Meaning | Action |
|--------|---------|--------|
| AI suggestion accepted | Context was relevant | Upweight in retrieval |
| AI suggestion rejected | Context was irrelevant | Downweight in retrieval |
| Follow-up questions | Context was insufficient | Flag knowledge gap |
| Task completed quickly | Context was effective | Reinforce pattern |

---

## Part 4: Implementation Phases

### Phase 0: Foundation Setup (Prerequisites)

**Objectives**:
- Establish development environment
- Set up project structure for v2
- Create migration utilities

**Deliverables**:
- [ ] v2 directory structure created
- [ ] TypeScript/Node.js project initialized
- [ ] Build pipeline configured
- [ ] Migration scripts for v1 → v2 content

**Technical Requirements**:
```json
{
  "runtime": "Node.js >= 18",
  "language": "TypeScript 5.x",
  "database": "SQLite 3.x with sqlite-vss extension",
  "embeddings": "transformers.js (MiniLM-L6-v2) or OpenAI API"
}
```

### Phase 1: Passive Observation Layer

**Objectives**:
- Implement automatic capture infrastructure
- Zero user action required after installation

**Deliverables**:
- [ ] Git commit observer (post-commit hook)
- [ ] File change observer (chokidar-based)
- [ ] Terminal error observer (shell integration)
- [ ] Knowledge extraction pipeline

**Implementation Order**:
1. Git commit analyzer (highest signal, lowest friction)
2. File pattern extractor
3. Terminal error capture
4. Unified observation event bus

**Success Criteria**:
- Captures 100% of git commits automatically
- Extracts structured knowledge from commit messages
- Stores observations in SQLite database
- Zero user configuration required

### Phase 2: Semantic Index Layer

**Objectives**:
- Enable semantic search across all knowledge
- Replace file-based navigation with query-based access

**Deliverables**:
- [ ] Vector embedding pipeline
- [ ] SQLite-vss integration
- [ ] Semantic search API
- [ ] Index update daemon

**Implementation Order**:
1. SQLite database schema and migrations
2. Embedding generation (local-first, API fallback)
3. Vector similarity search
4. Incremental index updates

**Success Criteria**:
- Query returns relevant results in <100ms
- Semantic similarity beats keyword search
- Index updates happen in background
- Supports 10,000+ knowledge entries

### Phase 3: Context Injection Layer

**Objectives**:
- Automatically inject relevant context into AI prompts
- Integrate with editor/CLI workflows

**Deliverables**:
- [ ] Context injection API
- [ ] Claude Code integration
- [ ] Cursor/VSCode extension (optional)
- [ ] CLI command (`ai status`, `ai context`)

**Implementation Order**:
1. Context injection format specification
2. Integration with Claude Code system prompts
3. CLI tools for manual inspection
4. Editor extension (stretch goal)

**Success Criteria**:
- AI receives relevant context automatically
- No manual `@import` statements needed
- Context is concise (<2000 tokens typically)
- User can inspect injected context

### Phase 4: Invisible Session Layer

**Objectives**:
- Eliminate manual session start/end
- Automatic activity detection and context switching

**Deliverables**:
- [ ] Project detection daemon
- [ ] Activity inference engine
- [ ] Automatic session logging
- [ ] Resume context generation

**Implementation Order**:
1. Project root detection (git root, package.json)
2. Activity pattern recognition
3. Session state persistence
4. Context resume generation

**Success Criteria**:
- Sessions detected without user action
- Context persists across terminal sessions
- Activity summary generated automatically
- No "start-session" command needed

### Phase 5: Evolutionary Learning Layer

**Objectives**:
- Improve retrieval quality over time
- Learn from user feedback signals

**Deliverables**:
- [ ] Feedback capture system
- [ ] Relevance scoring updates
- [ ] Knowledge quality metrics
- [ ] Analytics dashboard (optional)

**Implementation Order**:
1. Implicit feedback capture (accept/reject detection)
2. Relevance score adjustment algorithm
3. Knowledge decay for stale entries
4. Quality metrics computation

**Success Criteria**:
- Retrieval quality improves with usage
- Stale knowledge deprioritized
- High-value patterns identified
- Measurable improvement in context relevance

### Phase 6: Migration & Polish

**Objectives**:
- Migrate existing v1 content
- Documentation and onboarding
- Performance optimization

**Deliverables**:
- [ ] v1 → v2 migration tool
- [ ] Updated documentation
- [ ] Performance benchmarks
- [ ] Installation script

---

## Part 5: Data Models & Schemas

### Core Configuration

```yaml
# .ai/core/config.yaml
version: "2.0"

observation:
  git:
    enabled: true
    extract_from_messages: true
    extract_from_diffs: true
  files:
    enabled: true
    patterns: ["**/*.ts", "**/*.tsx", "**/*.md"]
    ignore: ["node_modules", "dist", ".git"]
  terminal:
    enabled: true
    capture_errors: true
    shell_integration: "auto"  # bash, zsh, fish, or auto

indexing:
  embedding_provider: "local"  # "local" or "openai"
  openai_model: "text-embedding-3-small"  # if using openai
  local_model: "Xenova/all-MiniLM-L6-v2"
  chunk_size: 512
  overlap: 50

injection:
  max_tokens: 2000
  include_errors: true
  include_patterns: true
  include_decisions: true
  freshness_weight: 0.3
  relevance_weight: 0.7

learning:
  enabled: true
  decay_rate: 0.95  # per week
  boost_on_accept: 1.2
  penalty_on_reject: 0.8
```

### Knowledge Entry Schema

```typescript
interface KnowledgeEntry {
  id: string;                    // UUID
  type: KnowledgeType;
  source: KnowledgeSource;

  // Content
  title: string;
  content: string;
  code?: string;                 // Optional code snippet

  // Metadata
  filePath?: string;             // Related file
  commitHash?: string;           // Source commit
  tags: string[];

  // Retrieval scoring
  embedding: Float32Array;
  relevanceScore: number;        // 0-1, updated by learning
  accessCount: number;

  // Timestamps
  createdAt: Date;
  updatedAt: Date;
  lastAccessedAt: Date;
}

type KnowledgeType =
  | 'error'          // Error pattern and solution
  | 'pattern'        // Code pattern
  | 'decision'       // Architectural decision
  | 'learning'       // General learning
  | 'convention'     // Project convention
  | 'blueprint';     // Implementation guide

type KnowledgeSource =
  | 'git'            // Extracted from git
  | 'terminal'       // From terminal output
  | 'file'           // From file analysis
  | 'conversation'   // From AI chat
  | 'manual'         // User-authored (legacy)
  | 'inferred';      // System-inferred
```

### Session State Schema

```typescript
interface SessionState {
  id: string;
  projectPath: string;

  // Current context
  activeFiles: string[];
  currentDirectory: string;
  currentBranch: string;

  // Inferred state
  inferredTask: string | null;
  taskConfidence: number;

  // Knowledge context
  activeKnowledge: string[];     // IDs of relevant knowledge
  recentQueries: QueryLog[];

  // Activity
  startedAt: Date;
  lastActivityAt: Date;
  activityLog: ActivityEvent[];
}

interface ActivityEvent {
  type: 'file_open' | 'file_edit' | 'terminal_command' | 'ai_query';
  timestamp: Date;
  details: Record<string, unknown>;
}

interface QueryLog {
  query: string;
  results: string[];             // Knowledge IDs returned
  accepted: boolean | null;      // User feedback
  timestamp: Date;
}
```

---

## Part 6: API Specifications

### Daemon Service API

```typescript
// Core daemon interface
interface DotAIDaemon {
  // Lifecycle
  start(): Promise<void>;
  stop(): Promise<void>;
  status(): DaemonStatus;

  // Observation
  observe(event: ObservationEvent): Promise<void>;

  // Indexing
  index(entry: KnowledgeEntry): Promise<void>;
  search(query: string, limit?: number): Promise<SearchResult[]>;

  // Context
  getContext(options: ContextOptions): Promise<ContextPayload>;
  injectContext(prompt: string): Promise<string>;

  // Feedback
  recordFeedback(feedback: FeedbackEvent): Promise<void>;

  // Session
  getCurrentSession(): SessionState | null;
  getSessionHistory(days?: number): SessionSummary[];
}

interface ContextOptions {
  currentFile?: string;
  query?: string;
  maxTokens?: number;
  includeTypes?: KnowledgeType[];
}

interface ContextPayload {
  knowledge: KnowledgeEntry[];
  session: SessionState;
  tokenCount: number;
  formatted: string;             // Ready for injection
}

interface SearchResult {
  entry: KnowledgeEntry;
  score: number;                 // Similarity score
  snippet: string;               // Highlighted snippet
}
```

### CLI Commands

```bash
# Core commands (minimal interface)
ai status                        # Show current context and session
ai search <query>                # Semantic search knowledge base
ai show [id]                     # Display knowledge entry details
ai forget <id>                   # Remove from knowledge base
ai export                        # Export knowledge for sharing

# Debug/admin commands
ai daemon start                  # Start background service
ai daemon stop                   # Stop background service
ai daemon logs                   # View daemon logs
ai migrate                       # Migrate v1 content to v2
ai config                        # View/edit configuration
```

### Integration Points

```typescript
// Claude Code integration
interface ClaudeCodeIntegration {
  // Called before each AI interaction
  getSystemPromptAddition(): Promise<string>;

  // Called after AI response
  recordInteraction(interaction: AIInteraction): Promise<void>;
}

// Editor integration (VSCode/Cursor)
interface EditorIntegration {
  // Status bar
  getStatusText(): string;

  // Hover provider
  getKnowledgeForSymbol(symbol: string): KnowledgeEntry[];

  // Command palette
  searchKnowledge(): void;
  showCurrentContext(): void;
}
```

---

## Part 7: Success Metrics

### Adoption Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Installation Completion | >95% | Users who complete setup without errors |
| Active Usage | >80% after 1 week | Daemon running, observations captured |
| Manual Override Rate | <5% | Users using legacy @import syntax |
| Abandonment Rate | <10% | Users who disable after 1 week |

### Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Context Relevance | >85% | Accepted vs rejected suggestions |
| Retrieval Latency | <100ms | P95 search response time |
| Context Accuracy | >90% | Correct knowledge surfaced |
| Token Efficiency | <2000 avg | Tokens per context injection |

### Learning Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Relevance Improvement | +10%/week | Acceptance rate trend |
| Knowledge Growth | 5+ entries/day | Auto-captured entries |
| Query Diversity | >20 unique/day | Different queries served |
| Stale Knowledge Decay | Active | Low-value entries deprioritized |

---

## Part 8: Risk Assessment

### Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Embedding quality too low | Medium | High | Support multiple embedding providers |
| Performance degradation at scale | Low | Medium | SQLite optimizations, pagination |
| Shell integration compatibility | Medium | Medium | Multiple shell adapters, graceful fallback |
| Privacy concerns | Medium | High | Local-first, opt-in telemetry only |

### Adoption Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Users prefer manual control | Medium | High | Provide easy override mechanisms |
| Learning curve for v2 | Low | Medium | One-command migration, clear docs |
| Daemon resource usage | Medium | Medium | Efficient observation, idle mode |
| Integration conflicts | Low | Medium | Non-intrusive design, feature flags |

---

## Part 9: Appendices

### Appendix A: v1 Component Deprecation Schedule

| Component | Deprecation Phase | Removal Phase | Replacement |
|-----------|-------------------|---------------|-------------|
| `start-session.md` | Phase 4 | Phase 6 | Auto-detection |
| `end-session.md` | Phase 4 | Phase 6 | Auto-extraction |
| Manual codex authoring | Never | Never | Preserved as option |
| `@import` syntax | Phase 3 | Never | Auto-injection (manual preserved) |
| Session scripts | Phase 4 | Phase 6 | Daemon service |

### Appendix B: Compatibility Matrix

| Environment | Support Level | Notes |
|-------------|--------------|-------|
| macOS 12+ | Full | Primary development platform |
| Linux (Ubuntu 20+) | Full | Tested on common distros |
| Windows 11 (WSL2) | Full | Via WSL2 only |
| Windows 11 (native) | Partial | Limited shell integration |
| Node.js 18-20 | Full | Required runtime |
| Node.js 16-17 | Partial | May work, not tested |

### Appendix C: Performance Budgets

| Operation | Budget | Notes |
|-----------|--------|-------|
| Daemon startup | <500ms | Cold start to ready |
| File observation | <10ms | Per file change |
| Git observation | <100ms | Per commit |
| Search query | <100ms | P95 response |
| Context injection | <50ms | Format generation |
| Embedding generation | <200ms | Per chunk (local) |

---

## Conclusion

DotAI 2.0 represents a fundamental shift in how we approach AI context management. By inverting the architecture from manual-first to automatic-first, we address the core failure mode of the current system: human maintenance burden.

The insight-driven design ensures that:

1. **Zero friction adoption**: Install and forget
2. **Automatic knowledge capture**: No manual documentation required
3. **Intelligent retrieval**: The right context at the right time
4. **Continuous improvement**: System learns from usage

The perfect version of DotAI isn't a better-organized markdown folder. It's an invisible daemon that watches, learns, and injects—making every AI interaction contextually rich without asking anything of the developer.

---

*Document Version: 1.0.0*
*Created: 2026-01-08*
*Author: DotAI Development Team*
