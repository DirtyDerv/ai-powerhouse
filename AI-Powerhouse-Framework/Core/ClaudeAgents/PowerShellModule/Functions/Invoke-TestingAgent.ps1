function Invoke-TestingAgent {
    <#
    .SYNOPSIS
    Generates comprehensive tests using the Testing Agent
    
    .PARAMETER FilePath
    Path to file to generate tests for
    
    .PARAMETER TestType
    Type of tests (unit, integration, e2e)
    
    .EXAMPLE
    Invoke-TestingAgent -FilePath ".\service.js"
    generate-tests .\service.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('unit', 'integration', 'e2e', 'all')]
        [string]$TestType = 'all',
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "testing"
    if (-not $agentPrompt) { return }
    
    Write-Host "🧪 Testing Agent generating tests..." -ForegroundColor Green
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    $fullPrompt += "`n`nTest Type: $TestType"
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nGenerate tests for this code:`n`nFile: $FilePath`n`n$fileContent"
        } else {
            Write-Error "File not found: $FilePath"
            return
        }
    }
    
    if ($Prompt) {
        $fullPrompt += "`n`nAdditional Requirements: $Prompt"
    }
    
    try {
        $response = claude $fullPrompt
        Write-Host $response
        
        Write-AgentLog -AgentName "Testing" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Testing Agent failed: $_"
    }
}

Set-Alias -Name generate-tests -Value Invoke-TestingAgent