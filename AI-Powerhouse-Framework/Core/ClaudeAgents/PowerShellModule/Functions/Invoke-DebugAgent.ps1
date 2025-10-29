function Invoke-DebugAgent {
    <#
    .SYNOPSIS
    Analyzes bugs and provides debugging guidance
    
    .PARAMETER FilePath
    Path to file with bug
    
    .PARAMETER ErrorMessage
    Error message or stack trace
    
    .EXAMPLE
    Invoke-DebugAgent -FilePath ".\buggy.js" -ErrorMessage "TypeError: Cannot read property 'x' of undefined"
    debug-issue .\buggy.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string]$ErrorMessage,
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "debugging"
    if (-not $agentPrompt) { return }
    
    Write-Host "🐛 Debug Agent investigating..." -ForegroundColor Red
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    if ($ErrorMessage) {
        $fullPrompt += "`n`nError Message:`n$ErrorMessage`n"
    }
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nCode with bug:`n`nFile: $FilePath`n`n$fileContent"
        } else {
            Write-Error "File not found: $FilePath"
            return
        }
    }
    
    if ($Prompt) {
        $fullPrompt += "`n`nAdditional Context: $Prompt"
    }
    
    try {
        $response = claude $fullPrompt
        Write-Host $response
        
        Write-AgentLog -AgentName "Debug" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Debug Agent failed: $_"
    }
}

Set-Alias -Name debug-issue -Value Invoke-DebugAgent