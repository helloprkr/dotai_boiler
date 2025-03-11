# 🧿 DotAI Boiler

<div align="center">

<!-- Add logo once you have one
<img src="https://github.com/helloprkr/dotai_boiler/assets/raw/main/docs/images/logo.png" alt="DotAI Boiler Logo" width="200"/>
-->

[![DotAI Boiler](https://img.shields.io/badge/DotAI-Boiler-4285F4?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xMiAyQzYuNDggMiAyIDYuNDggMiAxMnM0LjQ4IDEwIDEwIDEwIDEwLTQuNDggMTAtMTBTMTcuNTIgMiAxMiAyem0xIDE3aC0ydi0yaDF2LTVoLTF2LTJoM3Y3em0wLTEySC0xMVY1aDJ2MnoiLz48L3N2Zz4=)](https://github.com/helloprkr/dotai_boiler)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](./LICENSE)
[![Code Quality](https://img.shields.io/badge/AI_Enhanced-Code_Quality-FF5700?style=for-the-badge)]()
[![Stars](https://img.shields.io/github/stars/helloprkr/dotai_boiler?style=for-the-badge)](https://github.com/helloprkr/dotai_boiler/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/helloprkr/dotai_boiler?style=for-the-badge)](https://github.com/helloprkr/dotai_boiler/commits/main)

**A sophisticated framework for AI-assisted development workflows**

DotAI Boiler transforms your development workflow by creating a structured knowledge ecosystem that evolves with your project, ensuring AI assistants maintain deep context across sessions while enforcing consistent implementation patterns. This sophisticated framework bridges the gap between human creativity and machine precision, dramatically reducing cognitive overhead and technical debt through its comprehensive Codex system, session management tools, and standardized blueprints that adapt to your specific project requirements.


[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#️-architecture) • [Advanced Features](#-advanced-features) • [Contributing](#-contributing) • [License](#-license)

</div>

## 📋 Table of Contents

- [🤖 DotAI Boiler](#-dotai-boiler)
  - [📋 Table of Contents](#-table-of-contents)
  - [✨ Features](#-features)
  - [🚀 Installation](#-installation)
    - [Prerequisites](#prerequisites)
    - [Basic Installation](#basic-installation)
    - [Advanced Installation Options](#advanced-installation-options)
  - [📚 Usage](#-usage)
    - [AI Codex](#ai-codex)
    - [Session Management](#session-management)
    - [Blueprints](#blueprints)
    - [Quick Start Guide](#quick-start-guide)
  - [🏗️ Architecture](#️-architecture)
  - [🔧 Advanced Features](#-advanced-features)
    - [Model Context Protocol (MCP)](#model-context-protocol-mcp)
    - [AI Plugins](#ai-plugins)
    - [Integration Capabilities](#integration-capabilities)
  - [🛠️ Customization](#️-customization)
    - [Creating Custom Rules](#creating-custom-rules)
    - [Extending Blueprints](#extending-blueprints)
  - [👥 Contributing](#-contributing)
  - [📝 License](#-license)
  - [🙏 Acknowledgements](#-acknowledgements)
  - [📊 Project Status](#-project-status)

## ✨ Features

- **💡 AI Codex System**: Repository of learnings and errors to improve code quality over time
- **🤝 AI Assistant Integration**: Seamless workflow with AI coding assistants like GitHub Copilot, Claude, and ChatGPT
- **💾 Session Management**: Maintain project context across multiple interactions with persistent memory
- **🗺️ Blueprints**: Comprehensive guides for implementing specific technical architectures
- **📝 Snippets**: Code templates for consistent implementation patterns across your project
- **📏 MCP Rules**: Specialized rules for AI interactions with different technologies
- **📚 Version Controlled AI Memory**: Track and manage AI learning across your project lifecycle
- **🔄 Workflow Automation**: Streamline repetitive tasks with AI-powered scripts
- **🧩 Plugin System**: Extend functionality with custom plugins and integrations

## 🚀 Installation

### Prerequisites

- Git installed on your system
- An AI assistant of your choice (Cursor Editor, GitHub Copilot, etc.)

### Basic Installation

```bash
# Clone the repository
git clone https://github.com/helloprkr/dotai_boiler.git

# Navigate to the project directory
cd dotai_boiler

# Initialize your project
# Copy configuration files to your project root or use as a reference
cp -r .ai/ /path/to/your/project/
```

### Advanced Installation Options

For advanced users who want to customize their installation:

```bash
# Install with specific blueprints only
cp -r .ai/blueprints/supabase-drizzle/ /path/to/your/project/.ai/blueprints/

# Install as a Git submodule for easier updates
git submodule add https://github.com/helloprkr/dotai_boiler.git .ai
```

## 📚 Usage

### AI Codex

The Codex system maintains a repository of learnings and errors to improve code quality:

```bash
# Review the Codex
cat .ai/codex/codex.md

# Add a new learning to the Codex
echo "# Learning: Optimizing React re-renders \n\n..." > .ai/codex/learn-react-optimization.md

# Reference the Codex in your commits
git commit -m "fix: Apply Codex learning on React optimization (ref: learn-react-optimization.md)"
```

### Session Management

Create a "memory layer" for AI across multiple interactions:

```bash
# Start a new AI session
echo "# Session: Implementing authentication \n\n..." > .ai/session/auth-implementation.md

# Update the session with new information
echo "## Database schema \n\n..." >> .ai/session/auth-implementation.md

# Reference the session when working with your AI assistant
# @import .ai/session/auth-implementation.md
```

### Blueprints

Implement specific technical architectures with step-by-step guides:

- **Supabase + Drizzle + Server Actions**: Comprehensive backend architecture
  ```bash
  # View the blueprint
  cat .ai/blueprints/supabase-drizzle/README.md
  
  # Follow implementation steps
  cat .ai/blueprints/supabase-drizzle/01-setup.md
  ```

- **Flux + Replicate**: Image generation workflow
  ```bash
  # View the blueprint
  cat .ai/blueprints/flux-replicate/README.md
  ```

- **Model Context Protocol (MCP)**: Optimized AI interactions
  ```bash
  # View the MCP documentation
  cat .ai/rules/mcp/README.md
  ```

### Quick Start Guide

1. Initialize DotAI Boiler in your project
2. Create a session file for your current task
3. Reference appropriate blueprints for implementation
4. Use snippets for consistent code patterns
5. Document learnings in the Codex for future reference

## 🏗️ Architecture

```
.
├── .ai/                  # AI-assisted development tools
│   ├── actions/          # Automated actions for AI workflows
│   ├── blueprints/       # Architecture implementation guides
│   │   ├── supabase-drizzle/    # Supabase backend architecture
│   │   ├── flux-replicate/      # Image generation workflow
│   │   └── nextjs-complete/     # Full-stack Next.js architecture
│   ├── codex/            # Repository of AI learnings and errors
│   │   ├── codex.md      # Main codex document
│   │   ├── learn.md      # Template for new learnings
│   │   └── errors/       # Documented error patterns
│   ├── components/       # Reusable UI/UX components
│   ├── lib/              # Library documentation and examples
│   │   ├── react/        # React-specific libraries
│   │   └── node/         # Node.js utilities
│   ├── plugins/          # Integration with external AI tools
│   │   ├── v0/           # v0.dev integration
│   │   └── replicate/    # Replicate models integration
│   ├── rules/            # Rules for AI behavior
│   │   ├── mcp/          # Model Context Protocol rules
│   │   ├── typescript/   # TypeScript-specific rules
│   │   └── nextjs/       # Next.js framework rules
│   ├── scripts/          # Automation scripts
│   │   ├── session.sh    # Session management utilities
│   │   └── codex.sh      # Codex management utilities
│   ├── session/          # Session management tools
│   │   ├── start-session.md  # Start session template
│   │   ├── end-session.md    # End session template
│   │   └── template.md   # Session template
│   ├── snippets/         # Code templates
│   │   ├── react/        # React component templates
│   │   ├── nextjs/       # Next.js templates
│   │   └── typescript/   # TypeScript utility templates
│   └── status/           # Session status tracking
├── .cursor/              # Cursor editor configuration
│   └── rules/            # MCP rules for the Cursor editor
│       ├── go.mcp        # Go language rules
│       ├── docker.mcp    # Docker containerization rules
│       └── dagger.mcp    # Dagger CI/CD rules
└── README.md             # Project documentation
```

## 🔧 Advanced Features

### Model Context Protocol (MCP)

The Model Context Protocol provides specialized rules for AI interactions with different technologies:

- **Cursor MCP Rules**: Optimized for Go, Dagger, and Docker development
  ```
  // Example Go MCP rule
  @rule go_error_handling {
    context: "error handling pattern in Go",
    pattern: "if err != nil { return nil, err }",
    explanation: "Standard Go error handling pattern"
  }
  ```

- **Docker MCP Rules**: Best practices for Docker containerization
  ```
  // Example Docker MCP rule
  @rule docker_multistage {
    context: "multi-stage Docker builds",
    pattern: "FROM ... AS builder\n...\nFROM ...\nCOPY --from=builder",
    explanation: "Use multi-stage builds to reduce image size"
  }
  ```

### AI Plugins

- **v0.dev Integration**: Generate React components from screenshots and natural language
  ```bash
  # Generate a component from description
  cat .ai/plugins/v0/examples/navbar.md | curl -X POST https://v0.dev/api/generate
  ```

- **Replicate Models Integration**: Access specialized AI models for various tasks
  ```bash
  # Use Replicate for image generation
  source .ai/plugins/replicate/setup.sh
  replicate-run stability-ai/sdxl "A futuristic city with flying cars"
  ```

### Integration Capabilities

- **GitHub Actions**: Automate workflows with AI-enhanced GitHub Actions
- **Hugging Face**: Connect to specialized AI models for domain-specific tasks
- **LangChain**: Build advanced AI applications with the LangChain framework

## 🛠️ Customization

### Creating Custom Rules

You can create custom MCP rules for your specific technology stack:

1. Create a new rule file in `.ai/rules/custom/`
2. Define your rules using the MCP syntax
3. Reference your rules in your AI sessions

Example custom rule:
```
// .ai/rules/custom/my-framework.mcp
@rule my_framework_pattern {
  context: "recommended pattern for MyFramework",
  pattern: "...",
  explanation: "..."
}
```

### Extending Blueprints

Create custom blueprints for your organization's preferred architectures:

1. Create a new directory in `.ai/blueprints/`
2. Add README.md with overview and purpose
3. Create step-by-step implementation guides
4. Include code examples and configuration templates

## 👥 Contributing

We welcome contributions to improve the DotAI Boiler framework! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
6. Add a changelog entry with your contribution

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- [Cursor](https://cursor.sh/) - The AI-native code editor
- [OpenAI](https://openai.com/) - For advancements in AI assistance
- [Anthropic](https://www.anthropic.com/) - For Claude's helpful capabilities
- [All contributors](https://github.com/helloprkr/dotai_boiler/graphs/contributors) who have helped shape this framework

## 📊 Project Status

DotAI Boiler is in active development. We're constantly improving the framework based on real-world usage and feedback. Check the [GitHub repository](https://github.com/helloprkr/dotai_boiler) for the latest updates.

Current version: `0.6.0-beta`

---

<div align="center">

**DotAI Boiler** — Elevating development workflows with artificial intelligence

<p align="center">
  <a href="https://github.com/helloprkr/dotai_boiler/stargazers">⭐ Star us on GitHub</a>
</p>

</div>
