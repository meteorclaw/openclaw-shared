---
name: iflow-agent
description: Execute complex AI tasks via iFlow CLI, a terminal-based AI assistant for coding, analysis, and file operations. Use when handling complex programming tasks, project analysis, code refactoring, or multi-step AI workflows that require an interactive terminal AI agent.
---

# iFlow Agent

## Overview

This skill enables OpenClaw to offload complex AI tasks to iFlow CLI, a powerful terminal-based AI assistant that can analyze code, execute programming tasks, handle file operations, and perform multi-step AI workflows directly in the terminal.

## When To Use This Skill

Use iFlow for:
- Complex programming tasks (refactoring, debugging, feature implementation)
- Full project analysis and structure documentation
- Multi-step file operations and codebase transformations
- Interactive AI-assisted problem solving
- Shell command integration and explanation

## Quick Start

For simple non-interactive tasks:
```bash
iflow -p "Your task description here"
```

For interactive tasks that require multiple steps:
Run `iflow` with PTY enabled and let iFlow handle the interactive session.

## Common Task Patterns

### 1. Project Analysis
To analyze an existing code project:
```bash
cd /path/to/your/project
iflow -p "/init\nAnalyze this project's structure, main technologies, and key features"
```

### 2. Code Creation
To create new code from scratch:
```bash
iflow -p "Create a Python script that [describe functionality]"
```

### 3. Refactoring & Improvements
To refactor existing code:
```bash
iflow -p "Refactor @src/file.ts to improve performance and readability"
```

### 4. Shell Command Assistance
To get help with shell commands:
```bash
iflow -p "!docker ps\nHelp me understand what these containers are and suggest cleanup steps"
```

## Key Features

### File References
iFlow uses `@file-path` syntax to include files in context:
- `@src/main.ts` - include a single file
- `@src/` - include all files in a directory (filtered automatically)

### Shell Command Execution
iFlow supports executing shell commands directly with `!` prefix:
- `!npm install` - install dependencies
- `!ls -la` - list directory contents

### Subagents
iFlow can invoke specialized subagents with `$agent-name` syntax:
- `$code-reviewer` - code review
- `$architect` - system architecture

## Interactive vs Non-Interactive Mode

**Non-interactive mode** (best for simple, single-turn tasks):
```bash
iflow -p "Your prompt here"
```
Output goes directly to stdout, suitable for automation.

**Interactive mode** (best for complex, multi-step tasks):
```bash
iflow
# Then enter your prompts interactively
```
Allows back-and-forth, follow-up questions, and progressive problem solving.

## Authentication

iFlow supports three authentication methods:
1. **Login with iFlow** (recommended) - browser-based OAuth login
2. **API Key** - for server environments without browser
3. **OpenAI Compatible API** - use your own model endpoint

iFlow automatically handles authentication on first run.

## Common Commands (inside iFlow interactive mode)

- `/help` - show help
- `/init` - initialize project analysis in current directory
- `/clear` - clear conversation history
- `/exit` - exit the CLI
- `/cleanup-checkpoint` - clean up checkpoint files to free disk space
- `/cleanup-history` - clean up conversation history to free disk space
- `!command` - execute system command
- `@file` - reference a file in context

## Disk Space Management

iFlow stores conversation history and checkpoint files in `~/.iflow` directory, which can grow large over time:

- Current typical size: ~39GB
- Suggest cleaning up when exceeding 50GB
- Run these commands inside iFlow to free space:
  - `/cleanup-checkpoint` - removes old checkpoint files (safe operation)
  - `/cleanup-history` - removes old conversation history (safe operation)

You can also manually check current disk usage:
```bash
du -sh ~/.iflow
```

## Resources

### scripts/
Contains helper scripts for running iFlow tasks from OpenClaw.

### references/
Contains the official iFlow quickstart documentation for reference.
