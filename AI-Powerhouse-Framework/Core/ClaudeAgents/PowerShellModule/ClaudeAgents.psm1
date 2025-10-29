# ClaudeAgents PowerShell Module
# Provides functions to invoke specialized Claude Agents

$AgentPath = "$env:USERPROFILE\.claude-agents\agents"
$LogPath = "$env:USERPROFILE\.claude-agents\logs"

# Ensure directories exist
if (-not (Test-Path $AgentPath)) {
    New-Item -ItemType Directory -Path $AgentPath -Force | Out-Null
}
if (-not (Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
}

# Helper function to load agent prompt
function Get-AgentPrompt {
    param([string]$AgentName)
    
    $promptFile = Join-Path $AgentPath "$AgentName-agent.txt"
    
    if (Test-Path $promptFile) {
        return Get-Content $promptFile -Raw
    } else {
        Write-Error "Agent prompt file not found: $promptFile"
        return $null
    }
}

# Helper function to log agent interactions
function Write-AgentLog {
    param(
        [string]$AgentName,
        [string]$FilePath,
        [string]$Prompt,
        [string]$Response
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logFile = Join-Path $LogPath "agent-interactions.log"
    
    $logEntry = @"

===========================================
Timestamp: $timestamp
Agent: $AgentName
File: $FilePath
Prompt: $Prompt
Response Length: $($Response.Length) characters
===========================================

"@
    
    Add-Content -Path $logFile -Value $logEntry
}

# Helper function to check if claude command exists
function Test-ClaudeCode {
    $claudeExists = Get-Command claude -ErrorAction SilentlyContinue
    if (-not $claudeExists) {
        Write-Error "claude command not found. Please ensure Claude CLI is installed and in your PATH."
        return $false
    }
    return $true
}

# Export all functions in the Functions directory
$FunctionPath = Join-Path $PSScriptRoot "Functions"
if (Test-Path $FunctionPath) {
    Get-ChildItem -Path $FunctionPath -Filter "*.ps1" | ForEach-Object {
        . $_.FullName
    }
}

Write-Host "🤖 Claude Agents module loaded! Available functions:" -ForegroundColor Green
Write-Host "  • security-review, generate-tests, generate-docs, analyze-performance" -ForegroundColor Cyan
Write-Host "  • code-review, debug-issue, design-architecture, refactor-code" -ForegroundColor Cyan
Write-Host "  • electronics-design, pcb-layout, component-pricing" -ForegroundColor Cyan
Write-Host "  • agent-pipeline, compare-agents, agent-help" -ForegroundColor Cyan

# Export module members
Export-ModuleMember -Function * -Alias *