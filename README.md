# OpenCode Config

OpenCode configuration with optimized free Zen models and temperature settings.

## Quick Install

### Windows

```powershell
# PowerShell
mkdir "$env:APPDATA\opencode" -Force -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vpcea2s1r/opencode-config/main/opencode.json" -OutFile "$env:APPDATA\opencode\opencode.json"
```

### Linux/Mac/WSL

```bash
mkdir -p ~/.config/opencode
curl -fsSL https://raw.githubusercontent.com/vpcea2s1r/opencode-config/main/opencode.json -o ~/.config/opencode/opencode.json
```

## Features

- **Free Zen models** only (no API key needed)
- **Temperature settings** per agent
- **Performance modes**: precise, balanced, fast

### Models

| Model | Purpose | Temperature |
|-------|--------|-----------|
| `big-pickle` | Planning, architecture | 0.1 |
| `gpt-5-nano` | Implementation | 0.2 |
| `minimax-m2.5-free` | Testing | 0.3 |
| `nemotron-3-super-free` | Fast tasks | 0.2 |

## Usage

```bash
# List models
opencode models

# Run with specific mode
opencode --mode precise "your task"
opencode --model opencode/gpt-5-nano "quick fix"
```

## Sync Config

```bash
# Update config
curl -fsSL https://raw.githubusercontent.com/vpcea2s1r/opencode-config/main/opencode.json -o ~/.config/opencode/opencode.json
```

## Troubleshooting

```bash
# Check config
opencode config

# Enable debug
opencode --debug "your prompt"
```