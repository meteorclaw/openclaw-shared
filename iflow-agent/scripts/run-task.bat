@echo off
REM Helper script to run a non-interactive iFlow task on Windows

REM Check if iflow is installed
where iflow >nul 2>&1
if errorlevel 1 (
    echo Error: iflow command not found. Please install iFlow CLI first.
    exit /b 1
)

REM Check if prompt is provided
if "%*"=="" (
    echo Usage: %0 "Your task prompt here"
    echo Example: %0 "Analyze the current project structure"
    exit /b 1
)

REM Run the task in non-interactive mode
iflow -p "%*"
