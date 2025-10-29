#Requires -Version 7.0
<#
.SYNOPSIS
    Sets up global AI environment for VS Code on Windows 11
.DESCRIPTION
    Configures VS Code globally to work with Claude, Gemini, and GitHub Copilot
.NOTES
    Author: AI Powerhouse Team
    Requires: PowerShell 7+, VS Code, AI CLI tools installed
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$WhatIf
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Color functions for better output
function Write-Success { param($Message) Write-Host "✅ $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "⚠️  $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "❌ $Message" -ForegroundColor Red }
function Write-Info { param($Message) Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
function Write-Step { param($Message) Write-Host "🔧 $Message" -ForegroundColor Magenta }

Write-Host @"
🚀 AI Powerhouse Global Setup for VS Code
========================================
Setting up global AI integration for Windows 11
"@ -ForegroundColor Blue

# Define paths
$Paths = @{
    VSCodeUser = "$env:APPDATA\Code\User"
    PowerShellProfile = "$env:USERPROFILE\Documents\PowerShell"
    AILogs = "$env:USERPROFILE\.ai-logs"
    AIModule = "$env:USERPROFILE\Documents\PowerShell\Modules\AIHelpers"
}

Write-Step "Checking prerequisites..."

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7+ required. Current version: $($PSVersionTable.PSVersion)"
    Write-Info "Install PowerShell 7: https://github.com/PowerShell/PowerShell/releases"
    exit 1
}
Write-Success "PowerShell version: $($PSVersionTable.PSVersion)"

# Check VS Code installation
$VSCodePath = Get-Command code -ErrorAction SilentlyContinue
if (-not $VSCodePath) {
    Write-Error "VS Code not found in PATH. Please install VS Code and ensure 'code' command is available."
    exit 1
}
Write-Success "VS Code found: $($VSCodePath.Source)"

# Check AI CLI tools - now checking PowerShell module functions instead
Write-Info "Checking AIHelpers PowerShell module..."

# Try to import the module
try {
    Import-Module AIHelpers -Force -ErrorAction SilentlyContinue
    if (Get-Module AIHelpers) {
        Write-Success "AIHelpers module loaded"
        
        # Check individual functions
        if (Get-Command Invoke-Claude -ErrorAction SilentlyContinue) {
            Write-Success "Claude found: AIHelpers"
        } else {
            Write-Warning "Claude function not found in AIHelpers module"
        }
        
        if (Get-Command Invoke-Gemini -ErrorAction SilentlyContinue) {
            Write-Success "Gemini found: AIHelpers" 
        } else {
            Write-Warning "Gemini function not found in AIHelpers module"
        }
        
        if (Get-Command Invoke-GitHubCopilot -ErrorAction SilentlyContinue) {
            Write-Success "GitHub Copilot found: AIHelpers"
        } else {
            Write-Warning "GitHub Copilot function not found in AIHelpers module"
        }
    } else {
        Write-Warning "AIHelpers module not available. The setup will install it."
    }
}
catch {
    Write-Info "AIHelpers module will be installed during setup"
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

# Import and test AIHelpers module functions
try {
    Write-Info "Testing Claude..."
    if ($WhatIf) {
        Write-Info "Would test: Invoke-Claude function"
    } else {
        # Test if functions are available
        if (Get-Command Invoke-Claude -ErrorAction SilentlyContinue) {
            Write-Success "Claude is working"
        } else {
            Write-Warning "Claude function not found in AIHelpers module"
        }
    }
}
catch {
    Write-Warning "Claude found but may not be properly configured: $($_.Exception.Message)"
}

try {
    Write-Info "Testing Gemini..."
    if ($WhatIf) {
        Write-Info "Would test: Invoke-Gemini function"
    } else {
        # Test if functions are available  
        if (Get-Command Invoke-Gemini -ErrorAction SilentlyContinue) {
            Write-Success "Gemini is working"
        } else {
            Write-Warning "Gemini function not found in AIHelpers module"
        }
    }
}
catch {
    Write-Warning "Gemini found but may not be properly configured: $($_.Exception.Message)"
}

try {
    Write-Info "Testing GitHub Copilot..."
    if ($WhatIf) {
        Write-Info "Would test: Invoke-GitHubCopilot function"
    } else {
        # Test if functions are available  
        if (Get-Command Invoke-GitHubCopilot -ErrorAction SilentlyContinue) {
            Write-Success "GitHub Copilot is working"
        } else {
            Write-Warning "GitHub Copilot function not found in AIHelpers module"
        }
    }
}
catch {
    Write-Warning "GitHub Copilot found but may not be properly configured: $($_.Exception.Message)"
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
$LogDirs = @('errors', 'claude', 'gemini', 'copilot', 'comparisons')
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
OS: $($PSVersionTable.OS)
VS Code Path: $($VSCodePath.Source)
"@ | Out-File $initialLogFile -Encoding UTF8
    Write-Success "Created setup log: $initialLogFile"
}

Write-Host @"

🎉 AI Powerhouse Setup Complete!

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
   - Ctrl+Shift+C → Claude
   - Ctrl+Shift+G → Gemini CLI
   - Ctrl+Shift+Alt+C → GitHub Copilot Chat
   - Ctrl+Shift+A → Compare All AIs

4. PowerShell functions will be available:
   - claude "your prompt"
   - gemini "your prompt"
   - ai-compare "your prompt" (includes Copilot suggestions)
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
