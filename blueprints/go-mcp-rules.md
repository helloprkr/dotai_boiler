# Go MCP (Model Context Protocol) Rules

Use this guide to optimize AI-assisted development for Go projects with proper context awareness and code generation patterns.

## Overview

This blueprint provides comprehensive guidelines for configuring AI models to understand Go language patterns, best practices, and common architecture patterns for Go applications.

## MCP Context Rules for Go

```json
{
  "context": {
    "language": "go",
    "version": "1.23+",
    "purpose": "application_development",
    "priority": "high"
  },
  "rules": [
    {
      "id": "go.style",
      "description": "Rules for Go code style and formatting",
      "patterns": [
        "Use camelCase for variable names and PascalCase for exported identifiers",
        "Organize imports in alphabetical order with standard library imports first",
        "Implement error handling with descriptive error messages",
        "Keep function sizes small and focused on a single responsibility",
        "Use named return values for clarity in complex functions",
        "Maintain consistent indentation with tabs (Go standard)",
        "Place error handling immediately after the function call that might error"
      ]
    },
    {
      "id": "go.patterns",
      "description": "Common Go programming patterns",
      "patterns": [
        "Prefer composition over inheritance using embedded structs",
        "Use interfaces for abstraction and testability",
        "Implement dependency injection for better testing",
        "Use context.Context for cancellation and timeouts",
        "Employ the functional options pattern for configurable constructors",
        "Implement concurrency patterns with goroutines and channels",
        "Use errgroup for managing groups of goroutines",
        "Implement middleware patterns for HTTP handlers"
      ]
    },
    {
      "id": "go.project",
      "description": "Go project structure and organization",
      "patterns": [
        "Organize code by domain or feature, not by technical function",
        "Use /cmd directory for application entrypoints",
        "Place shared code in /internal for code not meant to be imported",
        "Use /pkg for code meant to be imported by other projects",
        "Implement /api for API definitions",
        "Place tests alongside the code they test with _test.go suffix",
        "Separate interfaces from implementations"
      ]
    },
    {
      "id": "go.testing",
      "description": "Go testing patterns and practices",
      "patterns": [
        "Use table-driven tests for testing multiple scenarios",
        "Employ interfaces and mocks for testing",
        "Write both unit and integration tests",
        "Use subtests for organizing test cases",
        "Benchmark performance-critical code",
        "Test error conditions thoroughly",
        "Implement test helpers for common setup and teardown"
      ]
    }
  ]
}
```

## Key Go Development Practices

### Error Handling

Proper error handling is crucial in Go:

```go
func ProcessData(data []byte) (Result, error) {
    item, err := parseData(data)
    if err != nil {
        return Result{}, fmt.Errorf("parsing data: %w", err)
    }
    
    processed, err := transform(item)
    if err != nil {
        return Result{}, fmt.Errorf("transforming item: %w", err)
    }
    
    return processed, nil
}
```

### Concurrency Patterns

Go's concurrency model is powerful but requires careful handling:

```go
func ProcessConcurrently(items []Item) ([]Result, error) {
    var wg sync.WaitGroup
    results := make([]Result, len(items))
    errChan := make(chan error, 1)
    
    for i, item := range items {
        wg.Add(1)
        go func(i int, item Item) {
            defer wg.Done()
            result, err := Process(item)
            if err != nil {
                select {
                case errChan <- err:
                default:
                }
                return
            }
            results[i] = result
        }(i, item)
    }
    
    wg.Wait()
    select {
    case err := <-errChan:
        return nil, err
    default:
        return results, nil
    }
}
```

### Functional Options Pattern

```go
type ServerOption func(*Server)

func WithPort(port int) ServerOption {
    return func(s *Server) {
        s.port = port
    }
}

func WithLogger(logger Logger) ServerOption {
    return func(s *Server) {
        s.logger = logger
    }
}

func NewServer(options ...ServerOption) *Server {
    s := &Server{
        port:   8080,
        logger: DefaultLogger{},
    }
    
    for _, option := range options {
        option(s)
    }
    
    return s
}
```

## Integration with Dagger and Docker

When using Go with Dagger and Docker, follow these patterns:

1. **Build efficient Docker images**:
   ```dockerfile
   FROM golang:1.23-alpine AS build
   WORKDIR /app
   COPY go.mod go.sum ./
   RUN go mod download
   COPY . .
   RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server ./cmd/server
   
   FROM alpine:latest
   COPY --from=build /app/server /app/server
   EXPOSE 8080
   CMD ["/app/server"]
   ```

2. **Dagger Go SDK patterns**:
   ```go
   func (m *Builder) BuildImage(ctx context.Context) (*dagger.Container, error) {
       return dag.Container().
           From("golang:1.23-alpine").
           WithWorkdir("/app").
           WithFile("go.mod", dag.Host().File("go.mod")).
           WithFile("go.sum", dag.Host().File("go.sum")).
           WithExec([]string{"go", "mod", "download"}).
           WithDirectory(".", dag.Host().Directory(".")).
           WithExec([]string{"go", "build", "-o", "server", "./cmd/server"}).
           File("server"), nil
   }
   ```

## Usage in Projects

To apply these MCP rules to your project:

1. Create an `.mcp` directory in your project root
2. Add a `go-rules.json` file with the rules from this blueprint
3. Reference these rules in your AI configuration
4. Consider adding code snippets as examples in a templates directory

## Remember

Always adapt these rules to your specific project requirements and team conventions. Go values simplicity and readability above all. 