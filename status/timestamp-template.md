# Timestamp Procedure for .ai Files

## Overview
This document outlines the standard timestamp procedure to be applied to all status updates and relevant .ai files to ensure consistent time tracking across the project.

## Required Timestamp Section

Every status file should include a timestamp section immediately after the title with the following format:

```markdown
## Timestamp
- **Creation Time**: YYYY-MM-DD HH:MM:SS UTC
- **Last Updated**: YYYY-MM-DD HH:MM:SS UTC
- **Session Duration**: X hours Y minutes
```

## Additional Optional Fields

For more detailed tracking, the following fields can be added when relevant:

```markdown
- **Contributors**: [list of contributors]
- **Related Sessions**: [links to related session files]
- **Total Project Time**: [cumulative time spent]
```

## Automation Guidelines

1. Always update the "Last Updated" timestamp when modifying a file
2. Calculate session duration based on active working time
3. Use UTC for all timestamps to maintain consistency across timezones
4. For multi-day sessions, track cumulative time in "Session Duration"

## Application to Other .ai Files

This timestamp procedure should be applied to:

1. All files in the `status/` directory
2. Any session start/end files
3. Major updates to blueprint files
4. Significant changes to codex entries

## Example Implementation

```markdown
# Session Update: 2025-03-07

## Timestamp
- **Creation Time**: 2025-03-07 08:30:00 UTC
- **Last Updated**: 2025-03-07 11:45:00 UTC
- **Session Duration**: 3 hours 15 minutes
- **Contributors**: @maximvs, AI assistant
- **Related Sessions**: [2025-03-06-EOD.md](./2025-03-06-EOD.md)

## Development Steps
...
```

## Programmatic Generation

For automated timestamp generation, use the following commands:

- Current UTC time: `date -u +"%Y-%m-%d %H:%M:%S UTC"`
- Calculating duration: Store start time and compute difference on session completion

---

*Last updated: 2025-03-07 07:00:00 UTC* 