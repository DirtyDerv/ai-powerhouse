# AI Powerhouse - Global VS Code Setup

Complete reference for AI-powered development with Claude Code, Gemini CLI, and OpenAI CLI.

## 🚀 Quick Start

After running the setup script, restart VS Code and you'll have access to:

- **Global keyboard shortcuts** for AI tasks
- **PowerShell functions** in any terminal
- **Code snippets** in all languages
- **VS Code tasks** available in any project
- **Automated logging** of all AI interactions

## ⌨️ Keyboard Shortcuts

| Shortcut | Action | Context |
|----------|--------|---------|
| `Ctrl+Shift+C` | Claude Code: Execute Prompt | Any file |
| `Ctrl+Shift+Alt+C` | Claude Code: Fix Current File | Active file |
| `Ctrl+Shift+G` | Gemini CLI: Custom Prompt | Any file |
| `Ctrl+Shift+Alt+G` | Gemini CLI: Analyze Current File | Active file |
| `Ctrl+Shift+O` | OpenAI: Generate Code | Any file |
| `Ctrl+Shift+Alt+O` | OpenAI: Generate Tests | Active file |
| `Ctrl+Shift+A` | AI Compare: All Three Models | Any file |
| `Ctrl+Shift+Alt+A` | AI Pipeline: Implement & Review | Any file |
| `Ctrl+Shift+Alt+F` | AI Pipeline: Full Analysis | Active file |
| `Ctrl+Shift+Alt+S` | AI Tools: Status Check | Any file |
| `Ctrl+Shift+Alt+L` | AI Logs: Open Directory | Any file |
| `Ctrl+Shift+Alt+M` | AI Quick Pick Menu | Any file |
| `Ctrl+Shift+Alt+D` | Gemini CLI: Generate Documentation | Active file |
| `Ctrl+Shift+Alt+R` | Claude Code: Refactor Current File | Active file |
| `F1` | AI Quick Pick Menu | Any file |

## 🔧 PowerShell Functions

### Basic AI Commands

```powershell
# Quick AI interactions
claude "Write a Python function to calculate fibonacci"
gemini "Explain async/await in JavaScript"
gpt "Generate unit tests for this function"

# Compare all three AI models
ai-compare "What are the best practices for error handling?"

# Analyze a specific file
claude "Review this code for bugs" -File "C:\path\to\file.js"
gemini "Suggest performance improvements" -File "C:\path\to\file.py"
```

### Advanced Workflows

```powershell
# Implementation pipeline (Claude → Gemini review)
ai-implement "Create a REST API endpoint for user authentication"

# Code review with all three models
ai-review "C:\path\to\myfile.js"

# Full pipeline (implement → review → optimize)
ai-pipeline "Build a caching layer for database queries"

# Quick helpers for current file workflow
ai-fix         # Fix bugs in current file
ai-document    # Generate documentation
ai-test        # Generate unit tests
ai-refactor    # Get refactoring suggestions
```

### Logging and History

```powershell
# View recent AI activity
ai-log              # Show recent activity from all tools
ai-log claude -Last 5   # Show last 5 Claude interactions
ai-log gemini -Last 10  # Show last 10 Gemini interactions

# View usage statistics
ai-history          # Last 7 days
ai-history 30       # Last 30 days

# Open logs directory
logs                # Opens file explorer to ~/.ai-logs

# Check AI tools status
ai-status           # Verify all AI tools are working
```

### Utility Functions

```powershell
# Clean up old logs
Clear-AILogsOld 30  # Remove logs older than 30 days

# Open AI logs in VS Code
code "$env:USERPROFILE\.ai-logs"

# Get information about current VS Code session
Get-CurrentFile     # Get path of active file (if supported)
```

## 📋 VS Code Tasks

All tasks are available via `Ctrl+Shift+P` → "Tasks: Run Task":

### Claude Code Tasks
- **Claude Code: Execute Prompt** - Custom prompt input
- **Claude Code: Fix Current File** - Bug fixing for active file
- **Claude Code: Refactor Current File** - Code refactoring

### Gemini CLI Tasks
- **Gemini CLI: Custom Prompt** - Custom prompt input
- **Gemini CLI: Analyze Current File** - Security and quality analysis
- **Gemini CLI: Generate Documentation** - Documentation generation

### OpenAI Tasks
- **OpenAI: Generate Code** - Code generation with custom prompt
- **OpenAI: Generate Tests** - Unit test generation for active file

### Multi-AI Tasks
- **AI Compare: All Three Models** - Run same prompt on all models
- **AI Pipeline: Implement & Review** - Claude implements, Gemini reviews
- **AI Pipeline: Full Analysis** - All three models analyze current file

### Utility Tasks
- **AI Tools: Status Check** - Verify all CLI tools are working
- **AI Logs: Open Directory** - Open logs in Windows Explorer
- **AI Quick Pick Menu** - Interactive menu of all AI tasks

## 🎯 Code Snippets

Type these prefixes in any file and press Tab to expand:

### Universal Snippets (work in all files)
- `aicc` → Claude Code task marker
- `aigemini` → Gemini analysis marker  
- `aigpt` → OpenAI task marker
- `aitodo` → AI TODO with tool selection dropdown
- `aireview` → Code review request template
- `aidoc` → Documentation request template
- `aitest` → Test generation request template
- `aifix` → Bug fix request template
- `aicompare` → Multi-AI comparison request
- `aipipeline` → Implementation pipeline template
- `aips` → Quick PowerShell AI command
- `ailog` → AI log analysis commands

### Language-Specific Snippets

#### JavaScript/TypeScript
- `aidocfn` → Function with AI documentation request
- `aidocclass` → Class with AI documentation request
- `aitestjs` → Jest/Mocha test suite template
- `aiasync` → Async function with optimization request
- `aireact` → React component with analysis request
- `aiapi` → API function with optimization request
- `aiperf` → Performance benchmark template

#### Python
- `aidocpy` → Function with comprehensive docstring
- `aiclass` → Class with AI documentation request
- `aitestpy` → Unittest test class template
- `aiasyncpy` → Async function with best practices
- `aidatapy` → Data analysis function template
- `aimlpy` → Machine learning model class
- `aiapi` → FastAPI endpoint template

## 🎨 Best Practices

### Which AI Tool for Which Task?

| Task Type | Recommended Tool | Why |
|-----------|------------------|-----|
| **Code Implementation** | Claude Code | Excellent at writing clean, well-structured code |
| **Code Review & Security** | Gemini CLI | Strong at finding security issues and code quality |
| **Testing & Optimization** | OpenAI | Great at generating comprehensive tests |
| **Documentation** | Gemini CLI | Produces clear, detailed documentation |
| **Bug Fixing** | Claude Code | Good at understanding context and fixing issues |
| **Refactoring** | All three (compare) | Get multiple perspectives on improvements |
| **Learning & Explanation** | All three (compare) | Different AI models explain differently |

### Effective AI Prompts

#### ✅ Good Prompts
```
"Review this React component for performance issues and accessibility problems"
"Generate unit tests for this function including edge cases and error conditions"
"Refactor this code to follow SOLID principles and improve maintainability"
"Explain how this async function works and suggest improvements"
```

#### ❌ Poor Prompts
```
"Fix this"                    # Too vague
"Make it better"              # No specific goals
"Add comments"                # Too simple, doesn't leverage AI capabilities
```

### Workflow Recommendations

#### 1. **New Feature Development**
```powershell
# Step 1: Plan with AI
ai-compare "How should I implement user authentication with JWT tokens?"

# Step 2: Implement 
claude "Implement JWT authentication middleware for Express.js"

# Step 3: Review
gemini "Review this JWT implementation for security vulnerabilities" -File auth.js

# Step 4: Test
gpt "Generate comprehensive tests for this authentication system" -File auth.js
```

#### 2. **Code Review Process**
```powershell
# Full analysis of a file
ai-review "path/to/file.js"

# Or use the pipeline for new implementations
ai-pipeline "Create a password validation function with strength checking"
```

#### 3. **Debugging Workflow**
```powershell
# Quick fix for current file
ai-fix

# Or detailed bug analysis
claude "Analyze this code for potential bugs and memory leaks" -File buggy-file.js
```

## 🗂️ File Organization

### Log Structure
```
%USERPROFILE%\.ai-logs\
├── claude\           # Claude Code logs
├── gemini\           # Gemini CLI logs  
├── openai\           # OpenAI logs
├── comparisons\      # Multi-AI comparison logs
├── errors\           # Error logs
└── setup.log         # Setup information
```

### VS Code Settings Location
```
%APPDATA%\Code\User\
├── tasks.json        # Global tasks
├── keybindings.json  # Global shortcuts
├── settings.json     # User settings (merge required)
└── snippets\         # Code snippets
    ├── global.code-snippets
    ├── javascript.json
    ├── typescript.json
    ├── python.json
    └── csharp.json
```

### PowerShell Module Location
```
%USERPROFILE%\Documents\PowerShell\
├── Microsoft.VSCode_profile.ps1    # VS Code profile
├── Setup-AIEnvironment.ps1         # Setup script
└── Modules\
    └── AIHelpers\
        ├── AIHelpers.psm1           # Main module
        ├── AIHelpers.psd1           # Module manifest
        └── Functions\               # Individual functions
```

## 🔧 Troubleshooting

### Common Issues

#### AI Tools Not Found
```powershell
# Check if tools are installed and in PATH
ai-status

# Verify individual tools
Get-Command claude-code
Get-Command gemini-cli  
Get-Command openai
```

#### PowerShell Functions Not Available
```powershell
# Check if module is loaded
Get-Module AIHelpers

# Manually import module
Import-Module AIHelpers -Force

# Check profile is loading
Test-Path $PROFILE
```

#### Keyboard Shortcuts Not Working
1. Check VS Code keybindings: `Ctrl+K Ctrl+S`
2. Verify `keybindings.json` is in correct location: `%APPDATA%\Code\User\`
3. Restart VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"

#### Tasks Not Appearing
1. Verify `tasks.json` location: `%APPDATA%\Code\User\tasks.json`
2. Check JSON syntax is valid
3. Restart VS Code
4. Try `Ctrl+Shift+P` → "Tasks: Run Task"

#### Logging Not Working
```powershell
# Check log directory exists
Test-Path "$env:USERPROFILE\.ai-logs"

# Check permissions
New-Item "$env:USERPROFILE\.ai-logs\test.txt" -ItemType File

# View recent logs
Get-ChildItem "$env:USERPROFILE\.ai-logs" -Recurse
```

### Performance Issues

#### Slow AI Responses
- Check internet connection
- Verify API keys are valid
- Try different AI tools to isolate issues

#### High Memory Usage
```powershell
# Clean old logs
Clear-AILogsOld 7  # Keep only last 7 days

# Check log file sizes
Get-ChildItem "$env:USERPROFILE\.ai-logs" -Recurse | Measure-Object -Property Length -Sum
```

## 📚 Advanced Usage

### Custom AI Workflows

You can create custom PowerShell functions in your profile:

```powershell
# Add to Microsoft.VSCode_profile.ps1

function ai-webapp {
    param([string]$Description)
    
    Write-Host "🚀 Full Stack Web App Pipeline" -ForegroundColor Magenta
    
    # Architecture
    $architecture = claude "Design architecture for: $Description. Include frontend, backend, database, and deployment considerations."
    
    # Frontend
    $frontend = gpt "Generate React components for: $Description. Based on this architecture: $architecture"
    
    # Backend  
    $backend = claude "Create Node.js/Express API for: $Description. Based on this architecture: $architecture"
    
    # Review
    $review = gemini "Review this full stack implementation for security, performance, and best practices. Frontend: $frontend Backend: $backend"
    
    return @{
        Architecture = $architecture
        Frontend = $frontend
        Backend = $backend
        Review = $review
    }
}
```

### Automated Code Quality Pipeline

```powershell
function ai-quality-check {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    
    Write-Host "🔍 Running AI Quality Pipeline" -ForegroundColor Cyan
    
    # Security scan
    $security = gemini "Perform security analysis on this code. Look for vulnerabilities, injection risks, and security best practices." -File $FilePath
    
    # Performance analysis
    $performance = claude "Analyze this code for performance bottlenecks and optimization opportunities." -File $FilePath
    
    # Code quality
    $quality = gpt "Review this code for maintainability, readability, and adherence to best practices." -File $FilePath
    
    # Generate report
    $report = @"
# AI Quality Report for $FilePath
Generated: $(Get-Date)

## Security Analysis (Gemini)
$security

## Performance Analysis (Claude)  
$performance

## Code Quality Review (OpenAI)
$quality
"@
    
    $reportPath = "$env:USERPROFILE\.ai-logs\quality-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
    $report | Out-File $reportPath -Encoding UTF8
    
    Write-Host "📄 Quality report saved: $reportPath" -ForegroundColor Green
    code $reportPath
}
```

## 🔄 Updates and Maintenance

### Updating the Setup

To update your AI setup:

1. **Re-run the setup script:**
   ```powershell
   & "$env:USERPROFILE\Documents\PowerShell\Setup-AIEnvironment.ps1"
   ```

2. **Update PowerShell module:**
   ```powershell
   Import-Module AIHelpers -Force
   ```

3. **Reload VS Code:**
   `Ctrl+Shift+P` → "Developer: Reload Window"

### Backup Your Configuration

```powershell
# Backup VS Code settings
$backupPath = "$env:USERPROFILE\Documents\AI-Backup-$(Get-Date -Format 'yyyyMMdd')"
New-Item $backupPath -ItemType Directory -Force

Copy-Item "$env:APPDATA\Code\User\tasks.json" $backupPath
Copy-Item "$env:APPDATA\Code\User\keybindings.json" $backupPath
Copy-Item "$env:APPDATA\Code\User\snippets" $backupPath -Recurse

Write-Host "✅ Backup created: $backupPath" -ForegroundColor Green
```

## 📞 Support

### Getting Help

1. **Check AI tool status:** `ai-status`
2. **View recent logs:** `ai-log`
3. **Test individual tools:**
   ```powershell
   claude "test"
   gemini "test"  
   gpt "test"
   ```

### Useful Resources

- **PowerShell Module Help:** `Get-Help claude`
- **VS Code Tasks:** `Ctrl+Shift+P` → "Tasks: Configure Task"
- **Keyboard Shortcuts:** `Ctrl+K Ctrl+S`
- **AI Logs:** `logs` (opens file explorer)

---

## 🎉 You're All Set!

Your VS Code is now supercharged with AI capabilities! Start with simple commands like `claude "hello"` or press `Ctrl+Shift+C` to begin using your new AI-powered development environment.

Happy coding with AI! 🤖✨
