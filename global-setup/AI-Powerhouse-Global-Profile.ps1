# AI Powerhouse Global PowerShell Profile
# This profile automatically loads AI Powerhouse framework for all PowerShell sessions

# AI Powerhouse Framework Path
$AIPowerhousePath = "c:\Users\woody\OneDrive\Documents\ai powerhouse"
$ClaudeAgentsPath = Join-Path $AIPowerhousePath "ClaudeAgents-Installer\PowerShellModule\ClaudeAgents.psm1"
$AIPowerhouseModulePath = Join-Path $AIPowerhousePath "AI-Powerhouse-Framework\Integration\AIPowerhouse.psm1"

Write-Host "🤖 Loading AI Powerhouse Framework..." -ForegroundColor Cyan

# Load Claude Agents Module
if (Test-Path $ClaudeAgentsPath) {
    try {
        Import-Module $ClaudeAgentsPath -Force -DisableNameChecking
        Write-Host "✅ Claude Agents loaded (12 specialized agents)" -ForegroundColor Green
    } catch {
        Write-Warning "❌ Failed to load Claude Agents: $_"
    }
} else {
    Write-Warning "⚠️ Claude Agents module not found at: $ClaudeAgentsPath"
}

# Load AI Powerhouse Cross-System Module
if (Test-Path $AIPowerhouseModulePath) {
    try {
        Import-Module $AIPowerhouseModulePath -Force -DisableNameChecking
        Write-Host "✅ AI Powerhouse cross-system bridge loaded" -ForegroundColor Green
    } catch {
        Write-Warning "❌ Failed to load AI Powerhouse module: $_"
    }
} else {
    Write-Warning "⚠️ AI Powerhouse module not found at: $AIPowerhouseModulePath"
}

# Global AI Helper Functions
function ai-help-global {
    <#
    .SYNOPSIS
    Display global AI Powerhouse help and available commands
    #>
    Write-Host ""
    Write-Host "🚀 AI Powerhouse Framework - Global Commands" -ForegroundColor Cyan
    Write-Host ("="*60) -ForegroundColor DarkGray
    Write-Host ""
    
    Write-Host "Multi-Provider AI:" -ForegroundColor Yellow
    Write-Host "  ask-ai '<prompt>'          - Query all AI providers" -ForegroundColor White
    Write-Host "  ask-claude '<prompt>'      - Query Claude specifically" -ForegroundColor White
    Write-Host "  ask-gemini '<prompt>'      - Query Gemini specifically" -ForegroundColor White
    Write-Host "  ask-openai '<prompt>'      - Query OpenAI specifically" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Claude Agents (12 specialists):" -ForegroundColor Yellow
    Write-Host "  security-review <file>     - Security vulnerability analysis" -ForegroundColor White
    Write-Host "  generate-tests <file>      - Comprehensive test generation" -ForegroundColor White
    Write-Host "  generate-docs <file>       - Documentation generation" -ForegroundColor White
    Write-Host "  analyze-performance <file> - Performance optimization" -ForegroundColor White
    Write-Host "  code-review <file>         - Code quality review" -ForegroundColor White
    Write-Host "  debug-issue <file>         - Bug analysis and debugging" -ForegroundColor White
    Write-Host "  design-architecture '<p>'  - System architecture design" -ForegroundColor White
    Write-Host "  refactor-code <file>       - Code refactoring suggestions" -ForegroundColor White
    Write-Host "  electronics-design '<p>'   - Circuit design & PCB layout" -ForegroundColor White
    Write-Host "  database-optimize '<q>'    - Database design & SQL optimization" -ForegroundColor White
    Write-Host "  research-topic '<topic>'   - Comprehensive research & analysis" -ForegroundColor White
    Write-Host "  n8n-workflow '<desc>'      - N8N automation workflows" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Project Integration:" -ForegroundColor Yellow
    Write-Host "  setup-ai-project           - Initialize AI Powerhouse in current directory" -ForegroundColor White
    Write-Host "  add-ai-agents              - Add Claude Agents to project" -ForegroundColor White
    Write-Host "  configure-ai-vscode        - Set up VS Code AI integration" -ForegroundColor White
    Write-Host ""
    
    Write-Host "For detailed help: Get-Help <command> -Detailed" -ForegroundColor Gray
    Write-Host ""
}

function setup-ai-project {
    <#
    .SYNOPSIS
    Initialize AI Powerhouse framework in the current directory
    #>
    [CmdletBinding()]
    param(
        [string]$ProjectName = (Split-Path -Leaf (Get-Location))
    )
    
    Write-Host "🚀 Setting up AI Powerhouse for project: $ProjectName" -ForegroundColor Cyan
    
    $currentDir = Get-Location
    
    # Create AI integration directory structure
    $aiDir = Join-Path $currentDir "ai_integration"
    $agentsDir = Join-Path $aiDir "agents"
    $configDir = Join-Path $aiDir "config"
    
    Write-Host "📁 Creating directory structure..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $aiDir -Force | Out-Null
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    
    # Copy core AI Powerhouse files
    Write-Host "📋 Copying AI Powerhouse core..." -ForegroundColor Yellow
    $sourceAI = Join-Path $AIPowerhousePath "ai_powerhouse"
    $targetAI = Join-Path $aiDir "ai_powerhouse"
    
    if (Test-Path $sourceAI) {
        Copy-Item -Path $sourceAI -Destination $targetAI -Recurse -Force
        Write-Host "✅ AI Powerhouse core copied" -ForegroundColor Green
    }
    
    # Copy .env.example
    $sourceEnv = Join-Path $AIPowerhousePath ".env.example"
    $targetEnv = Join-Path $currentDir ".env.example"
    
    if (Test-Path $sourceEnv) {
        Copy-Item -Path $sourceEnv -Destination $targetEnv -Force
        Write-Host "✅ .env.example copied" -ForegroundColor Green
    }
    
    # Create basic setup script
    $setupScript = @"
# AI Powerhouse Setup for $ProjectName
import os
import sys

# Add AI integration to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'ai_integration'))

try:
    from ai_powerhouse import AIPowerhouse
    
    # Initialize AI Powerhouse
    ai = AIPowerhouse()
    print("✅ AI Powerhouse initialized successfully")
    
    # Test connection (requires .env file with API keys)
    # response = ai.ask("Hello, test connection")
    # print(f"Test response: {response}")
    
except ImportError:
    print("❌ AI Powerhouse not found. Run setup-ai-project first.")
except Exception as e:
    print(f"⚠️ AI Powerhouse setup issue: {e}")
"@
    
    $setupScript | Out-File -FilePath (Join-Path $currentDir "setup_ai.py") -Encoding UTF8
    
    Write-Host "✅ Project initialized with AI Powerhouse" -ForegroundColor Green
    Write-Host "📝 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Copy .env.example to .env and add your API keys" -ForegroundColor White
    Write-Host "   2. Run: python setup_ai.py" -ForegroundColor White
    Write-Host "   3. Use: add-ai-agents to include specialized agents" -ForegroundColor White
}

function add-ai-agents {
    <#
    .SYNOPSIS
    Add Claude Agents to the current project
    #>
    [CmdletBinding()]
    param(
        [string[]]$Agents = @("security", "testing", "documentation", "performance", "code-review")
    )
    
    Write-Host "🤖 Adding Claude Agents to project..." -ForegroundColor Cyan
    
    $currentDir = Get-Location
    $agentsDir = Join-Path $currentDir "ai_integration\agents"
    
    if (-not (Test-Path $agentsDir)) {
        Write-Host "⚠️ Run setup-ai-project first" -ForegroundColor Yellow
        return
    }
    
    $sourceAgents = Join-Path $AIPowerhousePath "ClaudeAgents-Installer\AgentPrompts"
    
    foreach ($agent in $Agents) {
        $sourceFile = Join-Path $sourceAgents "$agent-agent.txt"
        $targetFile = Join-Path $agentsDir "$agent-agent.txt"
        
        if (Test-Path $sourceFile) {
            Copy-Item -Path $sourceFile -Destination $targetFile -Force
            Write-Host "✅ $agent agent added" -ForegroundColor Green
        } else {
            Write-Host "⚠️ $agent agent not found" -ForegroundColor Yellow
        }
    }
    
    Write-Host "🎉 Claude Agents integration complete" -ForegroundColor Green
}

# Set up aliases for common AI operations
Set-Alias -Name ai-help -Value ai-help-global
Set-Alias -Name ask-ai -Value Invoke-AIPowerhouse -ErrorAction SilentlyContinue
Set-Alias -Name ask-claude -Value Invoke-ClaudeAI -ErrorAction SilentlyContinue

# Welcome message
Write-Host ""
Write-Host "🚀 AI Powerhouse Framework Ready!" -ForegroundColor Green
Write-Host "   Type 'ai-help' for available commands" -ForegroundColor Cyan
Write-Host "   Type 'setup-ai-project' to add AI to current project" -ForegroundColor Cyan
Write-Host ""

# Export functions
Export-ModuleMember -Function * -Alias *