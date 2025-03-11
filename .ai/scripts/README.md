# AI Scripts

This directory contains utility scripts that help manage and automate AI-assisted development workflows. These scripts can be used to create sessions, manage the codex, and perform other routine tasks.

## Available Scripts

- **session.sh**: Manages AI sessions and status tracking
- **codex.sh**: Helps maintain and organize the AI Codex
- **generate.sh**: Generates code snippets from templates

## Using Scripts

Make sure the scripts are executable before running them:

```bash
chmod +x .ai/scripts/*.sh
```

Run scripts from your project root directory:

```bash
./.ai/scripts/session.sh start my-feature
```

## Session Management

The `session.sh` script helps manage AI sessions:

```bash
# Start a new session
./.ai/scripts/session.sh start auth-implementation

# End a session and create a status report
./.ai/scripts/session.sh end auth-implementation

# List all available sessions
./.ai/scripts/session.sh list

# Show help information
./.ai/scripts/session.sh help
```

## Codex Management

The `codex.sh` script helps maintain your AI knowledge base:

```bash
# Add a new learning to the codex
./.ai/scripts/codex.sh learn "React useEffect cleanup"

# Document an error pattern
./.ai/scripts/codex.sh error "React state update in unmounted component"

# List all codex entries
./.ai/scripts/codex.sh list
```

## Creating Custom Scripts

You can create additional scripts to automate your workflow:

1. Create a new script file in this directory
2. Make it executable with `chmod +x <script-name>.sh`
3. Add documentation in the script header
4. Document the script in this README

## Script Template

```bash
#!/bin/bash

# Script Name: example.sh
# Description: Example utility script template
# Usage: ./example.sh [argument]

# Display help information
show_help() {
  echo "Usage: ./example.sh [argument]"
  echo "Description: This is an example script"
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message"
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

# Your script implementation
echo "Hello from example script!"
echo "Argument provided: $1"

exit 0
```