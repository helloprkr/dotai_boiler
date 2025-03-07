# Dagger MCP (Model Context Protocol) Rules

Use this guide to optimize AI-assisted development for Dagger-based CI/CD pipelines and containerized development workflows.

## Overview

This blueprint provides comprehensive guidelines for configuring AI models to understand Dagger's unique SDK patterns, container operations, and integration with Go development.

## MCP Context Rules for Dagger

```json
{
  "context": {
    "tool": "dagger",
    "version": "v0.17.0+",
    "purpose": "cicd_container_workflows",
    "priority": "high"
  },
  "rules": [
    {
      "id": "dagger.structure",
      "description": "Rules for Dagger module structure and organization",
      "patterns": [
        "Define clear module boundaries with explicit types",
        "Use descriptive function names that explain the operation",
        "Organize functions by their logical grouping or pipeline stage",
        "Add descriptive comments for function parameters",
        "Use +optional for optional parameters",
        "Mark fields as +internal-use-only when appropriate",
        "Design modules to be composable and reusable"
      ]
    },
    {
      "id": "dagger.operations",
      "description": "Common Dagger operation patterns",
      "patterns": [
        "Chain container operations fluently",
        "Use WithMountedCache for efficient caching",
        "Properly handle file and directory operations",
        "Use container.WithExec() for executing commands",
        "Properly propagate context.Context through functions",
        "Return concrete container objects rather than interfaces",
        "Use WithEnvVariable for environment configuration"
      ]
    },
    {
      "id": "dagger.integration",
      "description": "Dagger integration patterns",
      "patterns": [
        "Return both a value and error for functions that can fail",
        "Use context.Context for cancellation and timeouts",
        "Implement proper error handling and propagation",
        "Create container objects with immutable patterns",
        "Use WithWorkdir for setting the working directory",
        "Properly mount or copy files and directories"
      ]
    },
    {
      "id": "dagger.best_practices",
      "description": "Best practices for Dagger usage",
      "patterns": [
        "Minimize container image size",
        "Leverage layer caching effectively",
        "Create reproducible builds",
        "Keep build steps granular for better caching",
        "Use multi-stage builds when appropriate",
        "Document each module and function with proper comments",
        "Test pipeline components independently"
      ]
    }
  ]
}
```

## Key Dagger Development Patterns

### Module Structure

```go
// A builder for Go applications
type GoBuilder struct {
    // The source code directory
    SourceDir *dagger.Directory

    // The Go version to use
    // +optional
    GoVersion string
}

// Compile the Go application
func (b *GoBuilder) Compile(ctx context.Context) (*dagger.File, error) {
    container := dag.Container().
        From(fmt.Sprintf("golang:%s-alpine", b.GoVersion)).
        WithWorkdir("/src").
        WithDirectory(".", b.SourceDir)

    return container.
        WithExec([]string{"go", "build", "-o", "app", "./cmd/app"}).
        File("app"), nil
}
```

### Chaining Operations

```go
func (m *Pipeline) BuildAndTest(ctx context.Context) error {
    result, err := dag.Container().
        From("golang:1.23-alpine").
        WithWorkdir("/app").
        WithDirectory(".", dag.Host().Directory(".")).
        WithExec([]string{"go", "build", "./..."}).
        WithExec([]string{"go", "test", "./..."}).
        Stderr(ctx)
    
    if err != nil {
        return fmt.Errorf("build and test failed: %w", err)
    }
    
    fmt.Println(result)
    return nil
}
```

### Effective Caching

```go
func (m *Builder) CachedBuild(ctx context.Context) (*dagger.Container, error) {
    return dag.Container().
        From("golang:1.23-alpine").
        WithWorkdir("/app").
        // Mount the Go module cache
        WithMountedCache("/go/pkg/mod", dag.CacheVolume("go-mod-cache")).
        // Mount the build cache
        WithMountedCache("/root/.cache/go-build", dag.CacheVolume("go-build-cache")).
        WithFile("go.mod", dag.Host().File("go.mod")).
        WithFile("go.sum", dag.Host().File("go.sum")).
        WithExec([]string{"go", "mod", "download"}).
        WithDirectory(".", dag.Host().Directory(".")), nil
}
```

## Integration with Go and Docker

### Go Integration

```go
// ToyWorkspace demonstrates proper Dagger integration with Go
type ToyWorkspace struct {
    // The workspace's container state
    // +internal-use-only
    Container *dagger.Container
}

func New() ToyWorkspace {
    return ToyWorkspace{
        Container: dag.Container().
            From("golang").
            WithDefaultTerminalCmd([]string{"/bin/bash"}).
            WithMountedCache("/go/pkg/mod", dag.CacheVolume("go_mod_cache")).
            WithWorkdir("/app"),
    }
}

// Write a file to the workspace
func (w ToyWorkspace) Write(path, content string) ToyWorkspace {
    w.Container = w.Container.WithNewFile(path, content)
    return w
}

// Build the code
func (w *ToyWorkspace) Build(ctx context.Context) error {
    _, err := w.Container.WithExec([]string{"go", "build", "./..."}).Stderr(ctx)
    return err
}
```

### Docker Integration

```go
// Publish the application as a Docker image
func (b *Builder) Publish(ctx context.Context, tag string) (string, error) {
    container := dag.Container().
        From("golang:1.23-alpine").
        WithWorkdir("/app").
        WithDirectory(".", dag.Host().Directory(".")).
        WithExec([]string{"go", "build", "-o", "app", "./cmd/app"})
        
    return dag.Container().
        From("alpine:latest").
        WithFile("/app", container.File("app")).
        WithEntrypoint([]string{"/app"}).
        Publish(ctx, tag)
}
```

## Usage in Projects

To apply these MCP rules to your Dagger projects:

1. Define a clear module structure with typed interfaces
2. Use consistent patterns for container operations
3. Implement proper error handling and context propagation
4. Optimize for caching and build performance
5. Add clear documentation for each module and function

## Remember

Dagger is designed for immutable container operations. Always return new container objects rather than modifying existing ones. Leverage Dagger's caching capabilities for efficient CI/CD pipelines. 