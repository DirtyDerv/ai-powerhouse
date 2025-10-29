# Claude Agents System - Installation Guide

## 🚀 Quick Start

The Claude Agents System provides 9 specialized AI assistants for software and hardware development. This installer deploys everything you need for a complete AI-enhanced development environment.

### Prerequisites

- **PowerShell 7.0+** (Windows PowerShell 5.1 not supported)
- **Claude CLI** - Install from [Anthropic's documentation](https://docs.anthropic.com/claude/docs)
- **VS Code** (optional but recommended)
- **Claude API Key** configured in Claude CLI

### Installation

1. **Download** the Claude Agents installer package
2. **Extract** to a temporary directory
3. **Run** the installer as Administrator (recommended):

```powershell
# Standard installation (recommended)
.\Install-ClaudeAgents.ps1

# PowerShell-only (skip VS Code integration)
.\Install-ClaudeAgents.ps1 -NoVSCode

# Skip prerequisite checking
.\Install-ClaudeAgents.ps1 -SkipPrerequisites
```

### Validation

After installation, run the validation script to ensure everything works:

```powershell
.\Validate-ClaudeAgents.ps1
```

---

## 🤖 Available Agents

### Core Development Agents

| Agent | Command | Description |
|-------|---------|-------------|
| **Security** | `security-review` | Security vulnerability analysis, threat modeling |
| **Testing** | `generate-tests` | Unit test generation, test strategy, coverage analysis |
| **Documentation** | `generate-docs` | API docs, README files, code comments |
| **Performance** | `analyze-performance` | Performance optimization, bottleneck analysis |
| **Code Review** | `code-review` | Code quality analysis, best practices |
| **Debug** | `debug-issue` | Bug analysis, root cause investigation |
| **Architecture** | `design-architecture` | System design, architectural patterns |
| **Refactoring** | `refactor-code` | Code improvement, pattern implementation |

### Specialized Agents

| Agent | Command | Description |
|-------|---------|-------------|
| **Electronics** | `electronics-design` | Circuit design, PCB layout, component pricing |
| | `component-pricing` | UK supplier pricing search |
| | `pcb-layout` | PCB design assistance |

### Meta Commands

| Command | Description |
|---------|-------------|
| `agent-help` | Show all available agents and usage |
| `agent-pipeline` | Run multiple agents in sequence |
| `compare-agents` | Compare responses from different agents |

---

## ⌨️ VS Code Integration

### Keyboard Shortcuts

| Shortcut | Agent | Description |
|----------|--------|-------------|
| `Ctrl+Shift+Alt+S` | Security | Security review of current file |
| `Ctrl+Shift+Alt+T` | Testing | Generate tests for current file |
| `Ctrl+Shift+Alt+D` | Documentation | Generate documentation |
| `Ctrl+Shift+Alt+P` | Performance | Performance analysis |
| `Ctrl+Shift+Alt+R` | Code Review | Review current file |
| `Ctrl+Shift+Alt+B` | Debug | Debug assistance |
| `Ctrl+Shift+Alt+A` | Architecture | Architecture guidance |
| `Ctrl+Shift+Alt+F` | Refactoring | Refactoring suggestions |
| `Ctrl+Shift+Alt+E` | Electronics | Electronics design help |
| `Ctrl+Shift+Alt+C` | Component Pricing | Component pricing search |

### VS Code Tasks

Access via `Ctrl+Shift+P` → "Tasks: Run Task":

- **Security Agent**: Run security analysis
- **Testing Agent**: Generate unit tests
- **Electronics Agent**: Circuit design assistance
- **Agent Pipeline**: Run multiple agents sequentially

### Code Snippets

Type these prefixes in VS Code and press Tab:

| Prefix | Description |
|--------|-------------|
| `aisec` | Security review request |
| `aitest` | Test generation request |
| `aidoc` | Documentation request |
| `aiperf` | Performance analysis request |
| `aireview` | Code review request |
| `aidebug` | Debug assistance request |
| `aiarch` | Architecture guidance request |
| `airef` | Refactoring request |
| `aielec` | Electronics design request |
| `aiprice` | Component pricing request |
| `aipcb` | PCB layout request |

---

## 🔧 Usage Examples

### Basic Usage

```powershell
# Get help and see all agents
agent-help

# Security analysis of current project
security-review "Analyze this authentication system for vulnerabilities"

# Generate tests for a specific function
generate-tests "Create unit tests for the calculateTax function"

# Electronics design
electronics-design "Design an ESP32-based temperature monitor with WiFi"

# Component pricing (UK suppliers)
component-pricing "ESP32-WROOM-32"
```

### Advanced Usage

```powershell
# Run multiple agents in sequence
agent-pipeline security-review,generate-tests,generate-docs "Review this API endpoint"

# Compare responses from different agents
compare-agents security-review,code-review "Analyze this payment processing code"

# Electronics with automatic pricing
electronics-design "Arduino-based motor controller" -SearchPrices

# PCB layout assistance
pcb-layout "4-layer board for high-speed digital signals"
```

### File-based Analysis

```powershell
# Analyze specific files
security-review -FilePath ".\src\auth.py" -Prompt "Check for authentication bypass"

# Generate tests for a file
generate-tests -FilePath ".\lib\utils.js" -Prompt "Create comprehensive tests"

# Electronics project analysis
electronics-design -FilePath ".\project.kicad_sch" -Prompt "Optimize this circuit"
```

---

## 📁 Installation Structure

After installation, you'll have:

```
%USERPROFILE%\.claude-agents\
├── agents\               # Agent prompt files
│   ├── security-agent.txt
│   ├── testing-agent.txt
│   ├── electronics-agent.txt
│   └── ...
├── config\               # Configuration files
└── logs\                 # Agent interaction logs

%USERPROFILE%\Documents\PowerShell\Modules\ClaudeAgents\
├── ClaudeAgents.psd1     # Module manifest
├── ClaudeAgents.psm1     # Module file
└── Functions\            # Agent functions
    ├── Invoke-SecurityAgent.ps1
    ├── Invoke-ElectronicsAgent.ps1
    └── ...

%APPDATA%\Code\User\      # VS Code configuration
├── tasks.json            # Global tasks
├── keybindings.json      # Keyboard shortcuts
├── python.json           # Python snippets
├── javascript.json       # JavaScript snippets
└── global.json           # Global snippets
```

---

## 🛠️ Troubleshooting

### Common Issues

**"Module not found"**
```powershell
# Reload the module
Import-Module ClaudeAgents -Force

# Check module path
$env:PSModulePath -split ';'
```

**"Claude CLI not found"**
```powershell
# Install Claude CLI first
# https://docs.anthropic.com/claude/docs

# Test Claude CLI
claude --version
```

**"Agent prompts not found"**
```powershell
# Check agent directory
ls "$env:USERPROFILE\.claude-agents\agents"

# Re-run installer if files missing
.\Install-ClaudeAgents.ps1
```

**VS Code shortcuts not working**
1. Restart VS Code after installation
2. Check if keybindings.json was updated
3. Manually merge if you have custom keybindings

### Validation

Run the validation script to diagnose issues:

```powershell
.\Validate-ClaudeAgents.ps1
```

### Logging

Installation and agent interactions are logged:
- Installation log: `$env:TEMP\ClaudeAgents-Install.log`
- Agent interactions: `%USERPROFILE%\.claude-agents\logs\agent-interactions.log`

---

## 🔄 Updates and Maintenance

### Updating

To update the system:
1. Download new installer package
2. Run installer (it will update existing installation)
3. Restart PowerShell and VS Code

### Uninstalling

```powershell
.\Install-ClaudeAgents.ps1 -Uninstall
```

### Backup

Before major changes, backup:
- `%USERPROFILE%\.claude-agents\` (agent prompts and logs)
- `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (profile)
- VS Code settings (automatically backed up by installer)

---

## 🎯 Best Practices

### Security
- Review agent responses before implementing suggestions
- Don't share sensitive code with AI without approval
- Use agents for analysis, not blind implementation

### Performance
- Use specific, focused prompts for better results
- Combine agents with `agent-pipeline` for comprehensive analysis
- Use file paths when analyzing specific code

### Electronics Design
- Include component requirements and constraints
- Use `-SearchPrices` for accurate UK pricing
- Validate electrical specifications independently

### Team Usage
- Share agent prompt customizations
- Document common agent workflows
- Use consistent naming for project-specific prompts

---

## 📞 Support

### Resources
- GitHub Issues: [Project Repository]
- Documentation: This README
- Validation: `.\Validate-ClaudeAgents.ps1`

### Contributing
1. Fork the project
2. Create agent improvements
3. Test with validation script
4. Submit pull request

---

## 📄 License

Claude Agents System - AI-Enhanced Development Environment
Copyright (c) 2024 AI Powerhouse Team

This project enhances development workflows with AI assistance while maintaining developer control and security.