#!/bin/bash
# Helper script to run a non-interactive iFlow task

# Check if iflow is installed
if ! command -v iflow &> /dev/null; then
    echo "Error: iflow command not found. Please install iFlow CLI first."
    exit 1
fi

# Check if prompt is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 \"Your task prompt here\""
    echo "Example: $0 \"Analyze the current project structure\""
    exit 1
fi

# Run the task in non-interactive mode
iflow -p "$*"
