function Invoke-PerformanceAgent {
    <#
    .SYNOPSIS
    Analyzes performance and suggests optimizations
    
    .PARAMETER FilePath
    Path to file to analyze
    
    .EXAMPLE
    Invoke-PerformanceAgent -FilePath ".\slow-function.js"
    analyze-performance .\slow-function.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "performance"
    if (-not $agentPrompt) { return }
    
    Write-Host "⚡ Performance Agent analyzing..." -ForegroundColor Magenta
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nAnalyze performance of:`n`nFile: $FilePath`n`n$fileContent"
        } else {
            Write-Error "File not found: $FilePath"
            return
        }
    }
    
    if ($Prompt) {
        $fullPrompt += "`n`nFocus on: $Prompt"
    }
    
    try {
        $response = claude $fullPrompt
        Write-Host $response
        
        Write-AgentLog -AgentName "Performance" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Performance Agent failed: $_"
    }
}

Set-Alias -Name analyze-performance -Value Invoke-PerformanceAgent