# DotAI Boiler Framework

This directory contains the DotAI Boiler framework, a sophisticated system for AI-assisted development. The framework creates a structured memory system that allows AI assistants to maintain context across sessions, learn from past interactions, and provide consistent, high-quality assistance based on project-specific knowledge.

## Directory Structure

```
.ai/
├── actions/          # Automated actions for AI workflows
├── blueprints/       # Architecture implementation guides
│   ├── supabase-drizzle/    # Supabase backend architecture
│   ├── flux-replicate/      # Image generation workflow
│   └── nextjs-complete/     # Full-stack Next.js architecture
├── codex/            # Repository of AI learnings and errors
│   ├── codex.md      # Main codex document
│   ├── learn.md      # Template for new learnings
│   └── errors/       # Documented error patterns
├── components/       # Reusable UI/UX components
├── lib/              # Library documentation and examples
│   ├── react/        # React-specific libraries
│   └── node/         # Node.js utilities
├── plugins/          # Integration with external AI tools
│   ├── v0/           # v0.dev integration
│   └── replicate/    # Replicate models integration
├── rules/            # Rules for AI behavior
│   ├── mcp/          # Model Context Protocol rules
│   ├── typescript/   # TypeScript-specific rules
│   └── nextjs/       # Next.js framework rules
├── scripts/          # Automation scripts
│   ├── session.sh    # Session management utilities
│   └── codex.sh      # Codex management utilities
├── session/          # Session management tools
│   ├── start-session.md  # Start session template
│   ├── end-session.md    # End session template
│   └── template.md   # Session template
├── snippets/         # Code templates
│   ├── react/        # React component templates
│   ├── nextjs/       # Next.js templates
│   └── typescript/   # TypeScript utility templates
└── status/           # Session status tracking
```

## Core Components

### Codex

The Codex serves as a centralized knowledge repository for your project, capturing learnings, error patterns, best practices, and important project-specific information.

```
@import .ai/codex/codex.md
```

### Session Management

The session management system creates a "memory layer" for AI across multiple interactions, enabling continued context awareness.

```
# Start a new session
./.ai/scripts/session.sh start feature-name

# End a session
./.ai/scripts/session.sh end feature-name
```

### Blueprints

Blueprints provide comprehensive guides for implementing specific technical architectures, with step-by-step instructions.

```
# View a blueprint
cat .ai/blueprints/supabase-drizzle/README.md
```

### Model Context Protocol (MCP)

The MCP provides specialized rules for AI interactions with different technologies, ensuring consistent and accurate assistance.

```
@import .ai/rules/mcp/README.md
```

## Getting Started

1. Review the `codex/codex.md` file to understand the core concepts
2. Use the session management scripts to create structured AI sessions
3. Reference relevant blueprints for implementation guidance
4. Utilize snippets for consistent code patterns
5. Document learnings and status updates to build project knowledge

## Contributing

To contribute to this framework:

1. Follow the project's code style and organization
2. Document new components thoroughly
3. Update the main README.md with new features
4. Test your changes before submitting

## Additional Resources

- [Project README](../README.md) for overall project information
- [Contributing Guide](../CONTRIBUTING.md) for contribution guidelines
- [Original Repository](https://github.com/helloprkr/dotai_boiler) for reference