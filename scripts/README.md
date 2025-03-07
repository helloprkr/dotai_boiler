# .ai Scripts

This directory contains utility scripts for the .ai tooling system.

## Timestamp Management

The `timestamp.sh` script provides automated timestamp management for status updates and other .ai files. This ensures consistent time tracking across all project documentation.

### Usage

```bash
# Start a new session (creates YYYY-MM-DD.md with initialized timestamps)
./.ai/scripts/timestamp.sh start

# End a session (creates YYYY-MM-DD-EOD.md with calculated duration)
./.ai/scripts/timestamp.sh end

# Update timestamp in a specific file
./.ai/scripts/timestamp.sh update path/to/file.md
```

### Features

- Automatically creates session files with proper timestamp sections
- Calculates session duration from start to end time
- Updates "Last Updated" timestamps in existing files
- Maintains consistent UTC time format across all files
- Creates proper EOD (End of Day) status files

### Integration with .ai Workflow

This script is designed to be used in conjunction with the session start/end procedures:

1. At the beginning of a session, run `timestamp.sh start`
2. Throughout the session, periodically run `timestamp.sh update .ai/status/YYYY-MM-DD.md`
3. At the end of a session, run `timestamp.sh end`

### Timestamp Format

All timestamps follow the standard format: `YYYY-MM-DD HH:MM:SS UTC`

For more details on the timestamp procedure, see [.ai/status/timestamp-template.md](../status/timestamp-template.md). 