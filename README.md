# OpenCode Config

Quick install:

```powershell
# Windows
Invoke-WebRequest "https://raw.githubusercontent.com/vpcea2s1r/opencode-config/main/opencode.json" -OutFile "$env:APPDATA\opencode\opencode.json"
```

```bash
# Linux/Mac
curl -fsSL https://raw.githubusercontent.com/vpcea2s1r/opencode-config/main/opencode.json -o ~/.config/opencode/opencode.json
```

## Files

- `opencode.json` - Main config
- `CLAUDE.md` - Coding guidelines
- `AGENTS.md` - Agent instructions