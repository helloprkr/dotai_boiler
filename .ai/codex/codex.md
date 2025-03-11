# AI Codex

The Codex serves as the central knowledge repository for your project. It captures learnings, error patterns, best practices, and important project-specific information that helps AI assistants provide consistent, high-quality assistance.

## Purpose

The Codex functions as an "external brain" for AI assistants, allowing them to maintain context and knowledge across different sessions and interactions. By documenting errors, learnings, and project conventions, the Codex helps prevent repeated mistakes and ensures consistent application of best practices.

## Core Components

1. **Project Context**: Essential information about your project architecture, patterns, and conventions
2. **Error Patterns**: Documented errors and their solutions to prevent recurrence
3. **Learnings**: Insights and best practices discovered during development
4. **Conventions**: Coding standards and architectural patterns specific to your project

## How to Use

### Referencing the Codex

Include the Codex in your AI conversations to provide context:

```
@import .ai/codex/codex.md
```

### Updating the Codex

To add a new learning, create a new file in the codex directory:

```bash
# Create a new learning entry
echo "# Learning: [Title] \n\n[Detailed explanation]" > .ai/codex/learn-[topic].md
```

Or use the learning template:

```bash
# Use the learning template
cp .ai/codex/learn.md .ai/codex/learn-[topic].md
# Then edit the file with your specific learning
```

### Documenting Errors

To document an error pattern:

```bash
# Create a new error entry
echo "# Error: [Error Title] \n\n[Error description and solution]" > .ai/codex/errors/error-[description].md
```

## Anatomy of a Good Codex Entry

A well-structured Codex entry includes:

1. **Clear Title**: Concise description of the entry
2. **Context**: When and why this information is relevant
3. **Details**: Thorough explanation with code examples if applicable
4. **Resolution/Application**: How to apply this knowledge
5. **References**: Links to related files or external resources

## Example Entries

### Project Architecture

```
# Project Architecture

This project follows a layered architecture with the following components:

- UI Layer: React components using the Component Pattern
- Application Layer: Custom hooks and services
- Data Layer: API clients and data transformers
- Infrastructure: Configuration and utilities

## Key Conventions

1. All components use functional style with hooks
2. Data fetching uses React Query
3. Form state management uses React Hook Form
4. Global state uses Zustand
```

### Error Pattern

```
# Error: React Render Loop

## Context
Components re-render infinitely when dependencies are incorrectly specified in useEffect hooks.

## Detection
- Browser becomes unresponsive
- Console shows excessive renders
- CPU usage spikes

## Solution
1. Check useEffect dependency arrays
2. Ensure functions used in useEffect are memoized using useCallback
3. Use ref for values that shouldn't trigger re-renders

## Example Fix
```jsx
// Problematic code
useEffect(() => {
  fetchData();
}, [fetchData]); // fetchData is recreated on each render

// Fixed code
const fetchData = useCallback(() => {
  // implementation
}, [dependency1, dependency2]);

useEffect(() => {
  fetchData();
}, [fetchData]);
```

## Benefits of Maintaining the Codex

1. **Consistent AI Assistance**: AI tools provide consistent responses based on project knowledge
2. **Knowledge Persistence**: Valuable insights are preserved across sessions
3. **Onboarding Aid**: New team members can quickly understand project patterns and avoid common pitfalls
4. **Error Prevention**: Documented error patterns help avoid recurring issues
5. **Best Practice Enforcement**: Standardized approaches to common problems

---

**Note**: The Codex is a living document that should evolve with your project. Regularly update it to reflect new learnings and changing patterns.