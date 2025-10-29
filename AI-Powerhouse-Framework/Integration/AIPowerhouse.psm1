# AI Powerhouse Framework - PowerShell to Python Bridge
# Enables PowerShell to call Python AI providers

function Import-AIPowerhouse {
    <#
    .SYNOPSIS
    Initialize AI Powerhouse Framework integration
    
    .DESCRIPTION
    Sets up the bridge between PowerShell and Python AI providers.
    Checks for Python, installs dependencies, and configures the integration.
    #>
    
    Write-Host "🚀 Initializing AI Powerhouse Framework..." -ForegroundColor Cyan
    
    # Check Python installation
    try {
        $pythonVersion = python --version 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Python not found"
        }
        Write-Host "✅ Python detected: $pythonVersion" -ForegroundColor Green
    }
    catch {
        Write-Error "❌ Python not found. Please install Python 3.8+ and add to PATH"
        return $false
    }
    
    # Find AI Powerhouse Framework
    $frameworkPaths = @(
        "$env:USERPROFILE\AI-Powerhouse-Framework",
        "C:\AI-Powerhouse-Framework",
        "$PSScriptRoot\..\..\..\AI-Powerhouse-Framework"
    )
    
    $frameworkPath = $null
    foreach ($path in $frameworkPaths) {
        if (Test-Path "$path\Integration\unified_ai_bridge.py") {
            $frameworkPath = $path
            break
        }
    }
    
    if (-not $frameworkPath) {
        Write-Error "❌ AI Powerhouse Framework not found"
        return $false
    }
    
    $script:AIPowerhousePath = $frameworkPath
    Write-Host "✅ Framework found: $frameworkPath" -ForegroundColor Green
    
    # Test Python bridge
    try {
        $testResult = python "$frameworkPath\Integration\unified_ai_bridge.py" capabilities 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Python bridge operational" -ForegroundColor Green
            return $true
        } else {
            Write-Warning "⚠️ Python bridge test failed: $testResult"
            return $false
        }
    }
    catch {
        Write-Warning "⚠️ Python bridge test error: $_"
        return $false
    }
}

function Get-AIPowerhouse-Capabilities {
    <#
    .SYNOPSIS
    Get all available AI capabilities
    
    .DESCRIPTION
    Returns information about available AI providers and Claude Agents
    #>
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return $null
        }
    }
    
    try {
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" capabilities 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result | ConvertFrom-Json
        } else {
            Write-Error "Failed to get capabilities: $result"
            return $null
        }
    }
    catch {
        Write-Error "Error getting capabilities: $_"
        return $null
    }
}

function Ask-Claude {
    <#
    .SYNOPSIS
    Ask Claude AI via Python bridge
    
    .PARAMETER Prompt
    The question or prompt for Claude
    
    .EXAMPLE
    Ask-Claude "Explain quantum computing in simple terms"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt
    )
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return "Error: AI Powerhouse Framework not available"
        }
    }
    
    Write-Host "🤖 Asking Claude AI..." -ForegroundColor Cyan
    
    try {
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" ai --provider claude --prompt "$Prompt" 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result
        } else {
            return "Error calling Claude: $result"
        }
    }
    catch {
        return "Error: $_"
    }
}

function Ask-Gemini {
    <#
    .SYNOPSIS
    Ask Google Gemini via Python bridge
    
    .PARAMETER Prompt
    The question or prompt for Gemini
    
    .EXAMPLE
    Ask-Gemini "What are the latest trends in machine learning?"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt
    )
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return "Error: AI Powerhouse Framework not available"
        }
    }
    
    Write-Host "🔍 Asking Google Gemini..." -ForegroundColor Cyan
    
    try {
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" ai --provider gemini --prompt "$Prompt" 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result
        } else {
            return "Error calling Gemini: $result"
        }
    }
    catch {
        return "Error: $_"
    }
}

function Ask-OpenAI {
    <#
    .SYNOPSIS
    Ask OpenAI via Python bridge
    
    .PARAMETER Prompt
    The question or prompt for OpenAI
    
    .EXAMPLE
    Ask-OpenAI "Generate a Python function to calculate fibonacci numbers"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt
    )
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return "Error: AI Powerhouse Framework not available"
        }
    }
    
    Write-Host "🧠 Asking OpenAI..." -ForegroundColor Cyan
    
    try {
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" ai --provider openai --prompt "$Prompt" 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result
        } else {
            return "Error calling OpenAI: $result"
        }
    }
    catch {
        return "Error: $_"
    }
}

function Ask-AllAI {
    <#
    .SYNOPSIS
    Ask all available AI providers
    
    .PARAMETER Prompt
    The question or prompt for all AI providers
    
    .EXAMPLE
    Ask-AllAI "Compare Python and JavaScript for web development"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt
    )
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return "Error: AI Powerhouse Framework not available"
        }
    }
    
    Write-Host "🎯 Asking all AI providers..." -ForegroundColor Cyan
    
    try {
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" ai --provider all --prompt "$Prompt" 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result
        } else {
            return "Error calling AI providers: $result"
        }
    }
    catch {
        return "Error: $_"
    }
}

function Get-ComprehensiveAnalysis {
    <#
    .SYNOPSIS
    Perform comprehensive analysis using both AI providers and Claude Agents
    
    .PARAMETER FilePath
    Path to the file to analyze
    
    .EXAMPLE
    Get-ComprehensiveAnalysis ".\src\main.py"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return "Error: AI Powerhouse Framework not available"
        }
    }
    
    Write-Host "🔍 Performing comprehensive analysis..." -ForegroundColor Cyan
    Write-Host "   File: $FilePath" -ForegroundColor Gray
    
    try {
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" comprehensive --file "$FilePath" 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result
        } else {
            return "Error during analysis: $result"
        }
    }
    catch {
        return "Error: $_"
    }
}

function Compare-AIResponses {
    <#
    .SYNOPSIS
    Compare responses from multiple AI sources for the same prompt
    
    .PARAMETER Prompt
    The prompt to send to multiple AI systems
    
    .PARAMETER FilePath
    Optional file path for context
    
    .EXAMPLE
    Compare-AIResponses "How can I optimize this code?"
    Compare-AIResponses "Security review needed" -FilePath ".\auth.py"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt,
        
        [Parameter(Mandatory=$false)]
        [string]$FilePath
    )
    
    if (-not $script:AIPowerhousePath) {
        if (-not (Import-AIPowerhouse)) {
            return "Error: AI Powerhouse Framework not available"
        }
    }
    
    Write-Host "⚖️ Comparing AI responses..." -ForegroundColor Cyan
    
    try {
        $cmd = "analyze --prompt `"$Prompt`""
        if ($FilePath -and (Test-Path $FilePath)) {
            $cmd += " --file `"$FilePath`""
        }
        
        $result = python "$script:AIPowerhousePath\Integration\unified_ai_bridge.py" $cmd 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $result
        } else {
            return "Error comparing responses: $result"
        }
    }
    catch {
        return "Error: $_"
    }
}

# Unified AI shortcuts
function ai-claude { Ask-Claude $args }
function ai-gemini { Ask-Gemini $args }
function ai-openai { Ask-OpenAI $args }
function ai-all { Ask-AllAI $args }
function ai-compare { Compare-AIResponses $args }
function ai-analyze { Get-ComprehensiveAnalysis $args }
function ai-caps { Get-AIPowerhouse-Capabilities }

# Export functions
Export-ModuleMember -Function @(
    'Import-AIPowerhouse',
    'Get-AIPowerhouse-Capabilities',
    'Ask-Claude',
    'Ask-Gemini', 
    'Ask-OpenAI',
    'Ask-AllAI',
    'Get-ComprehensiveAnalysis',
    'Compare-AIResponses',
    'ai-claude',
    'ai-gemini',
    'ai-openai',
    'ai-all',
    'ai-compare',
    'ai-analyze',
    'ai-caps'
)

# Auto-initialize when module loads
try {
    Import-AIPowerhouse | Out-Null
    Write-Host "🤖 AI Powerhouse Framework loaded!" -ForegroundColor Green
    Write-Host "   Use 'ai-caps' to see all capabilities" -ForegroundColor Gray
    Write-Host "   Use 'ai-claude', 'ai-gemini', 'ai-openai' for AI queries" -ForegroundColor Gray
    Write-Host "   Use 'ai-all' to query all providers at once" -ForegroundColor Gray
}
catch {
    Write-Warning "⚠️ AI Powerhouse Framework initialization failed"
}