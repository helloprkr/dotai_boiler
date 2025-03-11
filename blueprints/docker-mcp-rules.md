# Docker MCP (Model Context Protocol) Rules

Use this guide to optimize AI-assisted development for Docker-based containerization, especially in the context of Go applications.

## Overview

This blueprint provides comprehensive guidelines for configuring AI models to understand Docker patterns, best practices for containerizing Go applications, and integration with Dagger for efficient CI/CD workflows.

## MCP Context Rules for Docker

```json
{
  "context": {
    "tool": "docker",
    "purpose": "containerization",
    "language_context": "go",
    "priority": "high"
  },
  "rules": [
    {
      "id": "docker.structure",
      "description": "Rules for Dockerfile structure and organization",
      "patterns": [
        "Use multi-stage builds to minimize image size",
        "Order commands by change frequency (least to most)",
        "Group related commands to optimize layer caching",
        "Use specific version tags for base images",
        "Use COPY instead of ADD for simple file copying",
        "Set appropriate WORKDIR before operations",
        "Use the minimal base image needed (e.g., alpine, scratch)"
      ]
    },
    {
      "id": "docker.go_specific",
      "description": "Docker patterns specific to Go applications",
      "patterns": [
        "Use golang:alpine as build image and scratch/alpine as runtime image",
        "Set CGO_ENABLED=0 for static binaries",
        "Set GOOS and GOARCH explicitly for cross-compilation",
        "Copy go.mod and go.sum files first to leverage layer caching",
        "Run go mod download as a separate step",
        "Build with flags like -ldflags=\"-s -w\" to reduce binary size",
        "Use non-root users for running applications"
      ]
    },
    {
      "id": "docker.security",
      "description": "Security practices for Docker containers",
      "patterns": [
        "Run containers as non-root users",
        "Use specific versions instead of latest tag",
        "Implement proper secret management",
        "Scan images for vulnerabilities",
        "Minimize installed packages in final image",
        "Remove build tools and unnecessary files",
        "Set appropriate file permissions"
      ]
    },
    {
      "id": "docker.optimization",
      "description": "Optimization techniques for Docker images",
      "patterns": [
        "Use .dockerignore to exclude unnecessary files",
        "Combine RUN commands with && to reduce layers",
        "Clean package manager caches in the same RUN step",
        "Use BuildKit for faster builds",
        "Leverage appropriate caching mechanisms",
        "Optimize for image size when appropriate",
        "Consider distroless images for security and size"
      ]
    }
  ]
}
```

## Effective Dockerfile Examples

### Multi-Stage Build for Go Applications

```dockerfile
# Build Stage
FROM golang:1.23-alpine AS build

WORKDIR /app

# Copy dependencies first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-s -w" \
    -o /app/server ./cmd/server

# Runtime Stage
FROM alpine:3.19

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy binary from build stage
COPY --from=build /app/server /app/server

# Create non-root user
RUN adduser -D -g '' appuser && \
    chown -R appuser:appuser /app

USER appuser

# Set runtime configurations
EXPOSE 8080
ENTRYPOINT ["/app/server"]
```

### Minimal Image Using Scratch

```dockerfile
# Build Stage
FROM golang:1.23-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-s -w -extldflags '-static'" \
    -o /app/server ./cmd/server

# Runtime Stage - Using scratch for smallest possible image
FROM scratch

# Import CA certificates for HTTPS
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

WORKDIR /app

# Copy binary from build stage
COPY --from=build /app/server /app/server

# Set runtime configurations
EXPOSE 8080
ENTRYPOINT ["/app/server"]
```

## Docker Compose Integration

For local development environments, consider this docker-compose.yml structure:

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: development  # Use a development-focused stage
    volumes:
      - .:/app
      - go-mod-cache:/go/pkg/mod
    ports:
      - "8080:8080"
    environment:
      - ENV=development
    depends_on:
      - db
  
  db:
    image: postgres:15-alpine
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=app
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=app

volumes:
  go-mod-cache:
  postgres-data:
```

## Integration with Dagger

When using Docker with Dagger:

```go
func (m *Builder) BuildDockerImage(ctx context.Context) (string, error) {
    // Build the Go application
    src := dag.Host().Directory(".")
    
    // Use Dagger's container API for Dockerfile-like operations
    container := dag.Container().
        From("golang:1.23-alpine").
        WithWorkdir("/app").
        WithFile("go.mod", src.File("go.mod")).
        WithFile("go.sum", src.File("go.sum")).
        WithExec([]string{"go", "mod", "download"}).
        WithDirectory(".", src).
        WithExec([]string{
            "go", "build",
            "-ldflags", "-s -w",
            "-o", "/app/server",
            "./cmd/server",
        })
    
    // Create the runtime image
    return dag.Container().
        From("alpine:3.19").
        WithExec([]string{"apk", "--no-cache", "add", "ca-certificates"}).
        WithFile("/app/server", container.File("/app/server")).
        WithEntrypoint([]string{"/app/server"}).
        WithExposedPort(8080).
        Publish(ctx, "myapp:latest")
}
```

## Usage in Projects

To apply these Docker MCP rules to your Go projects:

1. Create standardized Dockerfile templates for different application types
2. Implement proper multi-stage builds
3. Optimize for both development and production environments
4. Consider security implications of containerization
5. Integrate with CI/CD workflows using Dagger

## Remember

Docker containers should be treated as immutable infrastructure. Focus on creating reproducible, secure, and efficient container images. For Go applications specifically, leverage the language's ability to create small, static binaries that run efficiently in minimal containers. 