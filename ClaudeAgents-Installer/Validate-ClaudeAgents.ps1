<#
.SYNOPSIS
Claude Agents System Validation Script

.DESCRIPTION
Validates that the Claude Agents system is properly installed and functional.
Runs comprehensive tests on all components and provides detailed diagnostics.

.EXAMPLE
.\Validate-ClaudeAgents.ps1
# Run all validation tests

.EXAMPLE
.\Validate-ClaudeAgents.ps1 -Verbose
# Run with detailed output
#>

[CmdletBinding()]
param()

$script:TestResults = @{
    Passed = 0
    Failed = 0
    Warnings = 0
    Details = @()
}

function Write-TestResult {
    param(
        [string]$Test,
        [bool]$Passed,
        [string]$Details = "",
        [bool]$IsWarning = $false
    )
    
    if ($IsWarning) {
        $script:TestResults.Warnings++
        Write-Host "⚠️  WARN  $Test" -ForegroundColor Yellow
    } elseif ($Passed) {
        $script:TestResults.Passed++
        Write-Host "✅ PASS  $Test" -ForegroundColor Green
    } else {
        $script:TestResults.Failed++
        Write-Host "❌ FAIL  $Test" -ForegroundColor Red
    }
    
    if ($Details) {
        Write-Host "         $Details" -ForegroundColor Gray
    }
    
    $script:TestResults.Details += [PSCustomObject]@{
        Test = $Test
        Passed = $Passed
        IsWarning = $IsWarning
        Details = $Details
    }
}

function Test-Prerequisites {
    Write-Host "`n🔍 Testing Prerequisites..." -ForegroundColor Cyan
    
    # PowerShell version
    $psVersion = $PSVersionTable.PSVersion
    Write-TestResult "PowerShell Version >= 7.0" ($psVersion.Major -ge 7) "Current: $psVersion"
    
    # Claude CLI
    try {
        $claudeResult = claude --version 2>$null
        Write-TestResult "Claude CLI Available" ($LASTEXITCODE -eq 0) "Version: $claudeResult"
    } catch {
        Write-TestResult "Claude CLI Available" $false "Not found or not working"
    }
    
    # VS Code
    try {
        $codeResult = code --version 2>$null
        Write-TestResult "VS Code Available" ($LASTEXITCODE -eq 0) "VS Code detected"
    } catch {
        Write-TestResult "VS Code Available" $false "Not found" $true
    }
}

function Test-DirectoryStructure {
    Write-Host "`n📁 Testing Directory Structure..." -ForegroundColor Cyan
    
    $expectedDirs = @{
        "$env:USERPROFILE\.claude-agents" = "Claude Agents root directory"
        "$env:USERPROFILE\.claude-agents\agents" = "Agent prompt files"
        "$env:USERPROFILE\.claude-agents\config" = "Configuration directory"
        "$env:USERPROFILE\.claude-agents\logs" = "Logs directory"
        "$env:USERPROFILE\Documents\PowerShell\Modules\ClaudeAgents" = "PowerShell module"
    }
    
    foreach ($dir in $expectedDirs.Keys) {
        $exists = Test-Path $dir
        Write-TestResult $expectedDirs[$dir] $exists "Path: $dir"
    }
}

function Test-AgentPrompts {
    Write-Host "`n📝 Testing Agent Prompt Files..." -ForegroundColor Cyan
    
    $agentsDir = "$env:USERPROFILE\.claude-agents\agents"
    $expectedAgents = @(
        'security-agent.txt',
        'testing-agent.txt',
        'documentation-agent.txt',
        'performance-agent.txt',
        'code-review-agent.txt',
        'debugging-agent.txt',
        'architecture-agent.txt',
        'refactoring-agent.txt',
        'electronics-agent.txt'
    )
    
    foreach ($agent in $expectedAgents) {
        $agentPath = Join-Path $agentsDir $agent
        $exists = Test-Path $agentPath
        
        if ($exists) {
            $size = (Get-Item $agentPath).Length
            Write-TestResult "Agent prompt: $agent" $true "Size: $size bytes"
        } else {
            Write-TestResult "Agent prompt: $agent" $false "File not found"
        }
    }
}

function Test-PowerShellModule {
    Write-Host "`n⚡ Testing PowerShell Module..." -ForegroundColor Cyan
    
    # Module files
    $moduleDir = "$env:USERPROFILE\Documents\PowerShell\Modules\ClaudeAgents"
    $expectedFiles = @(
        'ClaudeAgents.psd1',
        'ClaudeAgents.psm1',
        'Functions\Invoke-SecurityAgent.ps1',
        'Functions\Invoke-TestingAgent.ps1',
        'Functions\Invoke-ElectronicsAgent.ps1',
        'Functions\Get-AgentHelp.ps1'
    )
    
    foreach ($file in $expectedFiles) {
        $filePath = Join-Path $moduleDir $file
        $exists = Test-Path $filePath
        Write-TestResult "Module file: $file" $exists
    }
    
    # Module import
    try {
        Import-Module ClaudeAgents -Force -ErrorAction Stop
        $module = Get-Module ClaudeAgents
        Write-TestResult "Module Import" ($module -ne $null) "Version: $($module.Version)"
        
        # Test exported functions
        $expectedFunctions = @(
            'security-review',
            'generate-tests',
            'electronics-design',
            'agent-help',
            'agent-pipeline'
        )
        
        foreach ($func in $expectedFunctions) {
            $command = Get-Command $func -ErrorAction SilentlyContinue
            Write-TestResult "Function: $func" ($command -ne $null)
        }
        
    } catch {
        Write-TestResult "Module Import" $false "Import failed: $_"
    }
}

function Test-VSCodeIntegration {
    Write-Host "`n🔧 Testing VS Code Integration..." -ForegroundColor Cyan
    
    $vscodeDir = "$env:APPDATA\Code\User"
    if (-not (Test-Path $vscodeDir)) {
        Write-TestResult "VS Code User Directory" $false "Directory not found" $true
        return
    }
    
    $expectedFiles = @{
        'tasks.json' = 'Global tasks configuration'
        'keybindings.json' = 'Keyboard shortcuts'
        'python.json' = 'Python code snippets'
        'javascript.json' = 'JavaScript code snippets'
        'global.json' = 'Global code snippets'
    }
    
    foreach ($file in $expectedFiles.Keys) {
        $filePath = Join-Path $vscodeDir $file
        $exists = Test-Path $filePath
        Write-TestResult $expectedFiles[$file] $exists "File: $file"
        
        if ($exists -and $file -eq 'tasks.json') {
            try {
                $tasks = Get-Content $filePath | ConvertFrom-Json
                $agentTasks = $tasks.tasks | Where-Object { $_.label -like "*Agent*" }
                Write-TestResult "Agent Tasks in tasks.json" ($agentTasks.Count -gt 0) "Found $($agentTasks.Count) agent tasks"
            } catch {
                Write-TestResult "Parse tasks.json" $false "JSON parse error"
            }
        }
    }
}

function Test-PowerShellProfile {
    Write-Host "`n👤 Testing PowerShell Profile..." -ForegroundColor Cyan
    
    $profilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    $exists = Test-Path $profilePath
    
    if ($exists) {
        $profileContent = Get-Content $profilePath -Raw
        $hasIntegration = $profileContent -match "CLAUDE AGENTS INTEGRATION"
        Write-TestResult "PowerShell Profile Integration" $hasIntegration "Profile enhanced"
        
        # Test profile shortcuts
        $expectedShortcuts = @('ca', 'sec', 'test', 'ea', 'ap')
        foreach ($shortcut in $expectedShortcuts) {
            $hasShortcut = $profileContent -match "function $shortcut"
            Write-TestResult "Profile shortcut: $shortcut" $hasShortcut
        }
    } else {
        Write-TestResult "PowerShell Profile" $false "Profile file not found" $true
    }
}

function Test-AgentFunctionality {
    Write-Host "`n🧪 Testing Agent Functionality..." -ForegroundColor Cyan
    
    # Test agent-help
    try {
        $helpOutput = agent-help 2>&1
        $hasAgentList = $helpOutput -match "Security Expert"
        Write-TestResult "agent-help command" $hasAgentList "Help system working"
    } catch {
        Write-TestResult "agent-help command" $false "Command failed: $_"
    }
    
    # Test Get-AgentPrompt function
    try {
        $prompt = Get-AgentPrompt -AgentName "security" -ErrorAction Stop
        Write-TestResult "Get-AgentPrompt function" ($prompt.Length -gt 100) "Prompt loaded successfully"
    } catch {
        Write-TestResult "Get-AgentPrompt function" $false "Function failed: $_"
    }
    
    # Test Claude connectivity (non-destructive)
    try {
        $claudeTest = claude --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-TestResult "Claude CLI Connectivity" $true "Ready for agent execution"
        } else {
            Write-TestResult "Claude CLI Connectivity" $false "Claude CLI not responding"
        }
    } catch {
        Write-TestResult "Claude CLI Connectivity" $false "Connection test failed"
    }
}

function Show-Summary {
    Write-Host "`n" + "="*60 -ForegroundColor Blue
    Write-Host "🎯 VALIDATION SUMMARY" -ForegroundColor Blue
    Write-Host "="*60 -ForegroundColor Blue
    
    $total = $script:TestResults.Passed + $script:TestResults.Failed + $script:TestResults.Warnings
    
    Write-Host ""
    Write-Host "📊 Results:" -ForegroundColor Cyan
    Write-Host "   ✅ Passed:   $($script:TestResults.Passed)" -ForegroundColor Green
    Write-Host "   ❌ Failed:   $($script:TestResults.Failed)" -ForegroundColor Red
    Write-Host "   ⚠️  Warnings: $($script:TestResults.Warnings)" -ForegroundColor Yellow
    Write-Host "   📋 Total:    $total" -ForegroundColor Gray
    
    $successRate = if ($total -gt 0) { [math]::Round(($script:TestResults.Passed / $total) * 100, 1) } else { 0 }
    Write-Host "   🎯 Success:  $successRate%" -ForegroundColor $(if ($successRate -ge 90) { "Green" } elseif ($successRate -ge 70) { "Yellow" } else { "Red" })
    
    Write-Host ""
    if ($script:TestResults.Failed -eq 0) {
        Write-Host "🎉 Installation VALIDATED - Claude Agents system is ready!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🚀 Try these commands:" -ForegroundColor Cyan
        Write-Host "   agent-help" -ForegroundColor White
        Write-Host "   security-review" -ForegroundColor White
        Write-Host "   electronics-design" -ForegroundColor White
    } else {
        Write-Host "❌ Installation has ISSUES - check failed tests above" -ForegroundColor Red
        Write-Host ""
        Write-Host "🔧 Common fixes:" -ForegroundColor Yellow
        Write-Host "   • Restart PowerShell" -ForegroundColor Gray
        Write-Host "   • Re-run installer" -ForegroundColor Gray
        Write-Host "   • Check Claude CLI installation" -ForegroundColor Gray
    }
    
    Write-Host ""
}

# Main validation execution
Clear-Host
Write-Host "🧪 Claude Agents System Validation" -ForegroundColor Blue
Write-Host "=====================================" -ForegroundColor Blue

Test-Prerequisites
Test-DirectoryStructure
Test-AgentPrompts
Test-PowerShellModule
Test-VSCodeIntegration
Test-PowerShellProfile
Test-AgentFunctionality

Show-Summary