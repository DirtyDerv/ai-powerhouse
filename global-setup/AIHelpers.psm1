# AIHelpers PowerShell Module
# Global AI integration for VS Code on Windows 11

#Requires -Version 7.0

# Set strict mode for better error handling
Set-StrictMode -Version Latest

# Module variables
$script:ModuleRoot = $PSScriptRoot
$script:LogPath = "$env:USERPROFILE\.ai-logs"
$script:ConfigPath = Join-Path $script:LogPath "config.json"

# Ensure log directory exists
if (-not (Test-Path $script:LogPath)) {
    New-Item -Path $script:LogPath -ItemType Directory -Force | Out-Null
}

# Color output functions
function Write-AISuccess { param($Message) Write-Host "✅ $Message" -ForegroundColor Green }
function Write-AIWarning { param($Message) Write-Host "⚠️  $Message" -ForegroundColor Yellow }
function Write-AIError { param($Message) Write-Host "❌ $Message" -ForegroundColor Red }
function Write-AIInfo { param($Message) Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
function Write-AIResult { param($Message, $Color = 'White') Write-Host $Message -ForegroundColor $Color }

# Import all function files
$FunctionPath = Join-Path $script:ModuleRoot "Functions"
if (Test-Path $FunctionPath) {
    Get-ChildItem -Path $FunctionPath -Filter "*.ps1" | ForEach-Object {
        try {
            . $_.FullName
        }
        catch {
            Write-Warning "Failed to import function from $($_.Name): $($_.Exception.Message)"
        }
    }
}

# Main AI functions that will be available globally

function Invoke-ClaudeCode {
    <#
    .SYNOPSIS
        Invokes Claude Code CLI with the specified prompt
    .PARAMETER Prompt
        The prompt to send to Claude Code
    .PARAMETER File
        Optional file path to analyze
    .PARAMETER LogResult
        Whether to log the result (default: true)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Prompt,
        
        [Parameter()]
        [string]$File,
        
        [Parameter()]
        [switch]$LogResult = $true
    )
    
    try {
        Write-AIInfo "🔵 Claude Code: Processing prompt..."
        
        # Build command
        $cmd = "claude"
        $args = @()
        
        if ($File -and (Test-Path $File)) {
            $args += "--file", "`"$File`""
        }
        
        $args += "`"$Prompt`""
        
        # Execute command
        $result = & $cmd @args 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-AIResult $result -Color Blue
            
            if ($LogResult) {
                Write-AILog -Tool "claude" -Prompt $Prompt -Result $result -File $File
            }
            
            return $result
        }
        else {
            $errorMsg = "Claude Code failed with exit code $LASTEXITCODE`: $result"
            Write-AIError $errorMsg
            
            if ($LogResult) {
                Write-AILog -Tool "claude" -Prompt $Prompt -Result $errorMsg -File $File -IsError
            }
            
            return $errorMsg
        }
    }
    catch {
        $errorMsg = "Failed to execute Claude Code: $($_.Exception.Message)"
        Write-AIError $errorMsg
        
        if ($LogResult) {
            Write-AILog -Tool "claude" -Prompt $Prompt -Result $errorMsg -File $File -IsError
        }
        
        return $errorMsg
    }
}

function Invoke-GeminiCLI {
    <#
    .SYNOPSIS
        Invokes Gemini CLI with the specified prompt
    .PARAMETER Prompt
        The prompt to send to Gemini
    .PARAMETER File
        Optional file path to analyze
    .PARAMETER LogResult
        Whether to log the result (default: true)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Prompt,
        
        [Parameter()]
        [string]$File,
        
        [Parameter()]
        [switch]$LogResult = $true
    )
    
    try {
        Write-AIInfo "🟢 Gemini: Processing prompt..."
        
        # Build command
        $cmd = "gemini"
        $args = @()
        
        if ($File -and (Test-Path $File)) {
            $args += "--file", "`"$File`""
        }
        
        $args += "`"$Prompt`""
        
        # Execute command
        $result = & $cmd @args 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-AIResult $result -Color Green
            
            if ($LogResult) {
                Write-AILog -Tool "gemini" -Prompt $Prompt -Result $result -File $File
            }
            
            return $result
        }
        else {
            $errorMsg = "Gemini CLI failed with exit code $LASTEXITCODE`: $result"
            Write-AIError $errorMsg
            
            if ($LogResult) {
                Write-AILog -Tool "gemini" -Prompt $Prompt -Result $errorMsg -File $File -IsError
            }
            
            return $errorMsg
        }
    }
    catch {
        $errorMsg = "Failed to execute Gemini CLI: $($_.Exception.Message)"
        Write-AIError $errorMsg
        
        if ($LogResult) {
            Write-AILog -Tool "gemini" -Prompt $Prompt -Result $errorMsg -File $File -IsError
        }
        
        return $errorMsg
    }
}

function Invoke-GitHubCopilot {
    <#
    .SYNOPSIS
        Integrates GitHub Copilot suggestions and commands into the AI workflow
    .PARAMETER Prompt
        The prompt or task for GitHub Copilot
    .PARAMETER File
        Optional file path to analyze
    .PARAMETER Action
        The type of Copilot action to perform
    .PARAMETER LogResult
        Whether to log the result (default: true)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Prompt,
        
        [Parameter()]
        [string]$File,
        
        [Parameter()]
        [ValidateSet('chat', 'explain', 'generate', 'fix', 'optimize', 'test')]
        [string]$Action = 'chat',
        
        [Parameter()]
        [switch]$LogResult = $true
    )
    
    try {
        Write-AIInfo "🤖 GitHub Copilot: Processing with $Action action..."
        
        $copilotResult = switch ($Action) {
            'chat' {
                "💬 GitHub Copilot Chat Integration
                
🎯 Prompt: $Prompt
                
📝 Suggested Workflow:
1. Open GitHub Copilot Chat (Ctrl+Shift+I)
2. Ask: '$Prompt'
3. Review inline suggestions as you type
4. Use Copilot's context-aware completions

💡 Pro Tips:
• Copilot excels at code completion and real-time suggestions
• Try typing comments describing what you want - Copilot will suggest code
• Use Copilot Chat for explanations and architectural discussions
• Leverage Copilot's IDE integration for seamless development

🔄 For comparison with Claude/Gemini:
• Copilot: Real-time, context-aware, IDE-integrated
• Claude: Deep analysis, comprehensive responses  
• Gemini: Fast iteration, creative solutions"
            }
            
            'explain' {
                if ($File -and (Test-Path $File)) {
                    "🔍 GitHub Copilot Code Explanation
                    
📁 File: $File
🎯 Analysis Request: $Prompt

🚀 Recommended Actions:
1. Open the file in VS Code
2. Select the code you want explained
3. Right-click → 'Copilot: Explain This'
4. Or use Ctrl+I and ask: 'Explain this code: $Prompt'

💡 Copilot's Explanation Strengths:
• Line-by-line code breakdown
• Function and class documentation
• Algorithm explanation with examples
• Integration context within your project"
                } else {
                    "⚠️ File not provided or doesn't exist. Please specify a valid file path for code explanation."
                }
            }
            
            'generate' {
                "⚡ GitHub Copilot Code Generation
                
🎯 Generation Request: $Prompt

🛠️ Copilot Generation Workflow:
1. Create a new file or open existing one
2. Write a comment: // $Prompt
3. Press Enter - Copilot will suggest implementation
4. Use Tab to accept, Ctrl+Right to accept word-by-word
5. Use Ctrl+Enter to see alternative suggestions

🎨 Enhanced Generation Tips:
• Be specific in comments: // Create a REST API endpoint for user authentication
• Use function signatures: // function calculateTax(income, deductions)
• Describe edge cases: // Handle null values and empty arrays
• Request specific patterns: // Use async/await pattern"
            }
            
            'fix' {
                "🔧 GitHub Copilot Code Fixing
                
🎯 Fix Request: $Prompt
                
🚨 Copilot Fix Workflow:
1. Highlight problematic code
2. Ctrl+I → Ask: 'Fix this: $Prompt'
3. Or right-click → 'Copilot: Fix This'
4. Review suggested fixes in real-time
5. Use ghost text suggestions as you edit

🛡️ Copilot Fix Strengths:
• Real-time error detection
• Syntax and logic corrections  
• Performance optimizations
• Best practice suggestions
• IDE integration with error highlights"
            }
            
            'optimize' {
                "⚡ GitHub Copilot Code Optimization
                
🎯 Optimization Focus: $Prompt

🚀 Optimization Strategy:
1. Select code block to optimize
2. Ctrl+I → 'Optimize this code for: $Prompt'
3. Consider Copilot's inline suggestions while refactoring
4. Use comment-driven optimization: // TODO: Optimize for performance

🎯 Copilot Optimization Areas:
• Performance improvements
• Memory usage reduction
• Code readability enhancement
• Modern syntax adoption
• Design pattern implementation"
            }
            
            'test' {
                "🧪 GitHub Copilot Test Generation
                
🎯 Test Requirements: $Prompt
                
✅ Copilot Testing Workflow:
1. Open test file or create new one
2. Write: // Test for: $Prompt
3. Copilot suggests test structure and cases
4. Use naming conventions for better suggestions
5. Leverage Copilot's framework knowledge

🔬 Test Generation Strengths:
• Framework-specific test patterns
• Edge case identification
• Mock and stub generation
• Assertion suggestions
• Test data creation"
            }
        }
        
        Write-AIResult $copilotResult -Color Cyan
        
        if ($LogResult) {
            Write-AILog -Tool "copilot" -Prompt "$Action`: $Prompt" -Result $copilotResult -File $File
        }
        
        return $copilotResult
    }
    catch {
        $errorMsg = "Failed to process GitHub Copilot action: $($_.Exception.Message)"
        Write-AIError $errorMsg
        
        if ($LogResult) {
            Write-AILog -Tool "copilot" -Prompt "$Action`: $Prompt" -Result $errorMsg -File $File -IsError
        }
        
        return $errorMsg
    }
}

function Compare-AIResponses {
    <#
    .SYNOPSIS
        Compares responses from Claude, Gemini, and GitHub Copilot
    .PARAMETER Prompt
        The prompt to send to all AI tools
    .PARAMETER File
        Optional file path to analyze
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Prompt,
        
        [Parameter()]
        [string]$File
    )
    
    Write-Host "`n🤖 AI Comparison: Running prompt on Claude, Gemini, and GitHub Copilot..." -ForegroundColor Magenta
    Write-Host "Prompt: $Prompt" -ForegroundColor White
    Write-Host ("=" * 80) -ForegroundColor Gray
    
    $results = @{}
    
    # Claude
    Write-Host "`n🔵 CLAUDE CODE" -ForegroundColor Blue
    Write-Host ("-" * 40) -ForegroundColor Blue
    $results.Claude = Invoke-ClaudeCode -Prompt $Prompt -File $File -LogResult:$false
    
    # Gemini
    Write-Host "`n🟢 GEMINI CLI" -ForegroundColor Green  
    Write-Host ("-" * 40) -ForegroundColor Green
    $results.Gemini = Invoke-GeminiCLI -Prompt $Prompt -File $File -LogResult:$false
    
    # GitHub Copilot
    Write-Host "`n🤖 GITHUB COPILOT" -ForegroundColor Cyan
    Write-Host ("-" * 40) -ForegroundColor Cyan
    $results.Copilot = Invoke-GitHubCopilot -Prompt $Prompt -File $File -Action 'chat' -LogResult:$false
    
    # Log comparison
    $comparisonLog = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        prompt = $Prompt
        file = $File
        results = $results
    }
    
    $logFile = Join-Path "$script:LogPath\comparisons" "comparison-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    $comparisonLog | ConvertTo-Json -Depth 10 | Out-File $logFile -Encoding UTF8
    
    Write-Host "`n📊 Comparison complete! Logged to: $logFile" -ForegroundColor Magenta
    
    return $results
}

function Write-AILog {
    <#
    .SYNOPSIS
        Logs AI interactions to file
    .PARAMETER Tool
        The AI tool used (claude, gemini, copilot)
    .PARAMETER Prompt
        The prompt sent
    .PARAMETER Result
        The result received
    .PARAMETER File
        Optional file that was analyzed
    .PARAMETER IsError
        Whether this was an error
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('claude', 'gemini', 'copilot')]
        [string]$Tool,
        
        [Parameter(Mandatory = $true)]
        [string]$Prompt,
        
        [Parameter(Mandatory = $true)]
        [string]$Result,
        
        [Parameter()]
        [string]$File,
        
        [Parameter()]
        [switch]$IsError
    )
    
    try {
        $logEntry = @{
            timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            tool = $Tool
            prompt = $Prompt
            result = $Result
            file = $File
            isError = $IsError.IsPresent
            workingDirectory = Get-Location | Select-Object -ExpandProperty Path
        }
        
        $logDir = Join-Path $script:LogPath $Tool
        if (-not (Test-Path $logDir)) {
            New-Item -Path $logDir -ItemType Directory -Force | Out-Null
        }
        
        $logFile = Join-Path $logDir "$(Get-Date -Format 'yyyy-MM-dd').json"
        
        # Read existing log or create new array
        $logs = @()
        if (Test-Path $logFile) {
            try {
                $existingContent = Get-Content $logFile -Raw -ErrorAction SilentlyContinue
                if ($existingContent) {
                    $logs = $existingContent | ConvertFrom-Json
                }
            }
            catch {
                # If file is corrupted, start fresh
                $logs = @()
            }
        }
        
        # Add new entry
        $logs += $logEntry
        
        # Keep only last 100 entries per day
        if ($logs.Count -gt 100) {
            $logs = $logs | Select-Object -Last 100
        }
        
        # Save log
        $logs | ConvertTo-Json -Depth 10 | Out-File $logFile -Encoding UTF8
    }
    catch {
        Write-Warning "Failed to write AI log: $($_.Exception.Message)"
    }
}

# Convenience aliases and functions
function claude { 
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0)][string]$Prompt, [string]$File)
    Invoke-ClaudeCode -Prompt $Prompt -File $File
}

function gemini { 
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0)][string]$Prompt, [string]$File)
    Invoke-GeminiCLI -Prompt $Prompt -File $File
}

function copilot { 
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)][string]$Prompt, 
        [string]$File,
        [ValidateSet('chat', 'explain', 'generate', 'fix', 'optimize', 'test')]
        [string]$Action = 'chat'
    )
    Invoke-GitHubCopilot -Prompt $Prompt -File $File -Action $Action
}

function ai-compare { 
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0)][string]$Prompt, [string]$File)
    Compare-AIResponses -Prompt $Prompt -File $File
}

function ai-implement {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0)][string]$Prompt)
    
    Write-Host "🔄 AI Implementation Pipeline" -ForegroundColor Magenta
    Write-Host "1. Claude will implement the solution" -ForegroundColor Blue
    Write-Host "2. Gemini will review the implementation" -ForegroundColor Green
    Write-Host ("-" * 50) -ForegroundColor Gray
    
    $implementation = claude "Implement this requirement: $Prompt. Provide complete, working code with comments."
    
    Write-Host "`n🔍 Review Phase:" -ForegroundColor Green
    $review = gemini "Review this implementation and suggest improvements: $implementation"
    
    return @{
        Implementation = $implementation
        Review = $review
    }
}

function ai-review {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0)][string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-AIError "File not found: $FilePath"
        return
    }
    
    Write-Host "🔍 AI Code Review Pipeline" -ForegroundColor Magenta
    Write-Host "Analyzing file: $FilePath" -ForegroundColor White
    Write-Host ("-" * 50) -ForegroundColor Gray
    
    $results = @{}
    
    Write-Host "`n🔵 Claude Analysis:" -ForegroundColor Blue
    $results.Claude = claude "Please review this code for bugs, performance issues, and best practices" -File $FilePath
    
    Write-Host "`n🟢 Gemini Analysis:" -ForegroundColor Green
    $results.Gemini = gemini "Please analyze this code for security vulnerabilities and maintainability" -File $FilePath
    
    Write-Host "`n🤖 GitHub Copilot Analysis:" -ForegroundColor Cyan
    $results.Copilot = copilot "Code review and refactoring suggestions" -File $FilePath -Action 'optimize'
    
    return $results
}

function ai-pipeline {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, Position=0)][string]$Prompt)
    
    Write-Host "🚀 Full AI Pipeline" -ForegroundColor Magenta
    Write-Host "Prompt: $Prompt" -ForegroundColor White
    Write-Host ("=" * 60) -ForegroundColor Gray
    
    # Step 1: Implementation
    Write-Host "`n📝 Step 1: Implementation (Claude)" -ForegroundColor Blue
    $implementation = claude "Implement: $Prompt. Provide complete, production-ready code."
    
    # Step 2: Review
    Write-Host "`n🔍 Step 2: Review (Gemini)" -ForegroundColor Green
    $review = gemini "Review this implementation for bugs, security, and best practices: $implementation"
    
    # Step 3: GitHub Copilot Enhancement
    Write-Host "`n🤖 Step 3: Enhancement (GitHub Copilot)" -ForegroundColor Cyan
    $enhancement = copilot "Optimize and enhance this implementation: $implementation" -Action 'optimize'
    
    return @{
        Prompt = $Prompt
        Implementation = $implementation
        Review = $review
        Enhancement = $enhancement
        Timestamp = Get-Date
    }
}

function ai-log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('claude', 'gemini', 'copilot', 'comparisons')]
        [string]$Tool = 'all',
        
        [Parameter()]
        [int]$Last = 10
    )
    
    if ($Tool -eq 'all') {
        Write-Host "📋 Recent AI Activity (Last $Last entries)" -ForegroundColor Magenta
        
        $allLogs = @()
        foreach ($toolDir in @('claude', 'gemini', 'copilot')) {
            $toolPath = Join-Path $script:LogPath $toolDir
            if (Test-Path $toolPath) {
                Get-ChildItem $toolPath -Filter "*.json" | ForEach-Object {
                    try {
                        $content = Get-Content $_.FullName -Raw | ConvertFrom-Json
                        $allLogs += $content
                    }
                    catch {
                        Write-Warning "Could not read log file: $($_.FullName)"
                    }
                }
            }
        }
        
        $allLogs | Sort-Object timestamp -Descending | Select-Object -First $Last | ForEach-Object {
            $color = switch ($_.tool) {
                'claude' { 'Blue' }
                'gemini' { 'Green' }
                'copilot' { 'Cyan' }
                default { 'White' }
            }
            
            Write-Host "`n[$($_.timestamp)] $($_.tool.ToUpper())" -ForegroundColor $color
            Write-Host "Prompt: $($_.prompt)" -ForegroundColor Gray
            if ($_.isError) {
                Write-Host "ERROR: $($_.result)" -ForegroundColor Red
            } else {
                Write-Host "Result: $($_.result.Substring(0, [Math]::Min(100, $_.result.Length)))..." -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "📋 Recent $($Tool.ToUpper()) Activity" -ForegroundColor Magenta
        # Implementation for specific tool logs
    }
}

function ai-history {
    [CmdletBinding()]
    param([int]$Days = 7)
    
    Write-Host "📊 AI Usage History (Last $Days days)" -ForegroundColor Magenta
    
    $stats = @{
        claude = 0
        gemini = 0
        copilot = 0
        comparisons = 0
        errors = 0
    }
    
    $cutoffDate = (Get-Date).AddDays(-$Days)
    
    foreach ($tool in @('claude', 'gemini', 'copilot')) {
        $toolPath = Join-Path $script:LogPath $tool
        if (Test-Path $toolPath) {
            Get-ChildItem $toolPath -Filter "*.json" | ForEach-Object {
                try {
                    $content = Get-Content $_.FullName -Raw | ConvertFrom-Json
                    foreach ($entry in $content) {
                        $entryDate = [DateTime]::Parse($entry.timestamp)
                        if ($entryDate -gt $cutoffDate) {
                            $stats[$tool]++
                            if ($entry.isError) {
                                $stats.errors++
                            }
                        }
                    }
                }
                catch {
                    # Skip corrupted files
                }
            }
        }
    }
    
    # Count comparisons
    $comparisonsPath = Join-Path $script:LogPath "comparisons"
    if (Test-Path $comparisonsPath) {
        $stats.comparisons = (Get-ChildItem $comparisonsPath -Filter "*.json" | Where-Object { 
            $_.CreationTime -gt $cutoffDate 
        }).Count
    }
    
    Write-Host "`nUsage Statistics:" -ForegroundColor White
    Write-Host "🔵 Claude Code: $($stats.claude) requests" -ForegroundColor Blue
    Write-Host "🟢 Gemini: $($stats.gemini) requests" -ForegroundColor Green
    Write-Host "🤖 GitHub Copilot: $($stats.copilot) requests" -ForegroundColor Cyan
    Write-Host "🤖 Comparisons: $($stats.comparisons) sessions" -ForegroundColor Magenta
    Write-Host "❌ Errors: $($stats.errors) total" -ForegroundColor Red
}

# Export aliases
Set-Alias -Name "ai-compare" -Value Compare-AIResponses
Set-Alias -Name "ai-implement" -Value ai-implement  
Set-Alias -Name "ai-review" -Value ai-review
Set-Alias -Name "ai-pipeline" -Value ai-pipeline
Set-Alias -Name "claude" -Value claude
Set-Alias -Name "gemini" -Value gemini
Set-Alias -Name "copilot" -Value copilot
Set-Alias -Name "ai-log" -Value ai-log
Set-Alias -Name "ai-history" -Value ai-history

# Import auto-integration features
$AutoIntegrationScript = "$env:USERPROFILE\Documents\Scripts\AI-Auto-Integration.ps1"
if (Test-Path $AutoIntegrationScript) {
    . $AutoIntegrationScript
}

# Auto-trigger functions
function Enable-AIAutoMode {
    <#
    .SYNOPSIS
        Enables automatic AI engagement when you interact with GitHub Copilot
    #>
    Write-Host "🚀 Enabling AI Auto Mode..." -ForegroundColor Magenta
    
    try {
        if (Get-Command Start-AIAutoIntegration -ErrorAction SilentlyContinue) {
            # Start monitoring
            $watcher = Start-AIAutoIntegration
            $job = Enable-SmartAIResponse
            
            # Create global variable to track state
            $Global:AIAutoMode = @{
                Enabled = $true
                Watcher = $watcher
                BackgroundJob = $job
                StartTime = Get-Date
            }
            
            Write-Host "✅ AI Auto Mode enabled! AI will automatically engage when you interact with GitHub Copilot" -ForegroundColor Green
            Write-Host "📋 Available snippets: 'ai-auto', 'chat-ai', 'compare-auto'" -ForegroundColor Cyan
            Write-Host "⌨️  Keyboard shortcuts: Ctrl+Alt+Shift+M (enable), Ctrl+Alt+Shift+S (status)" -ForegroundColor Cyan
        } else {
            Write-Host "⚠️ Auto-integration script not found. Manual mode only." -ForegroundColor Yellow
            Write-Host "✅ Manual AI commands available: claude, gemini, copilot, ai-compare" -ForegroundColor Green
        }
    } catch {
        Write-Host "❌ Failed to enable auto mode: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "✅ Falling back to manual AI commands" -ForegroundColor Yellow
    }
}

function Disable-AIAutoMode {
    <#
    .SYNOPSIS
        Disables automatic AI engagement
    #>
    if ($Global:AIAutoMode -and $Global:AIAutoMode.Enabled) {
        $Global:AIAutoMode.Watcher.Dispose()
        Stop-Job $Global:AIAutoMode.BackgroundJob
        Remove-Job $Global:AIAutoMode.BackgroundJob
        $Global:AIAutoMode.Enabled = $false
        
        Write-Host "🛑 AI Auto Mode disabled." -ForegroundColor Yellow
    }
}

function Get-AIAutoStatus {
    <#
    .SYNOPSIS
        Shows the current status of AI Auto Mode
    #>
    if ($Global:AIAutoMode -and $Global:AIAutoMode.Enabled) {
        $uptime = (Get-Date) - $Global:AIAutoMode.StartTime
        Write-Host "🟢 AI Auto Mode: ACTIVE" -ForegroundColor Green
        Write-Host "⏱️  Uptime: $($uptime.ToString('hh\:mm\:ss'))" -ForegroundColor Gray
        Write-Host "🎯 Auto-triggers: review, compare, implement, analyze" -ForegroundColor Yellow
    } else {
        Write-Host "🔴 AI Auto Mode: INACTIVE" -ForegroundColor Red
        Write-Host "💡 Run 'Enable-AIAutoMode' to start automatic AI engagement" -ForegroundColor Yellow
    }
}

# Enhanced compare function with auto-context
function ai-compare-auto {
    <#
    .SYNOPSIS
        Enhanced AI comparison with automatic context gathering
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Prompt,
        
        [Parameter()]
        [string]$File
    )
    
    Write-Host "`n🤖 Enhanced AI Comparison with Auto-Context..." -ForegroundColor Magenta
    
    # Automatically gather context if we're in VS Code
    $vsCodeContext = ""
    if (Get-Process "Code" -ErrorAction SilentlyContinue) {
        $vsCodeContext = " [GitHub Copilot context: VS Code active]"
        Write-Host "📱 Detected VS Code - Adding Copilot context" -ForegroundColor Cyan
    }
    
    # Enhanced prompt with context
    $enhancedPrompt = "$Prompt$vsCodeContext"
    
    # Run the standard comparison
    Compare-AIResponses -Prompt $enhancedPrompt -File $File
    
    # Log the auto-context usage
    $autoLog = @{
        Timestamp = Get-Date
        OriginalPrompt = $Prompt
        EnhancedPrompt = $enhancedPrompt
        VSCodeActive = $vsCodeContext -ne ""
        File = $File
    }
    
    $autoLog | ConvertTo-Json | Out-File -Append "$env:USERPROFILE\.ai-logs\auto-context.log"
}

Set-Alias -Name "ai-auto" -Value ai-compare-auto

# Module initialization
Write-Host "🤖 AI Helpers module loaded!" -ForegroundColor Green -NoNewline
Write-Host " Available functions: " -ForegroundColor Gray -NoNewline
Write-Host "claude, gemini, copilot, ai-compare, ai-implement, ai-review, ai-pipeline" -ForegroundColor Yellow
