#Requires -Version 7.0
<#
.SYNOPSIS
Claude Agents System Installer - Complete AI Assistant Environment Setup

.DESCRIPTION
This installer deploys the complete Claude Agents system including:
- 9 Specialized AI Agents (Security, Testing, Docs, Performance, Code Review, Debug, Architecture, Refactoring, Electronics)
- PowerShell Module with 12+ functions and aliases
- VS Code Global Integration (tasks, keybindings, snippets)
- PowerShell Profile Enhancements
- Agent prompt files and configuration

.PARAMETER SkipPrerequisites
Skip prerequisite checking (use if you're sure Claude CLI and VS Code are installed)

.PARAMETER InstallPath
Custom installation path (default: user profile directories)

.PARAMETER NoVSCode
Skip VS Code integration (PowerShell-only installation)

.PARAMETER Uninstall
Remove the Claude Agents system

.EXAMPLE
.\Install-ClaudeAgents.ps1
# Standard installation with all components

.EXAMPLE
.\Install-ClaudeAgents.ps1 -NoVSCode
# Install PowerShell module only, skip VS Code integration

.EXAMPLE
.\Install-ClaudeAgents.ps1 -Uninstall
# Remove the Claude Agents system

.NOTES
Requires PowerShell 7.0+, Claude CLI, and optionally VS Code
Creates global configurations that enhance development workflow
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$SkipPrerequisites,
    
    [Parameter(Mandatory=$false)]
    [string]$InstallPath,
    
    [Parameter(Mandatory=$false)]
    [switch]$NoVSCode,
    
    [Parameter(Mandatory=$false)]
    [switch]$Uninstall
)

# Installation Configuration
$script:Config = @{
    ModuleName = "ClaudeAgents"
    Version = "1.0.0"
    AgentsPath = "$env:USERPROFILE\.claude-agents"
    ModulePath = "$env:USERPROFILE\Documents\PowerShell\Modules\ClaudeAgents"
    VSCodePath = "$env:APPDATA\Code\User"
    ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    LogFile = "$env:TEMP\ClaudeAgents-Install.log"
}

# Override paths if custom install path provided
if ($InstallPath) {
    $script:Config.AgentsPath = "$InstallPath\.claude-agents"
    $script:Config.ModulePath = "$InstallPath\PowerShell\Modules\ClaudeAgents"
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $script:Config.LogFile -Value $logEntry
    
    switch ($Level) {
        "ERROR" { Write-Host $Message -ForegroundColor Red }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        default { Write-Host $Message -ForegroundColor Cyan }
    }
}

function Test-Prerequisites {
    Write-Log "🔍 Checking prerequisites..."
    $issues = @()
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        $issues += "PowerShell 7.0+ required (current: $($PSVersionTable.PSVersion))"
    }
    
    # Check Claude CLI
    try {
        $claudeVersion = claude --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            $issues += "Claude CLI not found. Install from: https://docs.anthropic.com/claude/docs"
        } else {
            Write-Log "✅ Claude CLI detected: $claudeVersion" "SUCCESS"
        }
    } catch {
        $issues += "Claude CLI not found. Install from: https://docs.anthropic.com/claude/docs"
    }
    
    # Check VS Code (if not skipping)
    if (-not $NoVSCode) {
        try {
            $codePath = Get-Command code -ErrorAction SilentlyContinue
            if (-not $codePath) {
                $issues += "VS Code not found. Install from: https://code.visualstudio.com/"
            } else {
                Write-Log "✅ VS Code detected" "SUCCESS"
            }
        } catch {
            $issues += "VS Code not found. Install from: https://code.visualstudio.com/"
        }
    }
    
    if ($issues.Count -gt 0) {
        Write-Log "❌ Prerequisites missing:" "ERROR"
        foreach ($issue in $issues) {
            Write-Log "   • $issue" "ERROR"
        }
        return $false
    }
    
    Write-Log "✅ All prerequisites satisfied" "SUCCESS"
    return $true
}

function Install-AgentPrompts {
    Write-Log "📝 Installing agent prompt files..."
    
    $agentsDir = "$($script:Config.AgentsPath)\agents"
    $configDir = "$($script:Config.AgentsPath)\config"
    $logsDir = "$($script:Config.AgentsPath)\logs"
    
    # Create directories
    @($agentsDir, $configDir, $logsDir) | ForEach-Object {
        if (-not (Test-Path $_)) {
            New-Item -Path $_ -ItemType Directory -Force | Out-Null
            Write-Log "Created directory: $_"
        }
    }
    
    # Copy agent prompt files
    $sourceAgents = Join-Path $PSScriptRoot "AgentPrompts"
    if (Test-Path $sourceAgents) {
        Get-ChildItem $sourceAgents -File | ForEach-Object {
            Copy-Item $_.FullName -Destination $agentsDir -Force
            Write-Log "Installed agent: $($_.Name)"
        }
        Write-Log "✅ Agent prompts installed" "SUCCESS"
    } else {
        Write-Log "❌ Agent prompts directory not found: $sourceAgents" "ERROR"
        return $false
    }
    
    return $true
}

function Install-PowerShellModule {
    Write-Log "⚡ Installing PowerShell module..."
    
    # Create module directory
    $moduleDir = $script:Config.ModulePath
    if (-not (Test-Path $moduleDir)) {
        New-Item -Path $moduleDir -ItemType Directory -Force | Out-Null
        Write-Log "Created module directory: $moduleDir"
    }
    
    # Copy module files
    $sourceModule = Join-Path $PSScriptRoot "PowerShellModule"
    if (Test-Path $sourceModule) {
        # Copy all module files recursively
        Get-ChildItem $sourceModule -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($sourceModule.Length + 1)
            $destinationPath = Join-Path $moduleDir $relativePath
            
            if ($_.PSIsContainer) {
                if (-not (Test-Path $destinationPath)) {
                    New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
                }
            } else {
                $destinationDir = Split-Path $destinationPath -Parent
                if (-not (Test-Path $destinationDir)) {
                    New-Item -Path $destinationDir -ItemType Directory -Force | Out-Null
                }
                Copy-Item $_.FullName -Destination $destinationPath -Force
                Write-Log "Installed: $relativePath"
            }
        }
        
        Write-Log "✅ PowerShell module installed" "SUCCESS"
    } else {
        Write-Log "❌ PowerShell module directory not found: $sourceModule" "ERROR"
        return $false
    }
    
    # Import the module
    try {
        Import-Module $moduleDir -Force
        Write-Log "✅ Module imported successfully" "SUCCESS"
    } catch {
        Write-Log "❌ Failed to import module: $_" "ERROR"
        return $false
    }
    
    return $true
}

function Install-VSCodeConfig {
    if ($NoVSCode) {
        Write-Log "⏭️ Skipping VS Code configuration"
        return $true
    }
    
    Write-Log "🔧 Installing VS Code configuration..."
    
    $vscodeUserDir = $script:Config.VSCodePath
    if (-not (Test-Path $vscodeUserDir)) {
        Write-Log "❌ VS Code user directory not found: $vscodeUserDir" "ERROR"
        return $false
    }
    
    $sourceVSCode = Join-Path $PSScriptRoot "VSCodeConfig"
    if (-not (Test-Path $sourceVSCode)) {
        Write-Log "❌ VS Code config directory not found: $sourceVSCode" "ERROR"
        return $false
    }
    
    # Install each configuration file
    $configs = @{
        "tasks.json" = "Global tasks for all agents"
        "keybindings.json" = "Keyboard shortcuts for agents"
        "python.json" = "Python code snippets"
        "javascript.json" = "JavaScript code snippets"
        "global.json" = "Global code snippets"
    }
    
    foreach ($config in $configs.Keys) {
        $sourceFile = Join-Path $sourceVSCode $config
        if (Test-Path $sourceFile) {
            $destFile = Join-Path $vscodeUserDir $config
            
            # Backup existing file
            if (Test-Path $destFile) {
                $backupFile = "$destFile.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Copy-Item $destFile $backupFile
                Write-Log "Backed up existing $config to: $backupFile"
            }
            
            Copy-Item $sourceFile $destFile -Force
            Write-Log "Installed $config - $($configs[$config])"
        }
    }
    
    Write-Log "✅ VS Code configuration installed" "SUCCESS"
    return $true
}

function Install-PowerShellProfile {
    Write-Log "👤 Installing PowerShell profile enhancements..."
    
    $profilePath = $script:Config.ProfilePath
    $profileDir = Split-Path $profilePath -Parent
    
    # Create profile directory if it doesn't exist
    if (-not (Test-Path $profileDir)) {
        New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
        Write-Log "Created profile directory: $profileDir"
    }
    
    # Profile content to add
    $profileContent = @"

# ===== CLAUDE AGENTS INTEGRATION =====
# Auto-load Claude Agents module
if (Get-Module -ListAvailable -Name ClaudeAgents) {
    Import-Module ClaudeAgents -Force -WarningAction SilentlyContinue
}

# Claude Agents shortcuts
function ca { agent-help }
function ap { agent-pipeline `$args }
function comp { compare-agents `$args }

# Quick agent shortcuts
function sec { security-review `$args }
function test { generate-tests `$args }
function doc { generate-docs `$args }
function perf { analyze-performance `$args }
function cr { code-review `$args }
function dbg { debug-issue `$args }
function arch { design-architecture `$args }
function ref { refactor-code `$args }
function ea { electronics-design `$args }
function cp { component-pricing `$args }
function pcb { pcb-layout `$args }

# Show available shortcuts on profile load
Write-Host ""
Write-Host "🤖 Claude Agents Loaded!" -ForegroundColor Green
Write-Host "Quick Commands:" -ForegroundColor Cyan
Write-Host "  ca = agent-help (show all agents)" -ForegroundColor Gray
Write-Host "  ap = agent-pipeline" -ForegroundColor Gray
Write-Host "  comp = compare-agents" -ForegroundColor Gray
Write-Host ""
Write-Host "Agent Shortcuts:" -ForegroundColor Cyan
Write-Host "  sec = security-review" -ForegroundColor Gray
Write-Host "  test = generate-tests" -ForegroundColor Gray
Write-Host "  doc = generate-docs" -ForegroundColor Gray
Write-Host "  perf = analyze-performance" -ForegroundColor Gray
Write-Host "  cr = code-review" -ForegroundColor Gray
Write-Host "  dbg = debug-issue" -ForegroundColor Gray
Write-Host "  arch = design-architecture" -ForegroundColor Gray
Write-Host "  ref = refactor-code" -ForegroundColor Gray
Write-Host "  ea = electronics-design" -ForegroundColor Gray
Write-Host "  cp = component-pricing" -ForegroundColor Gray
Write-Host "  pcb = pcb-layout" -ForegroundColor Gray
Write-Host ""
# ===== END CLAUDE AGENTS INTEGRATION =====

"@

    # Check if profile already has Claude Agents integration
    $existingProfile = ""
    if (Test-Path $profilePath) {
        $existingProfile = Get-Content $profilePath -Raw
    }
    
    if ($existingProfile -notmatch "CLAUDE AGENTS INTEGRATION") {
        # Add to existing profile
        Add-Content -Path $profilePath -Value $profileContent
        Write-Log "✅ PowerShell profile enhanced" "SUCCESS"
    } else {
        Write-Log "⚠️ Claude Agents already integrated in profile" "WARNING"
    }
    
    return $true
}

function Test-Installation {
    Write-Log "🧪 Testing installation..."
    
    # Test module import
    try {
        $module = Get-Module ClaudeAgents
        if (-not $module) {
            Import-Module ClaudeAgents -Force
            $module = Get-Module ClaudeAgents
        }
        
        if ($module) {
            Write-Log "✅ Module import: SUCCESS" "SUCCESS"
            
            # Test agent availability
            $agents = @('security-review', 'generate-tests', 'generate-docs', 'electronics-design')
            foreach ($agent in $agents) {
                if (Get-Command $agent -ErrorAction SilentlyContinue) {
                    Write-Log "✅ Agent available: $agent" "SUCCESS"
                } else {
                    Write-Log "❌ Agent missing: $agent" "ERROR"
                }
            }
        } else {
            Write-Log "❌ Module import failed" "ERROR"
            return $false
        }
    } catch {
        Write-Log "❌ Module test failed: $_" "ERROR"
        return $false
    }
    
    # Test agent prompts
    $agentsDir = "$($script:Config.AgentsPath)\agents"
    $expectedAgents = @('security-agent.txt', 'testing-agent.txt', 'electronics-agent.txt')
    foreach ($agent in $expectedAgents) {
        $agentFile = Join-Path $agentsDir $agent
        if (Test-Path $agentFile) {
            Write-Log "✅ Agent prompt: $agent" "SUCCESS"
        } else {
            Write-Log "❌ Agent prompt missing: $agent" "ERROR"
        }
    }
    
    Write-Log "✅ Installation test completed" "SUCCESS"
    return $true
}

function Uninstall-ClaudeAgents {
    Write-Log "🗑️ Uninstalling Claude Agents system..."
    
    # Remove module
    if (Test-Path $script:Config.ModulePath) {
        Remove-Item $script:Config.ModulePath -Recurse -Force
        Write-Log "Removed PowerShell module"
    }
    
    # Remove agent prompts
    if (Test-Path $script:Config.AgentsPath) {
        Remove-Item $script:Config.AgentsPath -Recurse -Force
        Write-Log "Removed agent prompts"
    }
    
    # Clean profile (remove Claude Agents section)
    if (Test-Path $script:Config.ProfilePath) {
        $profileContent = Get-Content $script:Config.ProfilePath -Raw
        $cleanedContent = $profileContent -replace '(?s)# ===== CLAUDE AGENTS INTEGRATION =====.*?# ===== END CLAUDE AGENTS INTEGRATION =====\r?\n?', ''
        Set-Content $script:Config.ProfilePath -Value $cleanedContent
        Write-Log "Cleaned PowerShell profile"
    }
    
    Write-Log "✅ Uninstallation completed" "SUCCESS"
}

function Show-InstallationSummary {
    Write-Host ""
    Write-Host "🎉 Claude Agents Installation Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 Installation Locations:" -ForegroundColor Cyan
    Write-Host "  Module: $($script:Config.ModulePath)" -ForegroundColor Gray
    Write-Host "  Agents: $($script:Config.AgentsPath)" -ForegroundColor Gray
    if (-not $NoVSCode) {
        Write-Host "  VS Code: $($script:Config.VSCodePath)" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "🚀 Quick Start:" -ForegroundColor Cyan
    Write-Host "  agent-help          # Show all available agents" -ForegroundColor White
    Write-Host "  security-review     # Security analysis" -ForegroundColor White
    Write-Host "  electronics-design  # Circuit design assistance" -ForegroundColor White
    Write-Host "  generate-tests      # Create unit tests" -ForegroundColor White
    Write-Host "  agent-pipeline      # Run multiple agents in sequence" -ForegroundColor White
    Write-Host ""
    Write-Host "⌨️ VS Code Shortcuts:" -ForegroundColor Cyan
    if (-not $NoVSCode) {
        Write-Host "  Ctrl+Shift+Alt+S    # Security review" -ForegroundColor White
        Write-Host "  Ctrl+Shift+Alt+T    # Generate tests" -ForegroundColor White
        Write-Host "  Ctrl+Shift+Alt+E    # Electronics design" -ForegroundColor White
    } else {
        Write-Host "  Skipped (NoVSCode flag used)" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "📚 Documentation: .\Documentation\README.md" -ForegroundColor Cyan
    Write-Host "📋 Log file: $($script:Config.LogFile)" -ForegroundColor Gray
    Write-Host ""
}

# Main Installation Logic
function Main {
    Clear-Host
    Write-Host "🤖 Claude Agents System Installer v$($script:Config.Version)" -ForegroundColor Blue
    Write-Host "================================================" -ForegroundColor Blue
    Write-Host ""
    
    # Initialize log
    "Claude Agents Installation Started - $(Get-Date)" | Out-File $script:Config.LogFile -Force
    
    if ($Uninstall) {
        Uninstall-ClaudeAgents
        return
    }
    
    # Check prerequisites
    if (-not $SkipPrerequisites) {
        if (-not (Test-Prerequisites)) {
            Write-Log "❌ Installation aborted due to missing prerequisites" "ERROR"
            Write-Host ""
            Write-Host "💡 To skip prerequisite checking, use: -SkipPrerequisites" -ForegroundColor Yellow
            return
        }
    }
    
    Write-Host ""
    Write-Log "🚀 Starting Claude Agents installation..."
    
    # Install components
    $success = $true
    $success = $success -and (Install-AgentPrompts)
    $success = $success -and (Install-PowerShellModule)
    $success = $success -and (Install-VSCodeConfig)
    $success = $success -and (Install-PowerShellProfile)
    
    if ($success) {
        Write-Host ""
        Write-Log "🧪 Running installation tests..."
        Test-Installation | Out-Null
        
        Show-InstallationSummary
    } else {
        Write-Log "❌ Installation failed. Check log: $($script:Config.LogFile)" "ERROR"
    }
}

# Run installer
Main