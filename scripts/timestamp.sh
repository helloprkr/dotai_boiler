#!/bin/bash
# Timestamp management script for .ai files

# Make sure the scripts directory exists
mkdir -p $(dirname "$0")

# Function to get current UTC time
get_current_time() {
  date -u +"%Y-%m-%d %H:%M:%S UTC"
}

# Function to calculate duration between two timestamps
calculate_duration() {
  start_time=$1
  end_time=$2
  
  # Convert timestamps to seconds since epoch
  start_seconds=$(date -u -d "${start_time}" +%s)
  end_seconds=$(date -u -d "${end_time}" +%s)
  
  # Calculate difference in seconds
  diff_seconds=$((end_seconds - start_seconds))
  
  # Convert to hours and minutes
  hours=$((diff_seconds / 3600))
  minutes=$(( (diff_seconds % 3600) / 60 ))
  
  echo "$hours hours $minutes minutes"
}

# Function to create a new session file
create_session_file() {
  today=$(date -u +"%Y-%m-%d")
  current_time=$(get_current_time)
  file_path=".ai/status/${today}.md"
  
  if [ -f "$file_path" ]; then
    echo "Session file already exists: $file_path"
  else
    cat > "$file_path" <<EOL
# Session Update: ${today}

## Timestamp
- **Creation Time**: ${current_time}
- **Last Updated**: ${current_time}
- **Session Duration**: In progress
- **Contributors**: 

## Development Steps

1. 

## Key Decisions

- 

## Next Steps

1. 

Progress: 
EOL
    echo "Created new session file: $file_path"
  fi
}

# Function to create an EOD session file
create_eod_file() {
  today=$(date -u +"%Y-%m-%d")
  current_time=$(get_current_time)
  file_path=".ai/status/${today}-EOD.md"
  source_file=".ai/status/${today}.md"
  
  if [ -f "$source_file" ]; then
    # Extract the creation time from source file
    creation_time=$(grep "Creation Time" "$source_file" | sed 's/.*\*\*Creation Time\*\*: \(.*\)/\1/')
    
    # Calculate session duration
    duration=$(calculate_duration "$creation_time" "$current_time")
    
    # Create EOD file with proper timestamp
    cat "$source_file" | sed "s/Session Duration: In progress/Session Duration: ${duration}/" | \
      sed "s/Last Updated: .*/Last Updated: ${current_time}/" > "$file_path"
      
    echo "Created EOD file: $file_path"
  else
    echo "No session file found for today. Creating new EOD file..."
    cat > "$file_path" <<EOL
# Session Update: ${today}-EOD

## Timestamp
- **Creation Time**: ${current_time}
- **Last Updated**: ${current_time}
- **Session Duration**: 0 hours 0 minutes
- **Contributors**: 

## Development Steps

1. 

## Key Decisions

- 

## Next Steps

1. 

Progress: 
EOL
    echo "Created new EOD file: $file_path"
  fi
}

# Function to update the last updated timestamp in a file
update_timestamp() {
  file_path=$1
  current_time=$(get_current_time)
  
  if [ -f "$file_path" ]; then
    # Check if the file has a timestamp section
    if grep -q "Last Updated" "$file_path"; then
      # Update the last updated timestamp
      sed -i '' "s/Last Updated: .*/Last Updated: ${current_time}/" "$file_path"
      echo "Updated timestamp in: $file_path"
    else
      echo "No timestamp section found in: $file_path"
    fi
  else
    echo "File not found: $file_path"
  fi
}

# Main command processing
case "$1" in
  start)
    create_session_file
    ;;
  end)
    create_eod_file
    ;;
  update)
    if [ -z "$2" ]; then
      echo "Error: Please specify a file to update"
      exit 1
    fi
    update_timestamp "$2"
    ;;
  *)
    echo "Usage: $0 {start|end|update <file>}"
    echo "  start  - Create a new session file for today"
    echo "  end    - Create an EOD file with calculated duration"
    echo "  update - Update the Last Updated timestamp in the specified file"
    exit 1
    ;;
esac

exit 0 