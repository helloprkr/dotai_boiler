#!/bin/bash

# Codex Management Utility Script
# This script provides commands for creating and managing the AI Codex

# Check if .ai directory exists
if [ ! -d ".ai" ]; then
  echo "Error: .ai directory not found. Please run this script from your project root."
  exit 1
fi

# Display usage information
show_help() {
  echo "DotAI Codex Management Utility"
  echo ""
  echo "Usage: ./codex.sh [command] [options]"
  echo ""
  echo "Commands:"
  echo "  learn [name] [title]    Add a new learning to the codex"
  echo "  error [name] [title]    Document an error pattern"
  echo "  list                    List all codex entries"
  echo "  view [name]             View a specific codex entry"
  echo "  help                    Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./codex.sh learn react-hooks \"React Hooks Best Practices\""
  echo "  ./codex.sh error memory-leak \"React useEffect Memory Leak Pattern\""
  echo ""
}

# Add a new learning to the codex
add_learning() {
  local name=$1
  local title=$2
  
  # Validate name
  if [ -z "$name" ]; then
    echo "Error: Learning name is required"
    echo "Usage: ./codex.sh learn [name] [title]"
    exit 1
  fi
  
  # Validate title
  if [ -z "$title" ]; then
    title="Learning: $name"
  fi
  
  # Create file path
  local file_path=".ai/codex/learn-${name}.md"
  
  # Check if learning already exists
  if [ -f "$file_path" ]; then
    echo "Learning '$name' already exists. Opening existing learning."
    cat "$file_path"
    exit 0
  fi
  
  # Copy template and customize
  cp .ai/codex/learn.md "$file_path"
  
  # Replace placeholders
  sed -i '' "s/\[Title\]/${title}/g" "$file_path"
  
  # Add timestamp
  echo "" >> "$file_path"
  echo "Created: $(date)" >> "$file_path"
  
  echo "Learning '$name' created successfully at $file_path"
  echo "Edit this file to document your learning, then reference it in your AI conversations:"
  echo "@import $file_path"
}

# Document an error pattern
add_error() {
  local name=$1
  local title=$2
  
  # Validate name
  if [ -z "$name" ]; then
    echo "Error: Error name is required"
    echo "Usage: ./codex.sh error [name] [title]"
    exit 1
  fi
  
  # Validate title
  if [ -z "$title" ]; then
    title="Error: $name"
  fi
  
  # Create file path
  local file_path=".ai/codex/errors/${name}.md"
  
  # Check if error already exists
  if [ -f "$file_path" ]; then
    echo "Error pattern '$name' already exists. Opening existing error."
    cat "$file_path"
    exit 0
  fi
  
  # Create content
  cat > "$file_path" << EOF
# Error: ${title}

## Context
[Describe when and why this error occurs]

## Symptoms
- [Symptom 1]
- [Symptom 2]
- [Additional symptoms]

## Root Causes
1. [Primary cause]
2. [Secondary cause]
3. [Additional causes]

## Solutions

### For [Cause 1]
\`\`\`
// Example solution code
\`\`\`

### For [Cause 2]
\`\`\`
// Example solution code
\`\`\`

## Prevention Strategies
1. [Strategy 1]
2. [Strategy 2]
3. [Additional strategies]

## Related Resources
- [Link to documentation]
- [Link to other resources]

---

Documented: $(date)
EOF
  
  echo "Error pattern '$name' created successfully at $file_path"
  echo "Edit this file to document the error pattern, then reference it in your AI conversations:"
  echo "@import $file_path"
}

# List all codex entries
list_entries() {
  echo "Codex Entries:"
  echo "-------------"
  
  echo "Main Codex:"
  echo "- codex.md: Core knowledge repository"
  echo ""
  
  echo "Learnings:"
  for file in .ai/codex/learn-*.md; do
    if [ -f "$file" ]; then
      learning_name=$(basename "$file" .md)
      learning_name=${learning_name#learn-}
      first_line=$(head -n 1 "$file" 2>/dev/null)
      if [[ "$first_line" == \#* ]]; then
        first_line=${first_line#\# }
      fi
      echo "- $learning_name: $first_line"
    fi
  done
  
  echo ""
  echo "Error Patterns:"
  for file in .ai/codex/errors/*.md; do
    if [ -f "$file" ]; then
      error_name=$(basename "$file" .md)
      first_line=$(head -n 1 "$file" 2>/dev/null)
      if [[ "$first_line" == \#* ]]; then
        first_line=${first_line#\# }
      fi
      echo "- $error_name: $first_line"
    fi
  done
}

# View a specific entry
view_entry() {
  local name=$1
  
  # Validate name
  if [ -z "$name" ]; then
    echo "Error: Entry name is required"
    echo "Usage: ./codex.sh view [name]"
    exit 1
  fi
  
  # Check for main codex
  if [ "$name" == "codex" ]; then
    cat .ai/codex/codex.md
    exit 0
  fi
  
  # Check for learning
  if [ -f ".ai/codex/learn-${name}.md" ]; then
    cat ".ai/codex/learn-${name}.md"
    exit 0
  fi
  
  # Check for error
  if [ -f ".ai/codex/errors/${name}.md" ]; then
    cat ".ai/codex/errors/${name}.md"
    exit 0
  fi
  
  echo "Error: Entry '$name' not found"
  echo "Use './codex.sh list' to see available entries"
  exit 1
}

# Main command processing
case "$1" in
  learn)
    add_learning "$2" "$3"
    ;;
  error)
    add_error "$2" "$3"
    ;;
  list)
    list_entries
    ;;
  view)
    view_entry "$2"
    ;;
  help)
    show_help
    ;;
  *)
    show_help
    ;;
esac

exit 0