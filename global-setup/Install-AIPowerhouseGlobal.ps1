# Master AI Powerhouse Global Setup
# This script configures AI Powerhouse as the default framework for all development

param(
    [switch]$PowerShellProfile,
    [switch]$VSCodeGlobal,
    [switch]$ProjectTemplates,
    [switch]$All
)

$AIPowerhousePath = "c:\Users\woody\OneDrive\Documents\ai powerhouse"

if ($All) {
    $PowerShellProfile = $true
    $VSCodeGlobal = $true 
    $ProjectTemplates = $true
}

Write-Host "🚀 AI Powerhouse Global Configuration Setup" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor DarkGray
Write-Host ""

# 1. PowerShell Profile Integration
if ($PowerShellProfile) {
    Write-Host "⚙️ Setting up PowerShell Profile Integration..." -ForegroundColor Yellow
    
    $profilePath = $PROFILE.AllUsersAllHosts
    $profileDir = Split-Path $profilePath -Parent
    
    # Ensure profile directory exists
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    # Create or update PowerShell profile
    $aiProfileContent = @"
# AI Powerhouse Global Integration
# Auto-loaded for all PowerShell sessions

`$AIPowerhousePath = "$AIPowerhousePath"
`$GlobalProfileScript = Join-Path `$AIPowerhousePath "global-setup\AI-Powerhouse-Global-Profile.ps1"

if (Test-Path `$GlobalProfileScript) {
    try {
        . `$GlobalProfileScript
    } catch {
        Write-Warning "Failed to load AI Powerhouse global profile: `$_"
    }
} else {
    Write-Warning "AI Powerhouse global profile not found at: `$GlobalProfileScript"
}
"@
    
    if (Test-Path $profilePath) {
        $existingContent = Get-Content $profilePath -Raw
        if ($existingContent -notmatch "AI Powerhouse Global Integration") {
            Add-Content -Path $profilePath -Value "`n$aiProfileContent"
            Write-Host "✅ PowerShell profile updated" -ForegroundColor Green
        } else {
            Write-Host "✅ PowerShell profile already configured" -ForegroundColor Green
        }
    } else {
        $aiProfileContent | Out-File -FilePath $profilePath -Encoding UTF8
        Write-Host "✅ PowerShell profile created with AI Powerhouse integration" -ForegroundColor Green
    }
    
    Write-Host "   📝 Profile location: $profilePath" -ForegroundColor Gray
}

# 2. VS Code Global Configuration
if ($VSCodeGlobal) {
    Write-Host "⚙️ Setting up VS Code Global Configuration..." -ForegroundColor Yellow
    
    $vscodeUserDir = "$env:APPDATA\Code\User"
    $vscodeSettingsPath = Join-Path $vscodeUserDir "settings.json"
    $vscodeKeybindingsPath = Join-Path $vscodeUserDir "keybindings.json"
    $vscodeSnippetsDir = Join-Path $vscodeUserDir "snippets"
    
    # Ensure VS Code user directory exists
    if (-not (Test-Path $vscodeUserDir)) {
        New-Item -ItemType Directory -Path $vscodeUserDir -Force | Out-Null
    }
    
    if (-not (Test-Path $vscodeSnippetsDir)) {
        New-Item -ItemType Directory -Path $vscodeSnippetsDir -Force | Out-Null
    }
    
    # Copy AI Powerhouse settings
    $sourceSettings = Join-Path $AIPowerhousePath "global-setup\vscode-ai-powerhouse-settings.json"
    
    if (Test-Path $sourceSettings) {
        if (Test-Path $vscodeSettingsPath) {
            Write-Host "   📋 Backing up existing VS Code settings..." -ForegroundColor Gray
            Copy-Item $vscodeSettingsPath "$vscodeSettingsPath.backup" -Force
        }
        
        # Merge with existing settings
        $sourceSettingsContent = Get-Content $sourceSettings -Raw | ConvertFrom-Json
        
        if (Test-Path $vscodeSettingsPath) {
            $existingSettings = Get-Content $vscodeSettingsPath -Raw | ConvertFrom-Json
            
            # Merge settings
            foreach ($property in $sourceSettingsContent.PSObject.Properties) {
                $existingSettings | Add-Member -Name $property.Name -Value $property.Value -Force
            }
            
            $existingSettings | ConvertTo-Json -Depth 10 | Out-File $vscodeSettingsPath -Encoding UTF8
        } else {
            Copy-Item $sourceSettings $vscodeSettingsPath -Force
        }
        
        Write-Host "✅ VS Code settings configured with AI Powerhouse defaults" -ForegroundColor Green
    }
    
    # Copy keybindings
    $sourceKeybindings = Join-Path $AIPowerhousePath "global-setup\keybindings.json"
    if (Test-Path $sourceKeybindings) {
        Copy-Item $sourceKeybindings $vscodeKeybindingsPath -Force
        Write-Host "✅ VS Code keybindings configured with AI shortcuts" -ForegroundColor Green
    }
    
    # Copy code snippets
    $sourceSnippets = Join-Path $AIPowerhousePath "global-setup\*.code-snippets"
    $snippetFiles = Get-ChildItem $sourceSnippets -ErrorAction SilentlyContinue
    
    foreach ($snippetFile in $snippetFiles) {
        Copy-Item $snippetFile.FullName $vscodeSnippetsDir -Force
        Write-Host "✅ Code snippets: $($snippetFile.Name)" -ForegroundColor Green
    }
}

# 3. Project Templates
if ($ProjectTemplates) {
    Write-Host "⚙️ Setting up Project Templates..." -ForegroundColor Yellow
    
    # Add to PATH for global access
    $currentPath = $env:PATH
    $globalSetupPath = Join-Path $AIPowerhousePath "global-setup"
    
    if ($currentPath -notlike "*$globalSetupPath*") {
        $newPath = "$currentPath;$globalSetupPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "✅ AI Powerhouse tools added to PATH" -ForegroundColor Green
    } else {
        Write-Host "✅ AI Powerhouse tools already in PATH" -ForegroundColor Green
    }
    
    # Create desktop shortcuts
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    
    $shortcutScript = @"
# AI Powerhouse Quick Start
`$projectName = Read-Host "Enter project name"
`$projectType = Read-Host "Enter project type (Python/PowerShell/JavaScript/Mixed)"

& "$globalSetupPath\New-AIPoweredProject.ps1" -ProjectName `$projectName -ProjectType `$projectType
"@
    
    $shortcutPath = Join-Path $desktopPath "New AI Project.ps1"
    $shortcutScript | Out-File $shortcutPath -Encoding UTF8
    
    Write-Host "✅ Desktop shortcut created: New AI Project.ps1" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 AI Powerhouse Global Configuration Complete!" -ForegroundColor Green
Write-Host ""

Write-Host "📋 What's Configured:" -ForegroundColor Yellow
if ($PowerShellProfile) {
    Write-Host "   ✅ PowerShell Profile: AI Powerhouse auto-loaded in all sessions" -ForegroundColor White
}
if ($VSCodeGlobal) {
    Write-Host "   ✅ VS Code Global: AI shortcuts, settings, and snippets" -ForegroundColor White  
}
if ($ProjectTemplates) {
    Write-Host "   ✅ Project Templates: Quick AI-powered project creation" -ForegroundColor White
}

Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Restart PowerShell to load AI Powerhouse" -ForegroundColor White
Write-Host "   2. Restart VS Code to apply global settings" -ForegroundColor White
Write-Host "   3. Type 'ai-help' for available commands" -ForegroundColor White
Write-Host "   4. Use 'New-AIPoweredProject' to create AI-enhanced projects" -ForegroundColor White
Write-Host ""

Write-Host "🤖 Available Commands (after restart):" -ForegroundColor Yellow
Write-Host "   ai-help                    - Show all AI commands" -ForegroundColor Cyan
Write-Host "   setup-ai-project           - Add AI to current project" -ForegroundColor Cyan
Write-Host "   New-AIPoweredProject       - Create new AI-powered project" -ForegroundColor Cyan
Write-Host "   security-review <file>     - Security analysis" -ForegroundColor Cyan
Write-Host "   code-review <file>         - Code quality review" -ForegroundColor Cyan
Write-Host "   generate-tests <file>      - Test generation" -ForegroundColor Cyan
Write-Host "   database-optimize <query>  - Database optimization" -ForegroundColor Cyan
Write-Host "   research-topic <topic>     - Research assistance" -ForegroundColor Cyan
Write-Host "   n8n-workflow <desc>        - Automation workflows" -ForegroundColor Cyan
Write-Host ""

Write-Host "🔗 GitHub Repository: " -NoNewline -ForegroundColor Gray
Write-Host "https://github.com/DirtyDerv/ai-powerhouse" -ForegroundColor Blue
Write-Host ""