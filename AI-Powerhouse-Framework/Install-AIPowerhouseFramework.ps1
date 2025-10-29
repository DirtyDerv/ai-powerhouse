#Requires -Version 7.0
<#
.SYNOPSIS
AI Powerhouse Framework - Unified Installer

.DESCRIPTION
Complete installer for the AI Powerhouse Framework that combines:
- Python AI Powerhouse (Claude, Gemini, OpenAI providers)
- PowerShell Claude Agents (9 specialized development agents)
- Cross-system integration and unified interface
- VS Code global integration for both systems
- Comprehensive development environment

.PARAMETER SkipPrerequisites
Skip prerequisite checking

.PARAMETER PythonOnly
Install only Python AI components

.PARAMETER PowerShellOnly
Install only PowerShell Claude Agents

.PARAMETER NoVSCode
Skip VS Code integration

.PARAMETER InstallPath
Custom installation path

.PARAMETER Uninstall
Remove the entire AI Powerhouse Framework

.EXAMPLE
.\Install-AIPowerhouseFramework.ps1
# Complete installation with all components

.EXAMPLE
.\Install-AIPowerhouseFramework.ps1 -PythonOnly
# Install only Python AI components

.EXAMPLE
.\Install-AIPowerhouseFramework.ps1 -Uninstall
# Remove all components

.NOTES
Requires Python 3.8+, PowerShell 7.0+, and optionally VS Code
Creates a unified AI development environment
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch]$SkipPrerequisites,
    
    [Parameter(Mandatory=$false)]
    [switch]$PythonOnly,
    
    [Parameter(Mandatory=$false)]
    [switch]$PowerShellOnly,
    
    [Parameter(Mandatory=$false)]
    [switch]$NoVSCode,
    
    [Parameter(Mandatory=$false)]
    [string]$InstallPath,
    
    [Parameter(Mandatory=$false)]
    [switch]$Uninstall
)

# Installation Configuration
$script:Config = @{
    FrameworkName = "AI-Powerhouse-Framework"
    Version = "2.0.0"
    BaseInstallPath = if ($InstallPath) { $InstallPath } else { "$env:USERPROFILE\AI-Powerhouse-Framework" }
    PythonAIPath = ""
    ClaudeAgentsPath = "$env:USERPROFILE\.claude-agents"
    PowerShellModulePath = "$env:USERPROFILE\Documents\PowerShell\Modules"
    VSCodePath = "$env:APPDATA\Code\User"
    ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    LogFile = "$env:TEMP\AIPowerhouse-Install.log"
    VenvName = "ai-powerhouse"
}

# Update paths based on base install path
$script:Config.PythonAIPath = Join-Path $script:Config.BaseInstallPath "PythonAI"

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
    
    # Check Python (if not PowerShell-only)
    if (-not $PowerShellOnly) {
        try {
            $pythonVersion = python --version 2>$null
            if ($LASTEXITCODE -ne 0) {
                $issues += "Python 3.8+ required. Install from: https://python.org"
            } else {
                Write-Log "✅ Python detected: $pythonVersion" "SUCCESS"
            }
        } catch {
            $issues += "Python 3.8+ required. Install from: https://python.org"
        }
        
        # Check pip
        try {
            pip --version 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                $issues += "pip package manager required"
            }
        } catch {
            $issues += "pip package manager required"
        }
    }
    
    # Check Claude CLI (if not Python-only)
    if (-not $PythonOnly) {
        try {
            $claudeVersion = claude --version 2>$null
            if ($LASTEXITCODE -ne 0) {
                $issues += "Claude CLI required. Install from: https://docs.anthropic.com/claude/docs"
            } else {
                Write-Log "✅ Claude CLI detected: $claudeVersion" "SUCCESS"
            }
        } catch {
            $issues += "Claude CLI required. Install from: https://docs.anthropic.com/claude/docs"
        }
    }
    
    # Check VS Code (optional)
    if (-not $NoVSCode) {
        try {
            $codePath = Get-Command code -ErrorAction SilentlyContinue
            if (-not $codePath) {
                Write-Log "⚠️ VS Code not found (optional)" "WARNING"
            } else {
                Write-Log "✅ VS Code detected" "SUCCESS"
            }
        } catch {
            Write-Log "⚠️ VS Code not found (optional)" "WARNING"
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

function Install-PythonAI {
    if ($PowerShellOnly) {
        Write-Log "⏭️ Skipping Python AI installation (PowerShell-only mode)"
        return $true
    }
    
    Write-Log "🐍 Installing Python AI Powerhouse..."
    
    # Create Python AI directory
    $pythonDir = $script:Config.PythonAIPath
    if (-not (Test-Path $pythonDir)) {
        New-Item -Path $pythonDir -ItemType Directory -Force | Out-Null
        Write-Log "Created Python AI directory: $pythonDir"
    }
    
    # Copy Python AI core
    $sourcePython = Join-Path $PSScriptRoot "Core\PythonAI"
    if (-not (Test-Path $sourcePython)) {
        Write-Log "❌ Python AI source not found: $sourcePython" "ERROR"
        return $false
    }
    
    # Copy all Python files
    try {
        Copy-Item "$sourcePython\*" -Destination $pythonDir -Recurse -Force
        Write-Log "✅ Python AI core copied"
        
        # Create virtual environment
        Write-Log "Creating Python virtual environment..."
        $venvPath = Join-Path $pythonDir ".venv"
        
        if (Test-Path $venvPath) {
            Remove-Item $venvPath -Recurse -Force
        }
        
        python -m venv $venvPath
        if ($LASTEXITCODE -ne 0) {
            Write-Log "❌ Failed to create virtual environment" "ERROR"
            return $false
        }
        
        # Install Python dependencies
        $pipPath = Join-Path $venvPath "Scripts\pip.exe"
        $requirementsPath = Join-Path $pythonDir "requirements.txt"
        
        if (Test-Path $requirementsPath) {
            Write-Log "Installing Python dependencies..."
            & $pipPath install -r $requirementsPath --quiet
            if ($LASTEXITCODE -ne 0) {
                Write-Log "❌ Failed to install Python dependencies" "ERROR"
                return $false
            }
            Write-Log "✅ Python dependencies installed"
        }
        
        # Test Python AI
        $pythonExe = Join-Path $venvPath "Scripts\python.exe"
        $testScript = Join-Path $pythonDir "ai_powerhouse\__init__.py"
        
        if (Test-Path $testScript) {
            & $pythonExe -c "from ai_powerhouse.core import AIPowerhouse; print('Python AI ready')" 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "✅ Python AI installation verified" "SUCCESS"
            } else {
                Write-Log "⚠️ Python AI test warning (may need API keys)" "WARNING"
            }
        }
        
    } catch {
        Write-Log "❌ Python AI installation failed: $_" "ERROR"
        return $false
    }
    
    return $true
}

function Install-ClaudeAgents {
    if ($PythonOnly) {
        Write-Log "⏭️ Skipping Claude Agents installation (Python-only mode)"
        return $true
    }
    
    Write-Log "⚡ Installing Claude Agents system..."
    
    # Use the Claude Agents installer
    $claudeInstaller = Join-Path $PSScriptRoot "Core\ClaudeAgents\Install-ClaudeAgents.ps1"
    if (-not (Test-Path $claudeInstaller)) {
        Write-Log "❌ Claude Agents installer not found: $claudeInstaller" "ERROR"
        return $false
    }
    
    try {
        # Run Claude Agents installer
        $installArgs = @()
        if ($NoVSCode) { $installArgs += "-NoVSCode" }
        if ($SkipPrerequisites) { $installArgs += "-SkipPrerequisites" }
        
        Write-Log "Running Claude Agents installer..."
        $claudeInstallerDir = Split-Path $claudeInstaller -Parent
        
        Push-Location $claudeInstallerDir
        try {
            & $claudeInstaller @installArgs
            if ($LASTEXITCODE -eq 0) {
                Write-Log "✅ Claude Agents installed successfully" "SUCCESS"
                return $true
            } else {
                Write-Log "❌ Claude Agents installation failed" "ERROR"
                return $false
            }
        } finally {
            Pop-Location
        }
    } catch {
        Write-Log "❌ Claude Agents installation error: $_" "ERROR"
        return $false
    }
}

function Install-CrossSystemIntegration {
    Write-Log "🔗 Installing cross-system integration..."
    
    # Install Python-PowerShell bridge
    $integrationSource = Join-Path $PSScriptRoot "Integration"
    if (-not (Test-Path $integrationSource)) {
        Write-Log "❌ Integration source not found: $integrationSource" "ERROR"
        return $false
    }
    
    # Copy integration files to Python AI
    if (-not $PowerShellOnly) {
        $pythonIntegrationPath = Join-Path $script:Config.PythonAIPath "integration"
        if (-not (Test-Path $pythonIntegrationPath)) {
            New-Item -Path $pythonIntegrationPath -ItemType Directory -Force | Out-Null
        }
        
        Copy-Item "$integrationSource\unified_ai_bridge.py" -Destination $pythonIntegrationPath -Force
        Write-Log "✅ Python integration bridge installed"
    }
    
    # Install PowerShell module for Python AI access
    if (-not $PythonOnly) {
        $psModulePath = Join-Path $script:Config.PowerShellModulePath "AIPowerhouse"
        if (-not (Test-Path $psModulePath)) {
            New-Item -Path $psModulePath -ItemType Directory -Force | Out-Null
        }
        
        Copy-Item "$integrationSource\AIPowerhouse.psm1" -Destination $psModulePath -Force
        
        # Create module manifest
        $manifestPath = Join-Path $psModulePath "AIPowerhouse.psd1"
        $manifestContent = @"
@{
    RootModule = 'AIPowerhouse.psm1'
    ModuleVersion = '2.0.0'
    GUID = 'b2c3d4e5-f6g7-8901-bcde-f23456789012'
    Author = 'AI Powerhouse Team'
    Description = 'Python AI Powerhouse integration for PowerShell'
    PowerShellVersion = '7.0'
    RequiredModules = @('ClaudeAgents')
}
"@
        Set-Content -Path $manifestPath -Value $manifestContent
        Write-Log "✅ PowerShell AI integration module installed"
        
        # Test integration
        try {
            Import-Module $psModulePath -Force
            Write-Log "✅ Cross-system integration ready" "SUCCESS"
        } catch {
            Write-Log "⚠️ Integration module test warning: $_" "WARNING"
        }
    }
    
    return $true
}

function Install-UnifiedVSCode {
    if ($NoVSCode) {
        Write-Log "⏭️ Skipping VS Code integration"
        return $true
    }
    
    Write-Log "🔧 Installing unified VS Code configuration..."
    
    $vscodeUserDir = $script:Config.VSCodePath
    if (-not (Test-Path $vscodeUserDir)) {
        Write-Log "❌ VS Code user directory not found: $vscodeUserDir" "ERROR"
        return $false
    }
    
    # Enhanced VS Code configuration that includes both systems
    $vsConfigSource = Join-Path $PSScriptRoot "VSCodeConfig"
    if (Test-Path $vsConfigSource) {
        # Install VS Code configs from ClaudeAgents (already handles this)
        Write-Log "✅ VS Code configuration handled by Claude Agents installer"
    }
    
    # Add AI Powerhouse specific tasks
    $userTasksPath = Join-Path $vscodeUserDir "tasks.json"
    if (Test-Path $userTasksPath) {
        try {
            $existingTasks = Get-Content $userTasksPath | ConvertFrom-Json
            
            # Add Python AI tasks
            $pythonAITasks = @(
                @{
                    label = "AI Powerhouse - Ask Claude"
                    type = "shell"
                    command = "python"
                    args = @("${workspaceFolder}\integration\unified_ai_bridge.py", "ai", "--provider", "claude", "--prompt", "${input:aiPrompt}")
                    group = "build"
                    presentation = @{ echo = $true; reveal = "always"; focus = $false }
                },
                @{
                    label = "AI Powerhouse - Ask All Providers"
                    type = "shell"
                    command = "python"
                    args = @("${workspaceFolder}\integration\unified_ai_bridge.py", "ai", "--provider", "all", "--prompt", "${input:aiPrompt}")
                    group = "build"
                    presentation = @{ echo = $true; reveal = "always"; focus = $false }
                },
                @{
                    label = "AI Powerhouse - Comprehensive Analysis"
                    type = "shell"
                    command = "python"
                    args = @("${workspaceFolder}\integration\unified_ai_bridge.py", "comprehensive", "--file", "${file}")
                    group = "build"
                    presentation = @{ echo = $true; reveal = "always"; focus = $false }
                }
            )
            
            # Add to existing tasks
            $existingTasks.tasks += $pythonAITasks
            
            # Backup and save
            $backupPath = "$userTasksPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item $userTasksPath $backupPath
            
            $existingTasks | ConvertTo-Json -Depth 10 | Set-Content $userTasksPath
            Write-Log "✅ Enhanced VS Code tasks with AI Powerhouse integration"
            
        } catch {
            Write-Log "⚠️ VS Code tasks enhancement warning: $_" "WARNING"
        }
    }
    
    return $true
}

function Install-UnifiedProfile {
    Write-Log "👤 Installing unified PowerShell profile..."
    
    $profilePath = $script:Config.ProfilePath
    $profileDir = Split-Path $profilePath -Parent
    
    if (-not (Test-Path $profileDir)) {
        New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
    }
    
    # Enhanced profile content
    $enhancedProfileContent = @"

# ===== AI POWERHOUSE FRAMEWORK =====
# Load AI Powerhouse Framework components

# Auto-load Claude Agents module
if (Get-Module -ListAvailable -Name ClaudeAgents) {
    Import-Module ClaudeAgents -Force -WarningAction SilentlyContinue
}

# Auto-load AI Powerhouse Python integration
if (Get-Module -ListAvailable -Name AIPowerhouse) {
    Import-Module AIPowerhouse -Force -WarningAction SilentlyContinue
}

# Unified AI shortcuts
function ai { ai-claude `$args }              # Default to Claude
function ai-quick { ai-all `$args }           # Ask all providers
function ai-file { ai-analyze `$args }        # Analyze file with all systems
function ai-help { ai-caps }                  # Show all capabilities

# Enhanced Claude Agents shortcuts (from original installation)
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

# Show available capabilities on profile load
Write-Host ""
Write-Host "🚀 AI Powerhouse Framework Loaded!" -ForegroundColor Green
Write-Host ""
Write-Host "🤖 AI Providers:" -ForegroundColor Cyan
Write-Host "  ai '<prompt>'        # Ask Claude (default)" -ForegroundColor Gray
Write-Host "  ai-claude '<prompt>' # Ask Claude directly" -ForegroundColor Gray
Write-Host "  ai-gemini '<prompt>' # Ask Google Gemini" -ForegroundColor Gray
Write-Host "  ai-openai '<prompt>' # Ask OpenAI" -ForegroundColor Gray
Write-Host "  ai-quick '<prompt>'  # Ask all providers" -ForegroundColor Gray
Write-Host "  ai-file '<path>'     # Comprehensive file analysis" -ForegroundColor Gray
Write-Host ""
Write-Host "⚡ Specialized Agents:" -ForegroundColor Cyan
Write-Host "  sec = security-review     doc = generate-docs" -ForegroundColor Gray
Write-Host "  test = generate-tests     perf = analyze-performance" -ForegroundColor Gray
Write-Host "  cr = code-review          dbg = debug-issue" -ForegroundColor Gray
Write-Host "  arch = design-architecture ref = refactor-code" -ForegroundColor Gray
Write-Host "  ea = electronics-design   cp = component-pricing" -ForegroundColor Gray
Write-Host ""
Write-Host "🔧 System Commands:" -ForegroundColor Cyan
Write-Host "  ai-help     # Show all AI capabilities" -ForegroundColor Gray
Write-Host "  ca          # Show all Claude Agents" -ForegroundColor Gray
Write-Host "  ap          # Agent pipeline" -ForegroundColor Gray
Write-Host "  comp        # Compare agent responses" -ForegroundColor Gray
Write-Host ""
# ===== END AI POWERHOUSE FRAMEWORK =====

"@

    # Check if profile already has AI Powerhouse integration
    $existingProfile = ""
    if (Test-Path $profilePath) {
        $existingProfile = Get-Content $profilePath -Raw
    }
    
    if ($existingProfile -notmatch "AI POWERHOUSE FRAMEWORK") {
        Add-Content -Path $profilePath -Value $enhancedProfileContent
        Write-Log "✅ PowerShell profile enhanced with unified AI framework" "SUCCESS"
    } else {
        Write-Log "⚠️ AI Powerhouse Framework already integrated in profile" "WARNING"
    }
    
    return $true
}

function Test-UnifiedInstallation {
    Write-Log "🧪 Testing unified installation..."
    
    $testResults = @{
        PythonAI = $false
        ClaudeAgents = $false
        Integration = $false
        VSCode = $false
    }
    
    # Test Python AI (if installed)
    if (-not $PowerShellOnly) {
        try {
            $pythonExe = Join-Path $script:Config.PythonAIPath ".venv\Scripts\python.exe"
            if (Test-Path $pythonExe) {
                $testResult = & $pythonExe -c "from ai_powerhouse.core import AIPowerhouse; print('OK')" 2>&1
                if ($LASTEXITCODE -eq 0 -and $testResult -eq "OK") {
                    $testResults.PythonAI = $true
                    Write-Log "✅ Python AI test: PASS" "SUCCESS"
                } else {
                    Write-Log "❌ Python AI test: FAIL" "ERROR"
                }
            }
        } catch {
            Write-Log "❌ Python AI test error: $_" "ERROR"
        }
    } else {
        $testResults.PythonAI = $true  # Not tested in PowerShell-only mode
    }
    
    # Test Claude Agents (if installed)
    if (-not $PythonOnly) {
        try {
            $agentTest = agent-help 2>&1
            if ($agentTest -and $agentTest -match "Security Expert") {
                $testResults.ClaudeAgents = $true
                Write-Log "✅ Claude Agents test: PASS" "SUCCESS"
            } else {
                Write-Log "❌ Claude Agents test: FAIL" "ERROR"
            }
        } catch {
            Write-Log "❌ Claude Agents test error: $_" "ERROR"
        }
    } else {
        $testResults.ClaudeAgents = $true  # Not tested in Python-only mode
    }
    
    # Test integration
    if (-not $PythonOnly -and -not $PowerShellOnly) {
        try {
            $integrationTest = ai-caps 2>&1
            if ($integrationTest) {
                $testResults.Integration = $true
                Write-Log "✅ Integration test: PASS" "SUCCESS"
            } else {
                Write-Log "❌ Integration test: FAIL" "ERROR"
            }
        } catch {
            Write-Log "❌ Integration test error: $_" "ERROR"
        }
    } else {
        $testResults.Integration = $true  # Not applicable for single-system installs
    }
    
    # Test VS Code (if installed)
    if (-not $NoVSCode) {
        $vscodeTasksPath = Join-Path $script:Config.VSCodePath "tasks.json"
        if (Test-Path $vscodeTasksPath) {
            $testResults.VSCode = $true
            Write-Log "✅ VS Code integration: PASS" "SUCCESS"
        } else {
            Write-Log "❌ VS Code integration: FAIL" "ERROR"
        }
    } else {
        $testResults.VSCode = $true  # Not tested when skipped
    }
    
    $allPassed = $testResults.Values -notcontains $false
    if ($allPassed) {
        Write-Log "✅ All installation tests passed!" "SUCCESS"
    } else {
        Write-Log "❌ Some installation tests failed" "ERROR"
    }
    
    return $allPassed
}

function Uninstall-AIPowerhouseFramework {
    Write-Log "🗑️ Uninstalling AI Powerhouse Framework..."
    
    # Remove Python AI
    if (Test-Path $script:Config.PythonAIPath) {
        Remove-Item $script:Config.PythonAIPath -Recurse -Force
        Write-Log "Removed Python AI Powerhouse"
    }
    
    # Remove Claude Agents using their uninstaller
    $claudeUninstaller = Join-Path $PSScriptRoot "Core\ClaudeAgents\Install-ClaudeAgents.ps1"
    if (Test-Path $claudeUninstaller) {
        try {
            & $claudeUninstaller -Uninstall
            Write-Log "Removed Claude Agents system"
        } catch {
            Write-Log "Warning: Claude Agents uninstall failed: $_" "WARNING"
        }
    }
    
    # Remove integration modules
    $aiPowerhouseModule = Join-Path $script:Config.PowerShellModulePath "AIPowerhouse"
    if (Test-Path $aiPowerhouseModule) {
        Remove-Item $aiPowerhouseModule -Recurse -Force
        Write-Log "Removed AIPowerhouse PowerShell module"
    }
    
    # Clean profile
    if (Test-Path $script:Config.ProfilePath) {
        $profileContent = Get-Content $script:Config.ProfilePath -Raw
        $cleanedContent = $profileContent -replace '(?s)# ===== AI POWERHOUSE FRAMEWORK =====.*?# ===== END AI POWERHOUSE FRAMEWORK =====\r?\n?', ''
        Set-Content $script:Config.ProfilePath -Value $cleanedContent
        Write-Log "Cleaned PowerShell profile"
    }
    
    Write-Log "✅ Uninstallation completed" "SUCCESS"
}

function Show-InstallationSummary {
    Write-Host ""
    Write-Host "🎉 AI POWERHOUSE FRAMEWORK INSTALLATION COMPLETE!" -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "📍 Installation Locations:" -ForegroundColor Cyan
    Write-Host "  Framework Base: $($script:Config.BaseInstallPath)" -ForegroundColor Gray
    if (-not $PowerShellOnly) {
        Write-Host "  Python AI: $($script:Config.PythonAIPath)" -ForegroundColor Gray
    }
    if (-not $PythonOnly) {
        Write-Host "  Claude Agents: $($script:Config.ClaudeAgentsPath)" -ForegroundColor Gray
        Write-Host "  PowerShell Modules: $($script:Config.PowerShellModulePath)" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "🚀 Available Capabilities:" -ForegroundColor Cyan
    
    if (-not $PowerShellOnly) {
        Write-Host ""
        Write-Host "🐍 Python AI Providers:" -ForegroundColor Yellow
        Write-Host "  • Claude AI (Anthropic)" -ForegroundColor Gray
        Write-Host "  • Gemini (Google)" -ForegroundColor Gray
        Write-Host "  • OpenAI (GPT models)" -ForegroundColor Gray
    }
    
    if (-not $PythonOnly) {
        Write-Host ""
        Write-Host "⚡ Specialized Claude Agents:" -ForegroundColor Yellow
        Write-Host "  • Security Expert       • Testing Expert" -ForegroundColor Gray
        Write-Host "  • Documentation Expert  • Performance Expert" -ForegroundColor Gray
        Write-Host "  • Code Review Expert    • Debug Expert" -ForegroundColor Gray
        Write-Host "  • Architecture Expert   • Refactoring Expert" -ForegroundColor Gray
        Write-Host "  • Electronics Expert (with UK pricing)" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "🎯 Quick Start Commands:" -ForegroundColor Cyan
    
    if (-not $PowerShellOnly -and -not $PythonOnly) {
        Write-Host "  ai-help                 # Show all capabilities" -ForegroundColor White
        Write-Host "  ai 'your question'      # Ask Claude AI" -ForegroundColor White
        Write-Host "  ai-quick 'question'     # Ask all AI providers" -ForegroundColor White
        Write-Host "  ai-file 'path'          # Comprehensive file analysis" -ForegroundColor White
    }
    
    if (-not $PythonOnly) {
        Write-Host "  security-review         # Security analysis" -ForegroundColor White
        Write-Host "  electronics-design      # Circuit design assistance" -ForegroundColor White
        Write-Host "  generate-tests          # Create unit tests" -ForegroundColor White
        Write-Host "  agent-pipeline          # Run multiple agents" -ForegroundColor White
    }
    
    if (-not $NoVSCode) {
        Write-Host ""
        Write-Host "⌨️ VS Code Integration:" -ForegroundColor Cyan
        Write-Host "  • Keyboard shortcuts for all agents" -ForegroundColor Gray
        Write-Host "  • Global tasks for AI and agents" -ForegroundColor Gray
        Write-Host "  • Code snippets with AI prefixes" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "📚 Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart PowerShell and VS Code" -ForegroundColor White
    Write-Host "  2. Configure API keys (.env files)" -ForegroundColor White
    Write-Host "  3. Try: ai-help" -ForegroundColor White
    Write-Host "  4. Read documentation in Framework folder" -ForegroundColor White
    
    Write-Host ""
    Write-Host "📋 Log file: $($script:Config.LogFile)" -ForegroundColor Gray
    Write-Host ""
}

# Main Installation Logic
function Main {
    Clear-Host
    Write-Host "🚀 AI POWERHOUSE FRAMEWORK INSTALLER v$($script:Config.Version)" -ForegroundColor Blue
    Write-Host "=============================================================" -ForegroundColor Blue
    Write-Host ""
    
    # Initialize log
    "AI Powerhouse Framework Installation Started - $(Get-Date)" | Out-File $script:Config.LogFile -Force
    
    if ($Uninstall) {
        Uninstall-AIPowerhouseFramework
        return
    }
    
    # Show installation plan
    Write-Host "📋 Installation Plan:" -ForegroundColor Cyan
    if (-not $PowerShellOnly) { Write-Host "  ✅ Python AI Powerhouse (Claude, Gemini, OpenAI)" -ForegroundColor Gray }
    if (-not $PythonOnly) { Write-Host "  ✅ Claude Agents System (9 specialized agents)" -ForegroundColor Gray }
    if (-not $PowerShellOnly -and -not $PythonOnly) { Write-Host "  ✅ Cross-system integration" -ForegroundColor Gray }
    if (-not $NoVSCode) { Write-Host "  ✅ VS Code global integration" -ForegroundColor Gray }
    Write-Host "  ✅ Unified PowerShell profile" -ForegroundColor Gray
    Write-Host ""
    
    # Check prerequisites
    if (-not $SkipPrerequisites) {
        if (-not (Test-Prerequisites)) {
            Write-Log "❌ Installation aborted due to missing prerequisites" "ERROR"
            return
        }
    }
    
    Write-Host ""
    Write-Log "🚀 Starting unified installation..."
    
    # Install components
    $success = $true
    $success = $success -and (Install-PythonAI)
    $success = $success -and (Install-ClaudeAgents)
    $success = $success -and (Install-CrossSystemIntegration)
    $success = $success -and (Install-UnifiedVSCode)
    $success = $success -and (Install-UnifiedProfile)
    
    if ($success) {
        Write-Host ""
        Write-Log "🧪 Running installation tests..."
        Test-UnifiedInstallation | Out-Null
        
        Show-InstallationSummary
    } else {
        Write-Log "❌ Installation failed. Check log: $($script:Config.LogFile)" "ERROR"
    }
}

# Run installer
Main