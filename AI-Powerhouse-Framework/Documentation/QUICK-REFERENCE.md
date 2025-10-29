# AI Powerhouse Framework - Quick Reference

## 🚀 Essential Commands

### AI Providers (Python)
```powershell
ai "your question"              # Ask Claude (default)
ai-claude "specific question"   # Ask Claude directly
ai-gemini "your question"       # Ask Google Gemini
ai-openai "your question"       # Ask OpenAI
ai-quick "your question"        # Ask all providers
ai-compare "your question"      # Compare AI responses
```

### Specialized Agents (PowerShell)
```powershell
security-review "code to analyze"       # sec (shortcut)
generate-tests "function to test"       # test (shortcut)
generate-docs "code to document"        # doc (shortcut)
code-review "code to review"            # cr (shortcut)
debug-issue "problem description"       # dbg (shortcut)
electronics-design "circuit needs"      # ea (shortcut)
component-pricing "component name"      # cp (shortcut)
```

### File Analysis
```powershell
ai-file ".\path\to\file.py"            # Comprehensive analysis
security-review -FilePath ".\file.py"   # Security analysis
generate-tests -FilePath ".\file.py"    # Generate tests
```

### Advanced Integration
```powershell
agent-pipeline security-review,code-review "analyze this code"
Get-ComprehensiveAnalysis ".\src\main.py"
Compare-AIResponses "optimization question"
```

## ⌨️ VS Code Shortcuts

| Key | Action |
|-----|--------|
| `Ctrl+Shift+Alt+H` | Show all capabilities |
| `Ctrl+Shift+Alt+Q` | Ask Claude |
| `Ctrl+Shift+Alt+W` | Ask all AI providers |
| `Ctrl+Shift+Alt+A` | Analyze current file |
| `Ctrl+Shift+Alt+S` | Security review |
| `Ctrl+Shift+Alt+T` | Generate tests |
| `Ctrl+Shift+Alt+D` | Generate docs |
| `Ctrl+Shift+Alt+R` | Code review |
| `Ctrl+Shift+Alt+E` | Electronics design |
| `Ctrl+Shift+Alt+L` | Agent pipeline |

## 📝 Code Snippets (VS Code)

Type prefix + Tab:
- `ai` → AI query template
- `aisec` → Security review request
- `aitest` → Test generation request
- `aidoc` → Documentation request
- `aielec` → Electronics design request
- `aipipe` → Multi-agent pipeline

## 🔧 System Commands

```powershell
# Show capabilities
ai-help                    # All AI capabilities
agent-help                # All Claude Agents
ai-caps                   # Cross-system capabilities

# Module management
Import-Module ClaudeAgents -Force
Import-Module AIPowerhouse -Force

# Health checks
ai-claude "test"          # Test Claude connectivity
security-review "test"    # Test agent functionality
```

## 📁 Key Locations

- **Framework**: `%USERPROFILE%\AI-Powerhouse-Framework\`
- **Python AI**: `%USERPROFILE%\AI-Powerhouse-Framework\PythonAI\`
- **Agent Prompts**: `%USERPROFILE%\.claude-agents\agents\`
- **PowerShell Modules**: `%USERPROFILE%\Documents\PowerShell\Modules\`
- **VS Code Settings**: `%APPDATA%\Code\User\`
- **Logs**: `%USERPROFILE%\.claude-agents\logs\`

## 🛠️ Installation & Updates

```powershell
# Complete installation
.\Install-AIPowerhouseFramework.ps1

# Python only
.\Install-AIPowerhouseFramework.ps1 -PythonOnly

# PowerShell only
.\Install-AIPowerhouseFramework.ps1 -PowerShellOnly

# Uninstall
.\Install-AIPowerhouseFramework.ps1 -Uninstall

# Validation
.\Core\ClaudeAgents\Validate-ClaudeAgents.ps1
```

## 🚨 Quick Troubleshooting

```powershell
# Module issues
Import-Module ClaudeAgents -Force
Import-Module AIPowerhouse -Force

# Check Python environment
& ".\Core\PythonAI\.venv\Scripts\python.exe" --version

# Test connectivity
claude --version
ai-claude "test connection"

# View logs
Get-Content "$env:USERPROFILE\.claude-agents\logs\agent-interactions.log" -Tail 10
```

## 💡 Pro Tips

1. **Use shortcuts**: `sec`, `test`, `doc`, `ea` for quick access
2. **File context**: Add `-FilePath` for better analysis
3. **Pipeline power**: Combine agents with `agent-pipeline`
4. **Compare responses**: Use `ai-compare` for different perspectives
5. **VS Code integration**: Use keyboard shortcuts for seamless workflow

## 🎯 Common Workflows

### Code Review Workflow
```powershell
sec ".\new_feature.py"          # Security check
cr ".\new_feature.py"           # Code review
test ".\new_feature.py"         # Generate tests
doc ".\new_feature.py"          # Generate docs
```

### Electronics Design Workflow
```powershell
ea "ESP32 temperature sensor"   # Circuit design
cp "ESP32-WROOM-32"            # Component pricing
pcb "two-layer IoT board"      # PCB layout
```

### Multi-AI Analysis
```powershell
ai-compare "optimize database query performance"
ai-file ".\src\critical_module.py"
agent-pipeline security-review,performance-agent "comprehensive check"
```

Ready to supercharge your development with AI? Start with `ai-help`!