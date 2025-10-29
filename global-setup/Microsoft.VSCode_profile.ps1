# VS Code PowerShell Profile for AI Integration
# Loads automatically when opening PowerShell terminal in VS Code

# Import AI Helpers module if available
$ModulePath = "$env:USERPROFILE\Documents\PowerShell\Modules\AIHelpers"
if (Test-Path $ModulePath) {
    try {
        Import-Module AIHelpers -Force -DisableNameChecking
        Write-Host "🤖 AI Helpers loaded!" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to load AI Helpers module: $($_.Exception.Message)"
    }
} else {
    Write-Warning "AI Helpers module not found at: $ModulePath"
}

# Import Claude Agents Module
$agentsModulePath = "$HOME\Documents\PowerShell\Modules\ClaudeAgents"
if (Test-Path $agentsModulePath) {
    Import-Module ClaudeAgents -Force
    Write-Host "✓ Claude Agents loaded" -ForegroundColor Green
    Write-Host "  Type 'agent-help' for available commands" -ForegroundColor Gray
} else {
    Write-Host "⚠ Claude Agents module not found at: $agentsModulePath" -ForegroundColor Yellow
}

# Quick agent shortcuts
function sa { security-review $args[0] }
function ta { generate-tests $args[0] }
function da { generate-docs $args[0] }
function pa { analyze-performance $args[0] }
function ra { code-review $args[0] }
function ap { agent-pipeline $args[0] }
function ca { compare-agents $args }
function ea { electronics-design $args }
function cp { component-pricing $args }
function pcb { pcb-layout $args }

Write-Host "Quick shortcuts:" -ForegroundColor Cyan
Write-Host "  sa = security-review" -ForegroundColor Gray
Write-Host "  ta = generate-tests" -ForegroundColor Gray
Write-Host "  da = generate-docs" -ForegroundColor Gray
Write-Host "  pa = analyze-performance" -ForegroundColor Gray
Write-Host "  ra = code-review" -ForegroundColor Gray
Write-Host "  ap = agent-pipeline" -ForegroundColor Gray
Write-Host "  ca = compare-agents" -ForegroundColor Gray
Write-Host "  ea = electronics-design" -ForegroundColor Gray
Write-Host "  cp = component-pricing" -ForegroundColor Gray
Write-Host "  pcb = pcb-layout" -ForegroundColor Gray
Write-Host ""

# Set up AI environment variables
$env:AI_LOG_PATH = "$env:USERPROFILE\.ai-logs"

# Quick functions for common VS Code + AI workflows
function Open-AILogs {
    <#
    .SYNOPSIS
        Opens the AI logs directory in Explorer
    #>
    if (Test-Path $env:AI_LOG_PATH) {
        Start-Process explorer.exe $env:AI_LOG_PATH
    } else {
        Write-Warning "AI logs directory not found: $env:AI_LOG_PATH"
    }
}
Set-Alias logs Open-AILogs

function Clear-AILogsOld {
    <#
    .SYNOPSIS
        Cleans up AI logs older than specified days
    #>
    param([int]$Days = 30)
    
    if (-not (Test-Path $env:AI_LOG_PATH)) {
        Write-Warning "AI logs directory not found"
        return
    }
    
    $cutoffDate = (Get-Date).AddDays(-$Days)
    $removed = 0
    
    Get-ChildItem $env:AI_LOG_PATH -Recurse -File | Where-Object {
        $_.CreationTime -lt $cutoffDate
    } | ForEach-Object {
        Remove-Item $_.FullName -Force
        $removed++
    }
    
    Write-Host "🗑️  Removed $removed old log files (older than $Days days)" -ForegroundColor Green
}

function Get-CurrentFile {
    <#
    .SYNOPSIS
        Gets the currently active file in VS Code (if available)
    #>
    # This would need VS Code extension to provide the file path
    # For now, return empty or prompt user
    return $null
}

function Invoke-AIOnCurrentFile {
    <#
    .SYNOPSIS
        Runs AI analysis on the currently active file in VS Code
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('claude', 'gemini', 'codex', 'all')]
        [string]$Tool,
        
        [Parameter(Mandatory = $true)]
        [string]$Prompt
    )
    
    $currentFile = Get-CurrentFile
    if (-not $currentFile) {
        Write-Warning "No current file detected. Please specify file path manually."
        return
    }
    
    switch ($Tool) {
        'claude' { claude $Prompt -File $currentFile }
        'gemini' { gemini $Prompt -File $currentFile }
        'codex' { gpt $Prompt -File $currentFile }
        'all' { ai-compare $Prompt -File $currentFile }
    }
}

# VS Code specific helper functions
function ai-fix {
    <#
    .SYNOPSIS
        Quick AI fix for current file
    #>
    param([string]$File)
    
    if (-not $File -and (Get-Command Get-CurrentFile -ErrorAction SilentlyContinue)) {
        $File = Get-CurrentFile
    }
    
    if (-not $File) {
        $File = Read-Host "Enter file path to fix"
    }
    
    if (Test-Path $File) {
        claude "Please analyze this code and fix any bugs or issues you find. Provide the corrected code." -File $File
    } else {
        Write-Error "File not found: $File"
    }
}

function ai-document {
    <#
    .SYNOPSIS
        Generate documentation for current file
    #>
    param([string]$File)
    
    if (-not $File -and (Get-Command Get-CurrentFile -ErrorAction SilentlyContinue)) {
        $File = Get-CurrentFile
    }
    
    if (-not $File) {
        $File = Read-Host "Enter file path to document"
    }
    
    if (Test-Path $File) {
        gemini "Please generate comprehensive documentation for this code, including function descriptions, parameters, and usage examples." -File $File
    } else {
        Write-Error "File not found: $File"
    }
}

function ai-test {
    <#
    .SYNOPSIS
        Generate unit tests for current file
    #>
    param([string]$File)
    
    if (-not $File -and (Get-Command Get-CurrentFile -ErrorAction SilentlyContinue)) {
        $File = Get-CurrentFile
    }
    
    if (-not $File) {
        $File = Read-Host "Enter file path to test"
    }
    
    if (Test-Path $File) {
        gpt "Please generate comprehensive unit tests for this code. Include edge cases and error handling tests." -File $File
    } else {
        Write-Error "File not found: $File"
    }
}

function ai-refactor {
    <#
    .SYNOPSIS
        Get refactoring suggestions for current file
    #>
    param([string]$File)
    
    if (-not $File -and (Get-Command Get-CurrentFile -ErrorAction SilentlyContinue)) {
        $File = Get-CurrentFile
    }
    
    if (-not $File) {
        $File = Read-Host "Enter file path to refactor"
    }
    
    if (Test-Path $File) {
        ai-compare "Please analyze this code and suggest refactoring improvements for better readability, performance, and maintainability." -File $File
    } else {
        Write-Error "File not found: $File"
    }
}

# Quick AI status check
function ai-status {
    <#
    .SYNOPSIS
        Check status of all AI tools
    #>
    Write-Host "🤖 AI Tools Status Check" -ForegroundColor Magenta
    Write-Host ("=" * 30) -ForegroundColor Gray
    
    $tools = @{
        'Claude' = 'claude'
        'Gemini' = 'gemini'
        'Codex' = 'codex'
    }
    
    foreach ($tool in $tools.GetEnumerator()) {
        $cmd = Get-Command $tool.Value -ErrorAction SilentlyContinue
        if ($cmd) {
            Write-Host "✅ $($tool.Key)" -ForegroundColor Green
        } else {
            Write-Host "❌ $($tool.Key) - Not found in PATH" -ForegroundColor Red
        }
    }
    
    # Check log directory
    if (Test-Path $env:AI_LOG_PATH) {
        $logCount = (Get-ChildItem $env:AI_LOG_PATH -Recurse -File).Count
        Write-Host "📁 Log files: $logCount" -ForegroundColor Cyan
    } else {
        Write-Host "📁 Log directory: Not found" -ForegroundColor Yellow
    }
}

# Display welcome message
if ($Host.Name -eq "Visual Studio Code Host") {
    Write-Host "`n🚀 " -ForegroundColor Blue -NoNewline
    Write-Host "AI Powerhouse VS Code Profile Loaded!" -ForegroundColor Green
    Write-Host "   Available commands: " -ForegroundColor Gray -NoNewline
    Write-Host "claude, gemini, gpt, ai-compare, ai-status" -ForegroundColor Yellow
    Write-Host "   Quick helpers: " -ForegroundColor Gray -NoNewline  
    Write-Host "ai-fix, ai-document, ai-test, ai-refactor" -ForegroundColor Cyan
    Write-Host "   Type " -ForegroundColor Gray -NoNewline
    Write-Host "ai-status" -ForegroundColor Yellow -NoNewline
    Write-Host " to check AI tools availability`n" -ForegroundColor Gray
}
