# AI Powerhouse Project Template
# This template automatically includes AI Powerhouse framework in new projects

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("Python", "PowerShell", "JavaScript", "Mixed")]
    [string]$ProjectType = "Mixed",
    
    [Parameter(Mandatory = $false)]
    [string[]]$Agents = @("security", "testing", "documentation", "performance", "code-review"),
    
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = (Get-Location)
)

$AIPowerhousePath = "c:\Users\woody\OneDrive\Documents\ai powerhouse"

Write-Host "🚀 Creating AI-Powered Project: $ProjectName" -ForegroundColor Cyan
Write-Host "   Type: $ProjectType" -ForegroundColor Gray
Write-Host "   Path: $ProjectPath" -ForegroundColor Gray
Write-Host ""

# Create project directory
$fullProjectPath = Join-Path $ProjectPath $ProjectName
New-Item -ItemType Directory -Path $fullProjectPath -Force | Out-Null
Set-Location $fullProjectPath

Write-Host "📁 Setting up project structure..." -ForegroundColor Yellow

# Create standard directories
$directories = @(
    "src",
    "tests", 
    "docs",
    "ai_integration",
    "ai_integration\agents",
    "ai_integration\config",
    ".vscode"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# Copy AI Powerhouse core
Write-Host "🤖 Integrating AI Powerhouse..." -ForegroundColor Yellow

$sourceAI = Join-Path $AIPowerhousePath "ai_powerhouse"
$targetAI = Join-Path $fullProjectPath "ai_integration\ai_powerhouse"

if (Test-Path $sourceAI) {
    Copy-Item -Path $sourceAI -Destination $targetAI -Recurse -Force
    Write-Host "✅ AI Powerhouse core integrated" -ForegroundColor Green
}

# Copy environment template
$sourceEnv = Join-Path $AIPowerhousePath ".env.example"
$targetEnv = Join-Path $fullProjectPath ".env.example"

if (Test-Path $sourceEnv) {
    Copy-Item -Path $sourceEnv -Destination $targetEnv -Force
    Write-Host "✅ Environment template copied" -ForegroundColor Green
}

# Add Claude Agents
Write-Host "🧠 Adding Claude Agents..." -ForegroundColor Yellow

$sourceAgents = Join-Path $AIPowerhousePath "ClaudeAgents-Installer\AgentPrompts"
$targetAgentsDir = Join-Path $fullProjectPath "ai_integration\agents"

foreach ($agent in $Agents) {
    $sourceFile = Join-Path $sourceAgents "$agent-agent.txt"
    $targetFile = Join-Path $targetAgentsDir "$agent-agent.txt"
    
    if (Test-Path $sourceFile) {
        Copy-Item -Path $sourceFile -Destination $targetFile -Force
        Write-Host "  ✅ $agent agent" -ForegroundColor Green
    }
}

# Create VS Code configuration
Write-Host "⚙️ Setting up VS Code integration..." -ForegroundColor Yellow

$vscodeTasksContent = @"
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "AI: Setup Environment",
            "type": "shell",
            "command": "python",
            "args": ["setup_ai.py"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "AI: Security Review",
            "type": "shell",
            "command": "pwsh",
            "args": ["-Command", "security-review `${file}"],
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always"
            }
        },
        {
            "label": "AI: Generate Tests", 
            "type": "shell",
            "command": "pwsh",
            "args": ["-Command", "generate-tests `${file}"],
            "group": "test"
        },
        {
            "label": "AI: Code Review",
            "type": "shell", 
            "command": "pwsh",
            "args": ["-Command", "code-review `${file}"],
            "group": "test"
        },
        {
            "label": "AI: Performance Analysis",
            "type": "shell",
            "command": "pwsh", 
            "args": ["-Command", "analyze-performance `${file}"],
            "group": "test"
        }
    ]
}
"@

$vscodeTasksContent | Out-File -FilePath (Join-Path $fullProjectPath ".vscode\tasks.json") -Encoding UTF8

$vscodeKeybindingsContent = @"
[
    {
        "key": "ctrl+alt+a ctrl+alt+h",
        "command": "workbench.action.tasks.runTask",
        "args": "AI: Security Review"
    },
    {
        "key": "ctrl+alt+a ctrl+alt+t", 
        "command": "workbench.action.tasks.runTask",
        "args": "AI: Generate Tests"
    },
    {
        "key": "ctrl+alt+a ctrl+alt+r",
        "command": "workbench.action.tasks.runTask", 
        "args": "AI: Code Review"
    },
    {
        "key": "ctrl+alt+a ctrl+alt+p",
        "command": "workbench.action.tasks.runTask",
        "args": "AI: Performance Analysis"
    }
]
"@

$vscodeKeybindingsContent | Out-File -FilePath (Join-Path $fullProjectPath ".vscode\keybindings.json") -Encoding UTF8

# Create project-specific AI setup script
$setupScript = @"
#!/usr/bin/env python3
"""
AI Powerhouse Setup for $ProjectName
Initializes AI integration and validates configuration
"""

import os
import sys
from pathlib import Path

# Add AI integration to Python path
project_root = Path(__file__).parent
ai_integration_path = project_root / "ai_integration"
sys.path.insert(0, str(ai_integration_path))

def setup_ai_powerhouse():
    """Initialize AI Powerhouse for this project"""
    print("🤖 Setting up AI Powerhouse for $ProjectName...")
    
    try:
        from ai_powerhouse import AIPowerhouse
        
        # Check for .env file
        env_file = project_root / ".env"
        if not env_file.exists():
            print("⚠️  .env file not found")
            print("   1. Copy .env.example to .env")
            print("   2. Add your API keys to .env")
            print("   3. Run this script again")
            return False
            
        # Initialize AI Powerhouse
        ai = AIPowerhouse()
        print("✅ AI Powerhouse initialized successfully")
        
        # Test basic functionality
        print("🧪 Testing AI connectivity...")
        
        # List available providers
        providers = ai.get_available_providers()
        print(f"📡 Available providers: {', '.join(providers)}")
        
        return True
        
    except ImportError as e:
        print(f"❌ Failed to import AI Powerhouse: {e}")
        return False
    except Exception as e:
        print(f"⚠️  Setup issue: {e}")
        return False

def setup_claude_agents():
    """Setup Claude Agents for this project"""
    print("\n🧠 Setting up Claude Agents...")
    
    agents_dir = ai_integration_path / "agents"
    if not agents_dir.exists():
        print("❌ Agents directory not found")
        return False
        
    agent_files = list(agents_dir.glob("*-agent.txt"))
    if agent_files:
        print(f"✅ Found {len(agent_files)} specialized agents:")
        for agent_file in agent_files:
            agent_name = agent_file.stem.replace("-agent", "")
            print(f"   • {agent_name.title()} Agent")
        return True
    else:
        print("⚠️  No agent files found")
        return False

def show_usage_examples():
    """Show usage examples for this project"""
    print("\n📖 Usage Examples:")
    print("""
# Python AI Integration:
from ai_integration.ai_powerhouse import AIPowerhouse

ai = AIPowerhouse()
response = ai.ask("Help me with this code problem")

# PowerShell Agent Commands:
security-review ./src/main.py
generate-tests ./src/utils.py  
code-review ./src/api.py

# VS Code Integration:
# Press Ctrl+Alt+A then Ctrl+Alt+H for security review
# Press Ctrl+Alt+A then Ctrl+Alt+T for test generation
# Use Command Palette: "Tasks: Run Task" for AI operations
    """)

if __name__ == "__main__":
    print(f"🚀 AI Powerhouse Setup for $ProjectName")
    print("=" * 50)
    
    # Setup AI Powerhouse core
    ai_success = setup_ai_powerhouse()
    
    # Setup Claude Agents
    agents_success = setup_claude_agents()
    
    if ai_success and agents_success:
        print("\n🎉 AI integration setup complete!")
        show_usage_examples()
    else:
        print("\n⚠️  Setup completed with issues. Check the messages above.")
"@

$setupScript | Out-File -FilePath (Join-Path $fullProjectPath "setup_ai.py") -Encoding UTF8

# Create README with AI integration info
$readmeContent = @"
# $ProjectName

A $ProjectType project powered by AI Powerhouse Framework.

## 🤖 AI Integration

This project includes comprehensive AI assistance through:

- **Multi-Provider AI**: Access to Claude, Gemini, and OpenAI
- **Specialized Agents**: $($Agents.Count) Claude agents for specific tasks
- **VS Code Integration**: AI-powered keyboard shortcuts and tasks
- **Cross-System Support**: Python ↔ PowerShell integration

### Quick Start

1. **Setup Environment**:
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Add your API keys to .env file
   # Run AI setup
   python setup_ai.py
   ```

2. **Available AI Commands**:
   ```powershell
   # Security analysis
   security-review ./src/main.py
   
   # Generate tests
   generate-tests ./src/utils.py
   
   # Code review
   code-review ./src/api.py
   
   # Performance analysis
   analyze-performance ./src/slow_function.py
   ```

3. **VS Code Integration**:
   - `Ctrl+Alt+A, Ctrl+Alt+H` - Security Review
   - `Ctrl+Alt+A, Ctrl+Alt+T` - Generate Tests  
   - `Ctrl+Alt+A, Ctrl+Alt+R` - Code Review
   - `Ctrl+Alt+A, Ctrl+Alt+P` - Performance Analysis

### Python AI Usage

```python
from ai_integration.ai_powerhouse import AIPowerhouse

# Initialize AI
ai = AIPowerhouse()

# Get help from all providers
response = ai.ask("How can I optimize this function?")

# Use specific provider
claude_response = ai.ask_claude("Review this code for security issues")
```

### Included Agents

$($Agents | ForEach-Object { "- **" + ($_ -replace '-', ' ' | ForEach-Object {(Get-Culture).TextInfo.ToTitleCase($_)}) + " Agent**" }) -join "`n"

## Project Structure

```
$ProjectName/
├── src/                    # Source code
├── tests/                  # Test files
├── docs/                   # Documentation
├── ai_integration/         # AI Powerhouse integration
│   ├── ai_powerhouse/     # Core AI functionality
│   ├── agents/            # Claude Agent prompts
│   └── config/            # AI configuration
├── .vscode/               # VS Code AI configuration
├── setup_ai.py           # AI environment setup
├── .env.example           # API key template
└── README.md              # This file
```

## Development Workflow

1. **Write Code**: Develop in `src/` directory
2. **AI Review**: Use `code-review filename` for instant feedback
3. **Generate Tests**: Use `generate-tests filename` for comprehensive testing
4. **Security Check**: Use `security-review filename` for vulnerability analysis
5. **Optimize**: Use `analyze-performance filename` for performance improvements

The AI Powerhouse framework provides continuous assistance throughout development!
"@

$readmeContent | Out-File -FilePath (Join-Path $fullProjectPath "README.md") -Encoding UTF8

# Create .gitignore with AI-specific entries
$gitignoreContent = @"
# Dependencies
node_modules/
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/settings.json
.vscode/launch.json
*.swp
*.swo
*~

# AI Powerhouse specific
ai_integration/logs/
ai_integration/cache/
ai_integration/temp/

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity
"@

$gitignoreContent | Out-File -FilePath (Join-Path $fullProjectPath ".gitignore") -Encoding UTF8

Write-Host ""
Write-Host "🎉 AI-Powered Project Created Successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Project: $ProjectName" -ForegroundColor Cyan
Write-Host "📍 Location: $fullProjectPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "   1. cd '$ProjectName'" -ForegroundColor White
Write-Host "   2. Copy .env.example to .env and add API keys" -ForegroundColor White
Write-Host "   3. python setup_ai.py" -ForegroundColor White
Write-Host "   4. Open in VS Code for full AI integration" -ForegroundColor White
Write-Host ""
Write-Host "🤖 Available AI Commands:" -ForegroundColor Yellow
$Agents | ForEach-Object {
    $agentName = $_ -replace '-', ' ' | ForEach-Object {(Get-Culture).TextInfo.ToTitleCase($_)}
    Write-Host "   $_ -> $agentName Agent" -ForegroundColor White
}
Write-Host ""