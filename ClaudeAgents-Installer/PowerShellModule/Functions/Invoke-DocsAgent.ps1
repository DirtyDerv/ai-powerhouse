function Invoke-DocsAgent {
    <#
    .SYNOPSIS
    Generates documentation using the Documentation Agent
    
    .PARAMETER FilePath
    Path to file to document
    
    .PARAMETER DocType
    Type of documentation (api, readme, inline, all)
    
    .EXAMPLE
    Invoke-DocsAgent -FilePath ".\api.js" -DocType api
    generate-docs .\api.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('api', 'readme', 'inline', 'all')]
        [string]$DocType = 'all',
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "documentation"
    if (-not $agentPrompt) { return }
    
    Write-Host "📚 Documentation Agent writing..." -ForegroundColor Yellow
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    $fullPrompt += "`n`nDocumentation Type: $DocType"
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nGenerate documentation for:`n`nFile: $FilePath`n`n$fileContent"
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
        
        Write-AgentLog -AgentName "Documentation" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Documentation Agent failed: $_"
    }
}

Set-Alias -Name generate-docs -Value Invoke-DocsAgent