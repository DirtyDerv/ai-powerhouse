# AI Powerhouse Framework v2.0 - Complete Developer AI Environment

## 🚀 Overview

The **AI Powerhouse Framework** is a unified, enterprise-grade AI development environment that combines:

- **🐍 Python AI Powerhouse** - Multi-provider AI integration (Claude, Gemini, OpenAI)
- **⚡ Claude Agents System** - 9 specialized development agents with PowerShell integration
- **🔗 Cross-System Integration** - Seamless communication between Python and PowerShell components
- **🔧 VS Code Global Integration** - Unified keyboard shortcuts, tasks, and code snippets
- **📦 One-Click Installation** - Deploy everything with a single installer

---

## 📦 Quick Installation

### Prerequisites
- **PowerShell 7.0+** (Windows PowerShell 5.1 not supported)
- **Python 3.8+** with pip
- **Claude CLI** (from Anthropic)
- **VS Code** (optional but recommended)
- **API Keys** configured for your AI providers

### Installation Commands

```powershell
# Complete installation (recommended)
.\Install-AIPowerhouseFramework.ps1

# Python AI only
.\Install-AIPowerhouseFramework.ps1 -PythonOnly

# PowerShell Agents only  
.\Install-AIPowerhouseFramework.ps1 -PowerShellOnly

# Skip VS Code integration
.\Install-AIPowerhouseFramework.ps1 -NoVSCode
```

---

## 🎯 Capabilities Overview

### 🐍 Python AI Providers
| Provider | Strengths | Use Cases |
|----------|-----------|-----------|
| **Claude** | Code analysis, reasoning, safety | Complex problem solving, code review |
| **Gemini** | Multimodal, fast responses | Image analysis, quick queries |
| **OpenAI** | General purpose, creative | Content generation, general tasks |

### ⚡ Specialized Claude Agents
| Agent | Focus Area | Key Features |
|-------|------------|--------------|
| **Security** | Vulnerability analysis | Threat modeling, secure coding practices |
| **Testing** | Unit test generation | Test coverage, testing strategies |
| **Documentation** | API docs, comments | README files, code documentation |
| **Performance** | Optimization | Bottleneck analysis, profiling guidance |
| **Code Review** | Quality analysis | Best practices, code standards |
| **Debug** | Issue resolution | Root cause analysis, troubleshooting |
| **Architecture** | System design | Design patterns, scalability |
| **Refactoring** | Code improvement | Pattern implementation, cleanup |
| **Electronics** | Circuit design | PCB layout, UK component pricing |

---

## 🚀 Quick Start Guide

### Basic AI Queries

```powershell
# Ask Claude (default AI)
ai "Explain quantum computing in simple terms"

# Ask all AI providers for comparison
ai-quick "Compare Python vs JavaScript for web development"

# Get comprehensive file analysis
ai-file ".\src\main.py"

# Show all capabilities
ai-help
```

### Specialized Agent Usage

```powershell
# Security analysis
security-review "Analyze this authentication system"
sec "Check for SQL injection vulnerabilities"  # shortcut

# Generate comprehensive tests
generate-tests "Create tests for the user authentication module"
test "Unit tests for payment processing"  # shortcut

# Electronics design with UK pricing
electronics-design "ESP32-based IoT temperature sensor"
component-pricing "ESP32-WROOM-32"  # UK supplier search
```

### Advanced Integration

```powershell
# Multi-agent pipeline analysis
agent-pipeline security-review,code-review,generate-tests "Analyze this API endpoint"

# Compare responses across AI systems
ai-compare "How can I optimize database performance?"

# Cross-system comprehensive analysis
Get-ComprehensiveAnalysis ".\src\payment_processor.py"
```

---

## ⌨️ VS Code Integration

### Keyboard Shortcuts
| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl+Shift+Alt+H` | Show Capabilities | Display all AI capabilities |
| `Ctrl+Shift+Alt+Q` | Ask Claude | Quick Claude query |
| `Ctrl+Shift+Alt+W` | Ask All AIs | Query all providers |
| `Ctrl+Shift+Alt+A` | Analyze File | Comprehensive file analysis |
| `Ctrl+Shift+Alt+S` | Security Review | Security analysis of current file |
| `Ctrl+Shift+Alt+T` | Generate Tests | Create tests for current file |
| `Ctrl+Shift+Alt+D` | Generate Docs | Create documentation |
| `Ctrl+Shift+Alt+R` | Code Review | Review current file |
| `Ctrl+Shift+Alt+E` | Electronics Design | Circuit design assistance |
| `Ctrl+Shift+Alt+L` | Agent Pipeline | Multi-agent analysis |

### Code Snippets
Type these prefixes and press Tab:

| Prefix | Generates | Description |
|--------|-----------|-------------|
| `ai` | AI query template | Quick AI question template |
| `aisec` | Security review | Security analysis request |
| `aitest` | Test generation | Unit test creation request |
| `aidoc` | Documentation | Documentation generation |
| `aiperf` | Performance | Performance analysis request |
| `aielec` | Electronics | Circuit design request |
| `aipipe` | Pipeline | Multi-agent pipeline |

---

## 🔗 Cross-System Integration

### Python to PowerShell Bridge

```python
from integration.unified_ai_bridge import UnifiedAI

# Initialize unified interface
ai = UnifiedAI()

# Use PowerShell agents from Python
security_analysis = ai.ps_bridge.security_review("Check this code for vulnerabilities")
test_generation = ai.ps_bridge.generate_tests("Create tests for this function")

# Comprehensive analysis using both systems
results = ai.comprehensive_code_analysis("./src/main.py")
```

### PowerShell to Python Bridge

```powershell
# Load AI Powerhouse integration
Import-Module AIPowerhouse

# Use Python AI providers from PowerShell
Ask-Claude "Explain machine learning concepts"
Ask-Gemini "Analyze this image for defects"
Ask-AllAI "Compare programming languages"

# Cross-system analysis
Compare-AIResponses "How to optimize this algorithm?"
Get-ComprehensiveAnalysis ".\src\data_processor.py"
```

---

## 🛠️ Advanced Usage Patterns

### 1. Comprehensive Code Analysis Workflow

```powershell
# Step 1: Get multiple AI perspectives
ai-compare "Review this payment processing code for issues"

# Step 2: Run specialized agents
agent-pipeline security-review,performance-agent,code-review "Comprehensive analysis"

# Step 3: Generate improvements
generate-tests "Create comprehensive test suite"
generate-docs "Document the API endpoints"
```

### 2. Electronics Design Workflow

```powershell
# Design circuit
electronics-design "Arduino-based weather station with WiFi"

# Check component availability and pricing
component-pricing "DHT22 temperature sensor"
component-pricing "ESP8266 WiFi module"

# PCB layout guidance
pcb-layout "Two-layer board for IoT device with antenna considerations"
```

### 3. Development Team Workflow

```powershell
# Daily code review
cr ".\src\new_feature.py"  # Quick code review

# Pre-commit security check
sec ".\src\auth\*"  # Security scan

# Documentation update
doc ".\api\endpoints.py"  # Generate API docs

# Performance validation
perf ".\src\data_processing.py"  # Performance analysis
```

---

## 📁 Installation Structure

```
AI-Powerhouse-Framework/
├── 🚀 Install-AIPowerhouseFramework.ps1    # Main installer
├── 📋 README.md                            # This documentation
│
├── Core/
│   ├── PythonAI/                           # Python AI Powerhouse
│   │   ├── ai_powerhouse/                  # Core Python package
│   │   ├── .venv/                          # Virtual environment
│   │   ├── main.py                         # Main entry point
│   │   ├── cli.py                          # CLI interface
│   │   └── requirements.txt                # Dependencies
│   │
│   └── ClaudeAgents/                       # Complete Claude Agents system
│       ├── Install-ClaudeAgents.ps1        # Agent installer
│       ├── Validate-ClaudeAgents.ps1       # Validation script
│       ├── PowerShellModule/               # ClaudeAgents module
│       ├── AgentPrompts/                   # Agent prompt files
│       └── Documentation/                  # Agent documentation
│
├── Integration/                            # Cross-system bridges
│   ├── unified_ai_bridge.py               # Python-PowerShell bridge
│   └── AIPowerhouse.psm1                  # PowerShell-Python bridge
│
├── VSCodeConfig/                           # VS Code integration
│   ├── tasks.json                         # Global tasks
│   ├── keybindings.json                   # Keyboard shortcuts
│   └── snippets/                          # Code snippets
│
├── Examples/                               # Usage examples
│   ├── PythonExamples/                     # Python AI examples
│   └── PowerShellExamples/                # Agent examples
│
└── Documentation/                          # Complete documentation
    ├── README.md                           # This file
    ├── API-Reference.md                    # API documentation
    └── Troubleshooting.md                  # Common issues
```

---

## 🔧 Configuration

### Environment Variables

Create `.env` file in the Python AI directory:

```bash
# Anthropic Claude
ANTHROPIC_API_KEY=your_claude_api_key

# Google Gemini
GOOGLE_API_KEY=your_gemini_api_key

# OpenAI
OPENAI_API_KEY=your_openai_api_key

# Optional: Custom endpoints
CLAUDE_ENDPOINT=https://api.anthropic.com
GEMINI_ENDPOINT=https://generativelanguage.googleapis.com
```

### PowerShell Profile Enhancement

The installer automatically adds to your PowerShell profile:

```powershell
# AI Powerhouse Framework shortcuts
function ai { ai-claude $args }              # Default to Claude
function ai-quick { ai-all $args }           # Ask all providers  
function ai-file { ai-analyze $args }        # Analyze file

# Specialized agent shortcuts
function sec { security-review $args }       # Security
function test { generate-tests $args }       # Testing
function doc { generate-docs $args }         # Documentation
# ... (complete list in profile)
```

---

## 🧪 Testing and Validation

### Built-in Validation

```powershell
# Test Python AI components
python .\Core\PythonAI\integration\unified_ai_bridge.py capabilities

# Test Claude Agents
agent-help

# Test cross-system integration
ai-caps

# Full system validation
.\Core\ClaudeAgents\Validate-ClaudeAgents.ps1
```

### Health Checks

```powershell
# Check AI provider connectivity
ai-claude "test"
ai-gemini "test"  
ai-openai "test"

# Verify all agents respond
security-review "test security analysis"
generate-tests "test function"
electronics-design "test circuit"
```

---

## 🚨 Troubleshooting

### Common Issues

**"Module not found" errors:**
```powershell
# Reload modules
Import-Module ClaudeAgents -Force
Import-Module AIPowerhouse -Force

# Check module paths
$env:PSModulePath -split ';'
```

**Python AI connectivity issues:**
```powershell
# Check Python environment
& ".\Core\PythonAI\.venv\Scripts\python.exe" --version

# Verify API keys
& ".\Core\PythonAI\.venv\Scripts\python.exe" -c "import os; print('ANTHROPIC_API_KEY' in os.environ)"
```

**VS Code shortcuts not working:**
1. Restart VS Code after installation
2. Check if keybindings.json was merged correctly
3. Use `Ctrl+Shift+P` → "Tasks: Run Task" as alternative

### Log Files

- Installation log: `$env:TEMP\AIPowerhouse-Install.log`
- Agent interactions: `%USERPROFILE%\.claude-agents\logs\agent-interactions.log`
- Python errors: Check console output or VS Code terminal

---

## 📈 Performance Tips

### Optimize Response Times
- Use specific, focused prompts
- Choose the right AI provider for the task
- Cache frequently used responses locally

### Efficient Workflows
- Use shortcuts (`sec`, `test`, `doc`) for common tasks
- Combine agents with `agent-pipeline` for comprehensive analysis
- Set up project-specific prompt templates

### Resource Management
- Python virtual environment is isolated per installation
- PowerShell agents share prompts efficiently  
- VS Code integration doesn't impact editor performance

---

## 🔄 Updates and Maintenance

### Updating the Framework

1. Download new framework package
2. Run installer (will upgrade existing installation)
3. Restart PowerShell and VS Code
4. Verify with validation scripts

### Adding Custom Agents

1. Create new agent prompt file in `%USERPROFILE%\.claude-agents\agents\`
2. Add function to ClaudeAgents module
3. Update VS Code tasks and shortcuts
4. Test with validation script

### Backup Important Data

- Agent prompts: `%USERPROFILE%\.claude-agents\`
- PowerShell profile: `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
- VS Code settings: `%APPDATA%\Code\User\` (auto-backed up by installer)

---

## 🎯 Best Practices

### Security
- Review AI responses before implementing
- Don't share sensitive code without approval
- Use local analysis when possible
- Rotate API keys regularly

### Team Collaboration
- Share custom agent prompts via version control
- Document project-specific AI workflows
- Use consistent naming for team prompts
- Create project-specific integration scripts

### Development Workflow
- Use AI for analysis, not blind implementation
- Combine multiple perspectives (AI + agents)
- Validate AI suggestions with testing agents
- Document AI-assisted decisions

---

## 📞 Support and Community

### Getting Help
- Check this documentation first
- Run validation scripts for diagnostics
- Review log files for error details
- Use built-in help: `ai-help`, `agent-help`

### Contributing
1. Fork the framework repository
2. Create improvements or new agents
3. Test with validation scripts
4. Submit pull requests with documentation

### Resources
- GitHub Repository: [AI-Powerhouse-Framework]
- Documentation: This README and `/Documentation/`
- Examples: `/Examples/` directory
- Community: GitHub Discussions

---

## 📄 License and Credits

**AI Powerhouse Framework v2.0**
*Complete Developer AI Environment*

Copyright (c) 2024 AI Powerhouse Team

This framework enhances development productivity by integrating multiple AI systems while maintaining developer control, security, and code quality standards.

**Components:**
- Python AI Powerhouse (Multi-provider integration)
- Claude Agents System (Specialized development agents)
- Cross-system integration layer
- VS Code global enhancements
- Unified installation and management

Transform your development workflow with the power of specialized AI assistance!