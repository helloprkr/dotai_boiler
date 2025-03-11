# Contributing to DotAI Boiler

Thank you for your interest in contributing to DotAI Boiler! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. Please read it before contributing.

## How Can I Contribute?

### Reporting Bugs

- Check if the bug has already been reported in the Issues section
- Use the bug report template to create a new issue
- Include detailed steps to reproduce the bug
- Include screenshots if applicable
- Describe what you expected to happen and what actually happened

### Suggesting Enhancements

- Check if the enhancement has already been suggested in the Issues section
- Use the feature request template to create a new issue
- Clearly describe the enhancement and its benefits
- Provide examples of how the enhancement would work

### Pull Requests

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
6. Add a changelog entry with your contribution

## Development Workflow

### Setting Up the Development Environment

```bash
# Clone your fork of the repository
git clone https://github.com/YOUR_USERNAME/dotai-boiler.git

# Navigate to the project directory
cd dotai-boiler

# Add the original repository as a remote
git remote add upstream https://github.com/original/dotai-boiler.git

# Install dependencies (if applicable)
# npm install
```

### Keeping Your Fork Up to Date

```bash
# Fetch changes from the original repository
git fetch upstream

# Merge changes into your main branch
git checkout main
git merge upstream/main

# Push the changes to your fork
git push
```

### Commit Guidelines

- Use meaningful commit messages that clearly describe the changes
- Format commit messages as `type(scope): message` (e.g., `feat(codex): add new learning entry`)
- Types include:
  - `feat`: A new feature
  - `fix`: A bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc.)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `test`: Adding or modifying tests
  - `chore`: Changes to the build process or auxiliary tools

### AI-Specific Contributions

When contributing to the AI components:

1. **Codex Entries**: Follow the format specified in `codex/learn.md`
2. **Blueprint Contributions**: Include complete, tested steps for implementation
3. **MCP Rules**: Document rule interactions and intended outcomes

## Testing

- Ensure all existing tests pass before submitting your PR
- Add tests for new features or bug fixes
- Document any manual testing procedures

## Documentation

- Update documentation to reflect changes in code or functionality
- Ensure code comments are clear and follow the established style
- For significant changes, update the README.md if necessary

## Styleguides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

### JavaScript/TypeScript Styleguide

- Use 2 spaces for indentation
- Prefer arrow functions for anonymous functions
- Use template literals instead of string concatenation
- Add appropriate TypeScript types
- Follow the existing code style of the project

### Documentation Styleguide

- Use Markdown for documentation
- Reference code with appropriate syntax highlighting
- Use relative links for references within the repository

## Additional Notes

### AI Training Considerations

When providing examples for AI learning:

- Ensure examples are complete and representative
- Provide both positive and negative examples
- Include edge cases where appropriate

## Attribution

This Contributing guide is adapted from the Atom Contributing guide.

---

Thank you for contributing to DotAI Boiler! Your efforts help improve the project for everyone. 