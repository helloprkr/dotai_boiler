#!/bin/bash

# Session Management Utility Script
# This script provides commands for creating and managing AI sessions

# Check if .ai directory exists
if [ ! -d ".ai" ]; then
  echo "Error: .ai directory not found. Please run this script from your project root."
  exit 1
fi

# Display usage information
show_help() {
  echo "DotAI Session Management Utility"
  echo ""
  echo "Usage: ./session.sh [command] [options]"
  echo ""
  echo "Commands:"
  echo "  start [name]     Create a new session with the given name"
  echo "  end [name]       End the current session and create a status file"
  echo "  list             List all available sessions"
  echo "  status           Show the current session status"
  echo "  help             Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./session.sh start auth-implementation"
  echo "  ./session.sh end auth-implementation"
  echo ""
}

# Create a new session
create_session() {
  local name=$1
  
  # Validate name
  if [ -z "$name" ]; then
    echo "Error: Session name is required"
    echo "Usage: ./session.sh start [name]"
    exit 1
  fi
  
  # Create file path
  local file_path=".ai/session/${name}.md"
  
  # Check if session already exists
  if [ -f "$file_path" ]; then
    echo "Session '$name' already exists. Opening existing session."
    cat "$file_path"
    exit 0
  fi
  
  # Copy template and customize
  cp .ai/session/start-session.md "$file_path"
  
  # Replace placeholders
  sed -i '' "s/\[Project Name\]/$(basename $(pwd))/g" "$file_path"
  sed -i '' "s/\[Brief description of the current task or feature being implemented\]/${name}/g" "$file_path"
  
  # Add timestamp
  echo "" >> "$file_path"
  echo "Session started: $(date)" >> "$file_path"
  
  echo "Session '$name' created successfully at $file_path"
  echo "Use this session file in your AI conversations by importing it:"
  echo "@import $file_path"
}

# End a session and create a status file
end_session() {
  local name=$1
  
  # Validate name
  if [ -z "$name" ]; then
    echo "Error: Session name is required"
    echo "Usage: ./session.sh end [name]"
    exit 1
  fi
  
  # Create status file path
  local date_str=$(date +"%Y-%m-%d")
  local status_path=".ai/status/${date_str}-${name}.md"
  
  # Check if session exists
  if [ ! -f ".ai/session/${name}.md" ]; then
    echo "Error: Session '$name' not found"
    exit 1
  fi
  
  # Copy end session template
  cp .ai/session/end-session.md "$status_path"
  
  # Replace placeholders
  sed -i '' "s/\[Project Name\]/$(basename $(pwd))/g" "$status_path"
  sed -i '' "s/\[Brief description of the task that was addressed\]/${name}/g" "$status_path"
  
  # Add timestamp
  echo "" >> "$status_path"
  echo "Session ended: $(date)" >> "$status_path"
  
  echo "Session '$name' ended. Status file created at $status_path"
  echo "Reference this status in future sessions by importing it:"
  echo "@import $status_path"
}

# List all available sessions
list_sessions() {
  echo "Available Sessions:"
  echo "------------------"
  
  if [ ! "$(ls -A .ai/session/ 2>/dev/null)" ]; then
    echo "No sessions found."
    return
  fi
  
  for file in .ai/session/*.md; do
    if [ "$file" != ".ai/session/start-session.md" ] && 
       [ "$file" != ".ai/session/end-session.md" ] && 
       [ "$file" != ".ai/session/template.md" ]; then
      session_name=$(basename "$file" .md)
      first_line=$(head -n 1 "$file" 2>/dev/null)
      if [[ "$first_line" == \#* ]]; then
        first_line=${first_line#\# }
      fi
      echo "- $session_name: $first_line"
    fi
  done
  
  echo ""
  echo "Status Files:"
  echo "-------------"
  
  if [ ! "$(ls -A .ai/status/ 2>/dev/null)" ]; then
    echo "No status files found."
    return
  fi
  
  for file in .ai/status/*.md; do
    status_name=$(basename "$file" .md)
    first_line=$(head -n 1 "$file" 2>/dev/null)
    if [[ "$first_line" == \#* ]]; then
      first_line=${first_line#\# }
    fi
    echo "- $status_name: $first_line"
  done
}

# Main command processing
case "$1" in
  start)
    create_session "$2"
    ;;
  end)
    end_session "$2"
    ;;
  list)
    list_sessions
    ;;
  help)
    show_help
    ;;
  *)
    show_help
    ;;
esac

exit 0