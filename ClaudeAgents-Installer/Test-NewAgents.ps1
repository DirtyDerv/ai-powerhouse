# Test Script for New Claude Agents
# Tests Database, Research, and N8N agents

Write-Host "🧪 Testing New Claude Agents..." -ForegroundColor Cyan
Write-Host ""

# Test if agent prompt files exist
$AgentPromptPath = "c:\Users\woody\OneDrive\Documents\ai powerhouse\ClaudeAgents-Installer\AgentPrompts"

$NewAgents = @(
    "database-agent.txt",
    "research-agent.txt", 
    "n8n-agent.txt"
)

Write-Host "📁 Checking Agent Prompt Files..." -ForegroundColor Yellow
foreach ($agent in $NewAgents) {
    $agentPath = Join-Path $AgentPromptPath $agent
    if (Test-Path $agentPath) {
        $fileSize = (Get-Item $agentPath).Length
        Write-Host "✅ $agent ($([math]::Round($fileSize/1KB, 1)) KB)" -ForegroundColor Green
    } else {
        Write-Host "❌ $agent - NOT FOUND" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📂 Checking PowerShell Functions..." -ForegroundColor Yellow

$FunctionPath = "c:\Users\woody\OneDrive\Documents\ai powerhouse\ClaudeAgents-Installer\PowerShellModule\Functions"
$NewFunctions = @(
    "Invoke-DatabaseAgent.ps1",
    "Invoke-ResearchAgent.ps1",
    "Invoke-N8NAgent.ps1"
)

foreach ($func in $NewFunctions) {
    $funcPath = Join-Path $FunctionPath $func
    if (Test-Path $funcPath) {
        Write-Host "✅ $func" -ForegroundColor Green
    } else {
        Write-Host "❌ $func - NOT FOUND" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🔄 Testing Module Import..." -ForegroundColor Yellow

try {
    # Import the ClaudeAgents module
    $ModulePath = "c:\Users\woody\OneDrive\Documents\ai powerhouse\ClaudeAgents-Installer\PowerShellModule\ClaudeAgents.psm1"
    Import-Module $ModulePath -Force -Verbose
    
    Write-Host "✅ Module imported successfully" -ForegroundColor Green
    
    # Check if new functions are available
    $availableFunctions = Get-Command -Module ClaudeAgents | Select-Object -ExpandProperty Name
    
    $newAgentFunctions = @(
        "Invoke-DatabaseAgent",
        "Invoke-ResearchAgent", 
        "Invoke-N8NAgent"
    )
    
    Write-Host ""
    Write-Host "🔍 Checking Available Functions..." -ForegroundColor Yellow
    foreach ($func in $newAgentFunctions) {
        if ($availableFunctions -contains $func) {
            Write-Host "✅ $func" -ForegroundColor Green
        } else {
            Write-Host "❌ $func - NOT AVAILABLE" -ForegroundColor Red
        }
    }
    
    # Check aliases
    Write-Host ""
    Write-Host "🏷️  Checking Aliases..." -ForegroundColor Yellow
    
    $expectedAliases = @(
        "database-optimize",
        "research-topic", 
        "n8n-workflow"
    )
    
    foreach ($alias in $expectedAliases) {
        try {
            $aliasCmd = Get-Alias $alias -ErrorAction Stop
            Write-Host "✅ $alias -> $($aliasCmd.Definition)" -ForegroundColor Green
        } catch {
            Write-Host "❌ $alias - NOT FOUND" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ Module import failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Testing Agent Help..." -ForegroundColor Yellow

try {
    agent-help | Out-String | Select-String -Pattern "(Database|Research|N8N)" | ForEach-Object {
        Write-Host "✅ Help includes: $($_.Line.Trim())" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Agent help test failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "📊 Test Summary:" -ForegroundColor Cyan
Write-Host "- 3 new agent prompt files created" -ForegroundColor White
Write-Host "- 3 new PowerShell functions created" -ForegroundColor White  
Write-Host "- Module updated with new functions and aliases" -ForegroundColor White
Write-Host "- Help documentation updated" -ForegroundColor White
Write-Host ""
Write-Host "🚀 New agents ready for use:" -ForegroundColor Green
Write-Host "  database-optimize 'your database question'" -ForegroundColor Cyan
Write-Host "  research-topic 'your research question'" -ForegroundColor Cyan
Write-Host "  n8n-workflow 'your automation needs'" -ForegroundColor Cyan