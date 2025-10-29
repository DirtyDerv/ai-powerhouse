function Invoke-CodeReviewAgent {
    <#
    .SYNOPSIS
    Conducts code review focusing on quality and best practices
    
    .PARAMETER FilePath
    Path to file to review
    
    .EXAMPLE
    Invoke-CodeReviewAgent -FilePath ".\component.js"
    code-review .\component.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "code-review"
    if (-not $agentPrompt) { return }
    
    Write-Host "👁️  Code Review Agent analyzing..." -ForegroundColor Cyan
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nReview this code:`n`nFile: $FilePath`n`n$fileContent"
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
        
        Write-AgentLog -AgentName "CodeReview" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Code Review Agent failed: $_"
    }
}

Set-Alias -Name code-review -Value Invoke-CodeReviewAgent