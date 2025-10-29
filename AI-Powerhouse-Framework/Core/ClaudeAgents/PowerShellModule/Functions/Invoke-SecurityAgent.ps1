function Invoke-SecurityAgent {
    <#
    .SYNOPSIS
    Runs security analysis on code using the Security Agent
    
    .PARAMETER FilePath
    Path to file to analyze
    
    .PARAMETER Prompt
    Custom security analysis prompt
    
    .EXAMPLE
    Invoke-SecurityAgent -FilePath ".\auth.js"
    security-review .\auth.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "security"
    if (-not $agentPrompt) { return }
    
    Write-Host "🔒 Security Agent analyzing..." -ForegroundColor Blue
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nFile: $FilePath`n`n$fileContent"
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
        
        # Log interaction
        Write-AgentLog -AgentName "Security" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Security Agent failed: $_"
    }
}

# Create alias
Set-Alias -Name security-review -Value Invoke-SecurityAgent