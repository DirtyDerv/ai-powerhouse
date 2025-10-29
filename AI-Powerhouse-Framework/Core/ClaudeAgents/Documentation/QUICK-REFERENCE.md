# Claude Agents - Quick Reference

## 🚀 Essential Commands

```powershell
# Show all agents
agent-help

# Core development agents
security-review "<your code/question>"
generate-tests "<function to test>"
generate-docs "<code to document>"
code-review "<code to review>"
debug-issue "<problem description>"

# Electronics design
electronics-design "<circuit description>"
component-pricing "<component name>"
pcb-layout "<PCB requirements>"

# Meta commands
agent-pipeline security-review,generate-tests "<code>"
compare-agents code-review,security-review "<code>"
```

## ⌨️ VS Code Shortcuts

| Shortcut | Agent |
|----------|--------|
| `Ctrl+Shift+Alt+S` | Security |
| `Ctrl+Shift+Alt+T` | Testing |
| `Ctrl+Shift+Alt+D` | Documentation |
| `Ctrl+Shift+Alt+R` | Code Review |
| `Ctrl+Shift+Alt+B` | Debug |
| `Ctrl+Shift+Alt+E` | Electronics |

## 📝 Code Snippets (VS Code)

Type and press Tab:
- `aisec` → Security review
- `aitest` → Test generation
- `aidoc` → Documentation
- `aielec` → Electronics design
- `aiprice` → Component pricing

## 🔧 PowerShell Shortcuts

```powershell
# Quick shortcuts (from profile)
ca        # agent-help
sec       # security-review
test      # generate-tests
ea        # electronics-design
ap        # agent-pipeline
```

## 📁 File Locations

- **Agents**: `%USERPROFILE%\.claude-agents\agents\`
- **Module**: `%USERPROFILE%\Documents\PowerShell\Modules\ClaudeAgents\`
- **VS Code**: `%APPDATA%\Code\User\`
- **Logs**: `%USERPROFILE%\.claude-agents\logs\`

## 🛠️ Troubleshooting

```powershell
# Validate installation
.\Validate-ClaudeAgents.ps1

# Reload module
Import-Module ClaudeAgents -Force

# Check Claude CLI
claude --version

# View logs
Get-Content "$env:USERPROFILE\.claude-agents\logs\agent-interactions.log" -Tail 20
```