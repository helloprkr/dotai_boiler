# Cursor MCP (Model Context Protocol) Rules

Use this guide to optimize Cursor's AI capabilities for Go, Dagger, and Docker development.

## Overview

This blueprint provides comprehensive guidelines for configuring Cursor to work optimally with Go, Dagger, and Docker, leveraging the Model Context Protocol (MCP) to enhance AI-assisted development.

## MCP Context Rules for Cursor

```json
{
  "context": {
    "editor": "cursor",
    "purpose": "go_dagger_docker_development",
    "version": "1.0",
    "priority": "high"
  },
  "rules": [
    {
      "id": "cursor.general",
      "description": "General rules for Cursor when working with Go, Dagger, and Docker",
      "patterns": [
        "Always use absolute paths when referencing project files",
        "Prioritize showing complete code snippets rather than partial ones",
        "When editing Go files, include package statements and necessary imports",
        "Use proper indentation and formatting for Go code (gofmt standard)",
        "Prefer writing complete functions rather than fragments"
      ]
    },
    {
      "id": "cursor.code_completion",
      "description": "Rules for code completion in Go projects",
      "patterns": [
        "Complete Go function signatures with proper parameter and return types",
        "Suggest error handling patterns when completing functions that could fail",
        "Include context parameters for functions that interact with external systems",
        "Suggest DockerFile patterns based on the Go application structure",
        "Complete Dagger configuration with proper syntax and structure"
      ]
    },
    {
      "id": "cursor.refactoring",
      "description": "Rules for code refactoring in Go projects",
      "patterns": [
        "Extract reusable functions with clear naming conventions",
        "Refactor error handling to use consistent patterns",
        "Convert repeated container configuration into reusable Dagger components",
        "Suggest interfaces for better abstraction when appropriate",
        "Optimize Docker configurations for smaller image sizes"
      ]
    }
  ]
}
```

## Integration with Go

Cursor should be configured to understand Go-specific syntax, patterns, and best practices:

- **Go Modules**: Recognize and suggest proper module paths and versioning
- **Error Handling**: Suggest appropriate error handling patterns (`if err != nil`)
- **Concurrency**: Recognize opportunities to use goroutines and channels
- **Testing**: Provide templates for Go tests with proper naming conventions
- **Documentation**: Generate GoDoc-compatible comments

## Integration with Dagger

When working with Dagger in Cursor:

- **Function Signatures**: Understand Dagger function parameter annotations
- **Container Operations**: Suggest common container operations and chains
- **Caching Strategies**: Recognize opportunities for proper cache mounting
- **Error Propagation**: Handle errors properly in Dagger pipelines
- **Type Checking**: Ensure proper types are used for Dagger operations

## Integration with Docker

For Docker integration:

- **Dockerfile Patterns**: Suggest multi-stage builds for Go applications
- **Image Optimization**: Recommend strategies to reduce image size
- **Environment Variables**: Template proper environment variable usage
- **Volume Management**: Suggest appropriate volume configurations
- **Network Configuration**: Provide templates for container networking

## Usage in Projects

To apply these MCP rules to your Cursor environment:

1. Create a `.cursor` directory in your project root
2. Add a `mcp.json` file with the rules from this blueprint
3. Ensure the Cursor application is configured to read MCP rules
4. Restart Cursor to apply the rules

## Example Implementation

```bash
mkdir -p .cursor
cat > .cursor/mcp.json << EOF
{
  "context": {
    "editor": "cursor",
    "purpose": "go_dagger_docker_development",
    "version": "1.0"
  },
  "rules": [
    // Include rules from this blueprint
  ]
}
EOF
```

## Remember

Always review and customize these rules to match your specific project requirements. The MCP protocol is designed to be adaptable to your workflow and coding standards. 