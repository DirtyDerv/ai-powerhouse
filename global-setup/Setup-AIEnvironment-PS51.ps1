#Requires -Version 5.1
<#
.SYNOPSIS
    Sets up global AI environment for VS Code on Windows 11 (PowerShell 5.1 Compatible)
.DESCRIPTION
    Configures VS Code globally to work with Claude and Gemini CLI tools
.NOTES
    Author: AI Powerhouse Team
    Compatible with: PowerShell 5.1+
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$WhatIf
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Color functions for better output (PowerShell 5.1 compatible)
function Write-Success { param($Message) Write-Host "✅ $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "⚠️  $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "❌ $Message" -ForegroundColor Red }
function Write-Info { param($Message) Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
function Write-Step { param($Message) Write-Host "🔧 $Message" -ForegroundColor Magenta }

Write-Host @"
🚀 AI Powerhouse Global Setup for VS Code (PowerShell 5.1)
=========================================================
Setting up global AI integration for Windows 11
"@ -ForegroundColor Blue

# Define paths
$Paths = @{
    VSCodeUser = "$env:APPDATA\Code\User"
    PowerShellProfile = "$env:USERPROFILE\Documents\WindowsPowerShell"
    AILogs = "$env:USERPROFILE\.ai-logs"
    AIModule = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\AIHelpers"
}

Write-Step "Checking prerequisites..."

# Check PowerShell version
Write-Success "PowerShell version: $($PSVersionTable.PSVersion) (Windows PowerShell)"

# Check VS Code installation
$VSCodePath = Get-Command code -ErrorAction SilentlyContinue
if (-not $VSCodePath) {
    Write-Error "VS Code not found in PATH. Please install VS Code and ensure 'code' command is available."
    exit 1
}
Write-Success "VS Code found: $($VSCodePath.Source)"

# Check AI CLI tools
$AITools = @{
    'Claude' = 'claude'
    'Gemini' = 'gemini'
}

$MissingTools = @()
foreach ($tool in $AITools.GetEnumerator()) {
    $command = Get-Command $tool.Value -ErrorAction SilentlyContinue
    if ($command) {
        Write-Success "$($tool.Key) found: $($command.Source)"
    } else {
        Write-Warning "$($tool.Key) command '$($tool.Value)' not found in PATH"
        $MissingTools += $tool.Key
    }
}

if ($MissingTools.Count -gt 0) {
    Write-Warning "Missing AI tools: $($MissingTools -join ', ')"
    Write-Info "The setup will continue, but these tools won't work until installed."
    if (-not $Force) {
        $continue = Read-Host "Continue anyway? (y/N)"
        if ($continue -ne 'y' -and $continue -ne 'Y') {
            Write-Info "Setup cancelled. Install missing tools and run again."
            exit 0
        }
    }
}

Write-Step "Creating directory structure..."

# Create directories
foreach ($path in $Paths.Values) {
    if (-not (Test-Path $path)) {
        if ($WhatIf) {
            Write-Info "Would create: $path"
        } else {
            New-Item -Path $path -ItemType Directory -Force | Out-Null
            Write-Success "Created: $path"
        }
    } else {
        Write-Success "Exists: $path"
    }
}

# Create subdirectories for AI module
$ModuleSubDirs = @('Functions', 'Data')
foreach ($subDir in $ModuleSubDirs) {
    $fullPath = Join-Path $Paths.AIModule $subDir
    if (-not (Test-Path $fullPath)) {
        if ($WhatIf) {
            Write-Info "Would create: $fullPath"
        } else {
            New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
            Write-Success "Created: $fullPath"
        }
    }
}

Write-Step "Testing AI tools..."

# Test each AI tool with a simple command
foreach ($tool in $AITools.GetEnumerator()) {
    $command = Get-Command $tool.Value -ErrorAction SilentlyContinue
    if ($command) {
        try {
            Write-Info "Testing $($tool.Key)..."
            if ($WhatIf) {
                Write-Info "Would test: $($tool.Value) --version"
            } else {
                # Try to get version or help
                try {
                    $result = & $tool.Value --version 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Success "$($tool.Key) is working"
                    } else {
                        # Try help instead
                        $result = & $tool.Value --help 2>&1
                        Write-Success "$($tool.Key) is available (version check failed)"
                    }
                }
                catch {
                    Write-Success "$($tool.Key) is available (testing failed)"
                }
            }
        }
        catch {
            Write-Warning "$($tool.Key) found but may not be properly configured: $($_.Message)"
        }
    }
}

Write-Step "Checking VS Code configuration..."

# Check if VS Code user directory exists and is writable
if (Test-Path $Paths.VSCodeUser) {
    try {
        $testFile = Join-Path $Paths.VSCodeUser "test-write.tmp"
        if (-not $WhatIf) {
            "test" | Out-File $testFile -ErrorAction Stop
            Remove-Item $testFile -ErrorAction SilentlyContinue
        }
        Write-Success "VS Code user directory is writable"
    }
    catch {
        Write-Error "Cannot write to VS Code user directory: $($Paths.VSCodeUser)"
        Write-Info "Try running VS Code as administrator or check permissions"
        exit 1
    }
} else {
    Write-Warning "VS Code user directory not found. VS Code may not have been run yet."
    Write-Info "Please start VS Code at least once, then run this setup again."
}

Write-Step "Setting up PowerShell execution policy..."

# Check current execution policy
$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'AllSigned') {
    Write-Warning "Current execution policy: $currentPolicy"
    if (-not $WhatIf) {
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Success "Set execution policy to RemoteSigned for current user"
        }
        catch {
            Write-Warning "Could not change execution policy: $($_.Message)"
            Write-Info "You may need to run PowerShell as administrator to change execution policy"
        }
    } else {
        Write-Info "Would set execution policy to RemoteSigned"
    }
} else {
    Write-Success "Execution policy is suitable: $currentPolicy"
}

Write-Step "Creating log structure..."

# Create log directories
$LogDirs = @('errors', 'claude', 'gemini', 'comparisons')
foreach ($logDir in $LogDirs) {
    $fullPath = Join-Path $Paths.AILogs $logDir
    if (-not (Test-Path $fullPath)) {
        if ($WhatIf) {
            Write-Info "Would create log directory: $fullPath"
        } else {
            New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
            Write-Success "Created log directory: $logDir"
        }
    }
}

# Create initial log file
$initialLogFile = Join-Path $Paths.AILogs "setup.log"
if (-not $WhatIf) {
    @"
AI Powerhouse Setup Log
Setup completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
PowerShell Version: $($PSVersionTable.PSVersion)
OS: Windows PowerShell 5.1
VS Code Path: $($VSCodePath.Source)
"@ | Out-File $initialLogFile -Encoding UTF8
    Write-Success "Created setup log: $initialLogFile"
}

Write-Host @"

🎉 AI Powerhouse Setup Complete!

⚠️  IMPORTANT NOTES FOR POWERSHELL 5.1:
- You're using Windows PowerShell 5.1
- Some advanced features require PowerShell 7+
- Consider upgrading: winget install Microsoft.PowerShell

Next Steps:
1. Files will be created by Copilot in the following locations:
   📁 $($Paths.VSCodeUser)
   📁 $($Paths.PowerShellProfile)
   📁 $($Paths.AIModule)

2. After Copilot creates all files:
   - Restart VS Code: Ctrl+Shift+P → "Developer: Reload Window"
   - Open a new PowerShell terminal in VS Code
   - Test with: ai-compare "hello world"

3. Keyboard shortcuts will be available:
   - Ctrl+Shift+C → Claude Code
   - Ctrl+Shift+G → Gemini CLI  
   - Ctrl+Shift+A → Compare All AIs

4. PowerShell functions will be available:
   - claude "your prompt"
   - gemini "your prompt"
   - gpt "your prompt"
   - ai-compare "your prompt"

5. All AI interactions will be logged to: $($Paths.AILogs)

"@ -ForegroundColor Green

if ($MissingTools.Count -gt 0) {
    Write-Host @"
⚠️  Missing AI Tools:
$($MissingTools | ForEach-Object { "   - $_" })

Install these tools to enable full functionality.
"@ -ForegroundColor Yellow
}

Write-Host "✨ Ready for Copilot to create the remaining configuration files!" -ForegroundColor Magenta
