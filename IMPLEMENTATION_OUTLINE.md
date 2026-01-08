# DotAI 2.0 Implementation Outline

## Component Routing: v1 → v2

This document provides detailed routing information for migrating from the current DotAI architecture to the insight-first v2 system.

---

## 1. Directory Structure Transformation

### Current Structure (v1)
```
.ai/
├── actions/                    → MIGRATE to .ai/integrations/actions/
├── blueprints/                 → PRESERVE at .ai/core/blueprints/
│   ├── supabase-drizzle/      → Index for semantic search
│   ├── flux-replicate/        → Index for semantic search
│   └── nextjs-complete/       → Index for semantic search
├── codex/                      → TRANSFORM to .ai/core/knowledge.db
│   ├── codex.md               → Import as 'learning' entries
│   ├── learn.md               → Template preserved for manual additions
│   └── errors/                → Import as 'error' entries
├── components/                 → MIGRATE to .ai/integrations/components/
├── lib/                        → MIGRATE to .ai/integrations/lib/
├── plugins/                    → MIGRATE to .ai/integrations/
│   ├── v0/                    → .ai/integrations/v0/
│   └── replicate/             → .ai/integrations/replicate/
├── rules/                      → PRESERVE at .ai/core/rules/
│   ├── mcp/                   → Add validation engine
│   ├── typescript/            → Add validation engine
│   └── nextjs/                → Add validation engine
├── scripts/                    → REPLACE with .ai/daemon/
│   ├── session.sh             → DEPRECATED (auto-session)
│   └── codex.sh               → DEPRECATED (auto-capture)
├── session/                    → DEPRECATED
│   ├── start-session.md       → Auto-detection replaces
│   ├── end-session.md         → Auto-extraction replaces
│   └── template.md            → Preserved for reference
├── snippets/                   → PRESERVE at .ai/core/snippets/
└── status/                     → TRANSFORM to .ai/captured/sessions/
```

### Target Structure (v2)
```
.ai/
├── core/                       # System core (new)
│   ├── config.yaml            # Central configuration
│   ├── knowledge.db           # SQLite + vector store
│   ├── blueprints/            # Indexed blueprints
│   │   ├── supabase-drizzle/
│   │   ├── flux-replicate/
│   │   └── nextjs-complete/
│   ├── rules/                 # Validated rules
│   │   ├── mcp/
│   │   ├── typescript/
│   │   └── nextjs/
│   └── snippets/              # Indexed snippets
│       ├── react/
│       ├── nextjs/
│       └── typescript/
│
├── captured/                   # Auto-captured knowledge (new)
│   ├── commits/               # From git observer
│   ├── errors/                # From terminal observer
│   ├── patterns/              # From file observer
│   ├── decisions/             # From conversation observer
│   └── sessions/              # Auto-generated session logs
│
├── daemon/                     # Background service (new)
│   ├── index.ts               # Daemon entry point
│   ├── observers/
│   │   ├── git.ts             # Git commit observer
│   │   ├── file.ts            # File change observer
│   │   ├── terminal.ts        # Terminal observer
│   │   └── conversation.ts    # AI conversation observer
│   ├── indexer/
│   │   ├── embeddings.ts      # Embedding generation
│   │   └── search.ts          # Semantic search
│   ├── session/
│   │   ├── detector.ts        # Session auto-detection
│   │   └── state.ts           # Session state manager
│   └── injector/
│       ├── context.ts         # Context builder
│       └── formatter.ts       # Prompt formatter
│
├── integrations/               # External integrations (migrated)
│   ├── actions/               # From .ai/actions/
│   ├── components/            # From .ai/components/
│   ├── lib/                   # From .ai/lib/
│   ├── v0/                    # From .ai/plugins/v0/
│   └── replicate/             # From .ai/plugins/replicate/
│
└── legacy/                     # v1 compatibility layer
    ├── codex/                 # Original codex files (reference)
    ├── session/               # Original templates (reference)
    └── migration-log.json     # Migration tracking
```

---

## 2. Component-by-Component Migration

### 2.1 Codex System

**Current State**: Manual markdown files requiring explicit authoring

**v1 Files**:
- `.ai/codex/codex.md` - Main codex document
- `.ai/codex/learn.md` - Learning template
- `.ai/codex/errors/*.md` - Error patterns

**v2 Transformation**:

```
┌─────────────────────────────────────────────────────────────────┐
│ v1: .ai/codex/                                                  │
│                                                                 │
│ codex.md ────────────┐                                         │
│ learn.md ────────────┼──▶ .ai/core/knowledge.db                │
│ errors/*.md ─────────┘    (SQLite + Vector embeddings)         │
│                                                                 │
│ Migration: Extract markdown sections → Knowledge entries        │
│ Each section becomes a queryable, embeddable entry             │
└─────────────────────────────────────────────────────────────────┘
```

**Migration Script Logic**:
```typescript
async function migrateCodex(codexPath: string): Promise<void> {
  // 1. Parse codex.md into sections
  const sections = parseMarkdownSections(await readFile(`${codexPath}/codex.md`));

  // 2. Convert each section to knowledge entry
  for (const section of sections) {
    await insertKnowledge({
      type: inferType(section),      // 'learning', 'pattern', 'convention'
      source: 'manual',              // Preserved as manual entry
      title: section.heading,
      content: section.content,
      tags: extractTags(section),
      createdAt: new Date(),
    });
  }

  // 3. Migrate error patterns
  const errorFiles = await glob(`${codexPath}/errors/*.md`);
  for (const file of errorFiles) {
    const content = await readFile(file);
    await insertKnowledge({
      type: 'error',
      source: 'manual',
      title: extractTitle(content),
      content: content,
      tags: ['error', ...extractTags(content)],
      createdAt: new Date(),
    });
  }

  // 4. Preserve originals in legacy/
  await copyDir(codexPath, '.ai/legacy/codex');
}
```

### 2.2 Session Management

**Current State**: Manual start/end protocols with templates

**v1 Files**:
- `.ai/session/start-session.md` - Session initialization template
- `.ai/session/end-session.md` - Session closing template
- `.ai/session/template.md` - Generic session template

**v2 Transformation**:

```
┌─────────────────────────────────────────────────────────────────┐
│ v1: Manual Session Commands                                     │
│                                                                 │
│ User runs: cat .ai/session/start-session.md                    │
│ User manually fills template                                    │
│ User runs: cat .ai/session/end-session.md                      │
│                                                                 │
│                          ▼                                      │
│                                                                 │
│ v2: Invisible Session Detection                                 │
│                                                                 │
│ Daemon observes:                                                │
│   - Project directory entry                                     │
│   - File activity patterns                                      │
│   - Terminal commands                                           │
│   - AI conversation initiation                                  │
│                                                                 │
│ Daemon auto-generates:                                          │
│   - Session state in memory                                     │
│   - Context for AI injection                                    │
│   - Session summary in .ai/captured/sessions/                  │
└─────────────────────────────────────────────────────────────────┘
```

**Replacement Logic**:
```typescript
// v1: User explicitly starts session
// cat .ai/session/start-session.md

// v2: Daemon auto-detects session
class SessionDetector {
  private currentSession: SessionState | null = null;

  async detectSessionStart(): Promise<void> {
    // Signals that trigger session detection:
    // 1. Terminal opens in project directory
    // 2. Editor focuses project files
    // 3. Git activity in project
    // 4. AI conversation begins

    const projectRoot = await this.findProjectRoot();
    if (!projectRoot) return;

    if (!this.currentSession || this.currentSession.projectPath !== projectRoot) {
      this.currentSession = {
        id: generateId(),
        projectPath: projectRoot,
        startedAt: new Date(),
        activeFiles: [],
        inferredTask: null,
        relevantContext: await this.loadRelevantContext(projectRoot),
      };

      // Auto-log session start (invisible to user)
      await this.logSessionEvent('session_start', this.currentSession);
    }
  }

  async captureSessionEnd(): Promise<void> {
    if (!this.currentSession) return;

    // Auto-extract learnings from session
    const learnings = await this.extractLearnings(this.currentSession);

    // Save session summary
    await this.saveSessionSummary({
      ...this.currentSession,
      endedAt: new Date(),
      learnings,
    });

    this.currentSession = null;
  }
}
```

### 2.3 Blueprints

**Current State**: Static markdown implementation guides

**v1 Files**:
- `.ai/blueprints/supabase-drizzle/`
- `.ai/blueprints/flux-replicate/`
- `.ai/blueprints/nextjs-complete/`

**v2 Transformation**: Preserved structure + semantic indexing

```
┌─────────────────────────────────────────────────────────────────┐
│ v1: Static File Access                                          │
│                                                                 │
│ User manually: @import .ai/blueprints/supabase-drizzle/README.md│
│                                                                 │
│                          ▼                                      │
│                                                                 │
│ v2: Semantic Discovery                                          │
│                                                                 │
│ 1. All blueprints indexed with embeddings                       │
│ 2. Query: "setting up database" → Returns supabase-drizzle     │
│ 3. Context injector includes relevant blueprint sections        │
│ 4. User can still access directly if needed                     │
└─────────────────────────────────────────────────────────────────┘
```

**Indexing Logic**:
```typescript
async function indexBlueprints(): Promise<void> {
  const blueprintDirs = await glob('.ai/core/blueprints/*');

  for (const dir of blueprintDirs) {
    const files = await glob(`${dir}/**/*.md`);

    for (const file of files) {
      const content = await readFile(file);
      const sections = parseMarkdownSections(content);

      for (const section of sections) {
        await insertKnowledge({
          type: 'blueprint',
          source: 'manual',
          title: `${path.basename(dir)}: ${section.heading}`,
          content: section.content,
          filePath: file,
          tags: ['blueprint', path.basename(dir)],
        });
      }
    }
  }
}
```

### 2.4 Rules System

**Current State**: Static rule files without validation

**v1 Files**:
- `.ai/rules/mcp/README.md`
- `.ai/rules/typescript/README.md`
- `.ai/rules/nextjs/README.md`

**v2 Transformation**: Preserved + validation engine

```
┌─────────────────────────────────────────────────────────────────┐
│ v2 Enhancement: Rule Validation                                 │
│                                                                 │
│ .ai/core/rules/typescript/rules.yaml                           │
│                                                                 │
│ rules:                                                          │
│   - id: no_any_type                                             │
│     description: "Avoid using 'any' type"                       │
│     pattern: ": any"                                            │
│     severity: warning                                           │
│     validate:                                                   │
│       command: "grep -r ': any' src/ | wc -l"                  │
│       expect: 0                                                 │
│     remedy: "Use proper types instead of 'any'"                 │
│                                                                 │
│ Daemon runs validation periodically and reports adherence       │
└─────────────────────────────────────────────────────────────────┘
```

### 2.5 Status Tracking

**Current State**: Manual status file creation

**v1 Files**:
- `.ai/status/*.md` - Manual session status files

**v2 Transformation**: Automatic session capture

```
┌─────────────────────────────────────────────────────────────────┐
│ v1: Manual Status                                               │
│                                                                 │
│ User creates: .ai/status/2024-03-19.md                          │
│ User writes summary manually                                    │
│                                                                 │
│                          ▼                                      │
│                                                                 │
│ v2: Auto-Captured Sessions                                      │
│                                                                 │
│ .ai/captured/sessions/2024-03-19-abc123.json                   │
│                                                                 │
│ {                                                               │
│   "id": "abc123",                                               │
│   "date": "2024-03-19",                                         │
│   "duration": "2h 34m",                                         │
│   "files_touched": ["src/auth.ts", "lib/db.ts"],               │
│   "commits": ["feat: add login", "fix: token refresh"],        │
│   "errors_encountered": [...],                                  │
│   "inferred_task": "Implementing authentication",               │
│   "learnings_captured": 3,                                      │
│   "summary": "Auto-generated summary..."                        │
│ }                                                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Observer Implementation Details

### 3.1 Git Observer

**Trigger**: Post-commit hook

**Captures**:
- Commit message → Decision/learning extraction
- Diff content → Pattern detection
- File paths → Context association

```typescript
// .ai/daemon/observers/git.ts

interface GitObserver {
  // Hook into git post-commit
  async onCommit(commit: GitCommit): Promise<void> {
    // 1. Analyze commit message for decisions
    const decisions = extractDecisions(commit.message);
    for (const decision of decisions) {
      await this.captureKnowledge({
        type: 'decision',
        source: 'git',
        content: decision,
        commitHash: commit.hash,
      });
    }

    // 2. Analyze diff for patterns
    const patterns = analyzePatterns(commit.diff);
    for (const pattern of patterns) {
      await this.captureKnowledge({
        type: 'pattern',
        source: 'git',
        content: pattern,
        filePath: pattern.file,
        commitHash: commit.hash,
      });
    }

    // 3. Detect error fixes
    if (isErrorFix(commit.message)) {
      await this.captureKnowledge({
        type: 'error',
        source: 'git',
        content: extractErrorSolution(commit),
        commitHash: commit.hash,
      });
    }
  }
}
```

### 3.2 Terminal Observer

**Trigger**: Shell integration (stderr capture)

**Captures**:
- Error messages → Error pattern + context
- Command sequences → Workflow patterns
- Solution attempts → Learning extraction

```typescript
// .ai/daemon/observers/terminal.ts

interface TerminalObserver {
  // Capture stderr output
  async onError(error: TerminalError): Promise<void> {
    // 1. Parse error structure
    const parsed = parseError(error.content);

    // 2. Check for existing solutions
    const existingSolutions = await this.searchKnowledge({
      query: parsed.message,
      type: 'error',
    });

    if (existingSolutions.length === 0) {
      // 3. Capture new error pattern
      await this.captureKnowledge({
        type: 'error',
        source: 'terminal',
        title: parsed.message,
        content: error.content,
        filePath: parsed.file,
        tags: parsed.errorType ? [parsed.errorType] : [],
      });
    }
  }

  // Detect solution (error followed by success)
  async onSuccess(context: TerminalContext): Promise<void> {
    const recentError = await this.getRecentError();
    if (recentError) {
      // Update error entry with solution
      await this.updateKnowledge(recentError.id, {
        solution: context.lastCommand,
        resolved: true,
      });
    }
  }
}
```

### 3.3 File Observer

**Trigger**: File system watcher (chokidar)

**Captures**:
- Code patterns → Style/convention learning
- Configuration changes → Decision tracking
- Structural changes → Architecture decisions

```typescript
// .ai/daemon/observers/file.ts

interface FileObserver {
  private watcher: chokidar.FSWatcher;

  async start(): Promise<void> {
    this.watcher = chokidar.watch('.', {
      ignored: ['node_modules', '.git', '.ai/captured'],
      persistent: true,
    });

    this.watcher.on('change', this.onFileChange.bind(this));
    this.watcher.on('add', this.onFileAdd.bind(this));
  }

  async onFileChange(path: string): Promise<void> {
    // Track activity for session context
    await this.recordActivity({
      type: 'file_edit',
      path,
      timestamp: new Date(),
    });

    // Analyze for significant patterns (debounced)
    await this.analyzePatterns(path);
  }

  async analyzePatterns(path: string): Promise<void> {
    const content = await readFile(path);

    // Extract new patterns not yet in knowledge base
    const patterns = extractCodePatterns(content);
    const existingPatterns = await this.searchKnowledge({
      type: 'pattern',
      filePath: path,
    });

    const newPatterns = patterns.filter(p =>
      !existingPatterns.some(e => isSimilarPattern(e, p))
    );

    for (const pattern of newPatterns) {
      await this.captureKnowledge({
        type: 'pattern',
        source: 'file',
        content: pattern.code,
        filePath: path,
        tags: pattern.tags,
      });
    }
  }
}
```

---

## 4. Context Injection Flow

### How Context Gets Injected

```
┌─────────────────────────────────────────────────────────────────┐
│                    Context Injection Flow                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. USER PROMPT                                                  │
│     │                                                            │
│     ▼                                                            │
│  2. CONTEXT BUILDER                                              │
│     ├── Get current session state                                │
│     ├── Get active file(s)                                       │
│     ├── Extract query intent                                     │
│     │                                                            │
│     ▼                                                            │
│  3. SEMANTIC SEARCH                                              │
│     ├── Embed query + context                                    │
│     ├── Search knowledge.db                                      │
│     ├── Rank by relevance + freshness                           │
│     │                                                            │
│     ▼                                                            │
│  4. CONTEXT FORMATTER                                            │
│     ├── Select top-N entries (token budget)                      │
│     ├── Format as system prompt addition                         │
│     ├── Include session context                                  │
│     │                                                            │
│     ▼                                                            │
│  5. INJECTED PROMPT                                              │
│     │                                                            │
│     ▼                                                            │
│  [AI RESPONSE]                                                   │
│     │                                                            │
│     ▼                                                            │
│  6. FEEDBACK CAPTURE                                             │
│     └── Record acceptance/rejection for learning                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Context Format Example

```markdown
<!-- DOTAI CONTEXT (auto-injected) -->

## Current Session
- Project: payment-service
- Active file: src/checkout/processor.ts
- Current task: Implementing Stripe integration (inferred)

## Relevant Knowledge

### Pattern: Stripe Error Handling
Source: git commit abc123 (2024-03-15)
```typescript
try {
  const paymentIntent = await stripe.paymentIntents.create({...});
} catch (error) {
  if (error.type === 'StripeCardError') {
    // Handle card errors specifically
  }
}
```

### Error: Webhook Signature Verification Failure
Source: captured 2024-03-10
Problem: Webhook events failing signature verification
Solution: Use raw request body, not parsed JSON

### Decision: Using Payment Intents API
Source: git commit def456 (2024-03-12)
Rationale: Payment Intents provides better 3DS support than Charges API

<!-- END DOTAI CONTEXT -->
```

---

## 5. Migration Execution Plan

### Step 1: Prepare v2 Structure

```bash
# Create new directory structure
mkdir -p .ai/core/{blueprints,rules,snippets}
mkdir -p .ai/captured/{commits,errors,patterns,decisions,sessions}
mkdir -p .ai/daemon/{observers,indexer,session,injector}
mkdir -p .ai/integrations
mkdir -p .ai/legacy

# Initialize database
touch .ai/core/knowledge.db
```

### Step 2: Migrate Static Content

```bash
# Move blueprints (preserve structure)
mv .ai/blueprints/* .ai/core/blueprints/

# Move rules (preserve structure)
mv .ai/rules/* .ai/core/rules/

# Move snippets (preserve structure)
mv .ai/snippets/* .ai/core/snippets/

# Move plugins to integrations
mv .ai/plugins/* .ai/integrations/
mv .ai/actions/* .ai/integrations/actions/
mv .ai/components/* .ai/integrations/components/
mv .ai/lib/* .ai/integrations/lib/
```

### Step 3: Run Codex Migration

```bash
# Run migration script
npx dotai-migrate codex

# This will:
# 1. Parse all .ai/codex/*.md files
# 2. Extract sections as knowledge entries
# 3. Generate embeddings
# 4. Insert into knowledge.db
# 5. Copy originals to .ai/legacy/codex/
```

### Step 4: Preserve Legacy Files

```bash
# Copy session templates for reference
cp -r .ai/session .ai/legacy/session

# Copy status files for historical reference
cp -r .ai/status .ai/legacy/status

# Copy scripts for reference
cp -r .ai/scripts .ai/legacy/scripts
```

### Step 5: Remove Deprecated Files

```bash
# Remove deprecated session management
rm -rf .ai/session
rm -rf .ai/status
rm -rf .ai/scripts/session.sh
rm -rf .ai/scripts/codex.sh
```

### Step 6: Install Daemon

```bash
# Install dependencies
npm install -g dotai-daemon

# Configure daemon
dotai init

# Start daemon
dotai daemon start
```

---

## 6. Verification Checklist

### Post-Migration Verification

- [ ] Knowledge database contains migrated codex entries
- [ ] All blueprints are indexed and searchable
- [ ] Rules are preserved and validation engine works
- [ ] Snippets are preserved and indexed
- [ ] Legacy files are backed up
- [ ] Daemon starts without errors
- [ ] Git observer captures commits
- [ ] File observer tracks changes
- [ ] Context injection works in AI prompts
- [ ] Search returns relevant results

### Rollback Procedure

If migration fails:

```bash
# Restore from legacy backup
cp -r .ai/legacy/codex .ai/codex
cp -r .ai/legacy/session .ai/session
cp -r .ai/legacy/status .ai/status

# Remove v2 structure
rm -rf .ai/core
rm -rf .ai/captured
rm -rf .ai/daemon

# Stop daemon
dotai daemon stop
npm uninstall -g dotai-daemon
```

---

## Summary

This implementation outline provides:

1. **Clear routing** from every v1 component to its v2 replacement
2. **Detailed transformation logic** for each component type
3. **Observer specifications** for automatic capture
4. **Context injection flow** for seamless AI integration
5. **Step-by-step migration procedure** with verification

The key principle throughout: **preserve what works, automate what fails, and make everything invisible**.
