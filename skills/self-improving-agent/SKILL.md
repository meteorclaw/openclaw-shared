---
name: self-improving-agent
description: Proactive self-improvement skill that enables the agent to analyze, refine, and improve its own skills and code. Use when the agent needs to modify existing skills, optimize performance, fix bugs, or add new features to itself.
---

# Self-Improving Agent

## Overview

This skill enables OpenClaw to proactively improve itself:
- Analyze existing skill code and documentation
- Identify bugs, inefficiencies, or missing features
- Automatically modify and improve skill files
- Validate changes and run tests
- Commit improvements to version control

## When To Use This Skill

Use self-improving-agent for:
- Fixing bugs in existing skills
- Optimizing skill performance and documentation
- Adding new features to existing skills
- Refactoring outdated skill code
- Proactive quality improvement
- Self-modification of agent capabilities

## Core Workflow

### 1. Analysis Phase
- Read the target skill's SKILL.md
- Examine all script and reference files
- Identify issues, missing features, or improvements
- Create an improvement plan

### 2. Implementation Phase
- Make targeted edits to skill files
- Update documentation to match new features
- Maintain proper OpenClaw skill structure

### 3. Validation Phase
- Validate skill structure using `quick_validate.py`
- Check for syntax errors in scripts
- Verify all file references are correct

### 4. Commit Phase
- Add changes to git
- Commit with descriptive message
- Push to remote repository (optional)

## Commands

### Validate Skill Structure
```bash
python3 /www/server/nodejs/v24.14.0/lib/node_modules/openclaw/skills/skill-creator/scripts/quick_validate.py /path/to/skill
```

## Self-Improvement Patterns

### Bug Fixing
When a skill is known to have bugs:
1. Read the skill files carefully
2. Identify the root cause
3. Fix the code while maintaining backward compatibility
4. Validate the fix

### Feature Addition
When adding new features to an existing skill:
1. Understand the current architecture
2. Add new functionality without breaking existing usage
3. Update SKILL.md documentation
4. Validate the complete skill

### Refactoring
When code needs cleanup:
1. Maintain the same external API
2. Improve internal structure and readability
3. Remove dead code
4. Update documentation

## Best Practices

1. **Always validate after changes** - Run the validator to ensure skill structure is correct
2. **Maintain backward compatibility** - Don't break existing usage
3. **Update documentation** - Code changes must be reflected in SKILL.md
4. **Small incremental changes** - Better to improve step by step than big bang changes
5. **Git commits** - Always commit after successful improvements for rollback capability

## Resources

### scripts/
Contains utility scripts for self-improvement operations.

### references/
Contains documentation on self-improvement patterns and best practices.
