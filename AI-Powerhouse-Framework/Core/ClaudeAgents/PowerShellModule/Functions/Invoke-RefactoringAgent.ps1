function Invoke-RefactoringAgent {
    <#
    .SYNOPSIS
    Identifies refactoring opportunities and suggests improvements
    
    .PARAMETER FilePath
    Path to file to refactor
    
    .EXAMPLE
    Invoke-RefactoringAgent -FilePath ".\legacy-code.js"
    refactor-code .\legacy-code.js
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "refactoring"
    if (-not $agentPrompt) { return }
    
    Write-Host "🔧 Refactoring Agent analyzing..." -ForegroundColor DarkYellow
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nAnalyze and suggest refactorings for:`n`nFile: $FilePath`n`n$fileContent"
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
        
        Write-AgentLog -AgentName "Refactoring" -FilePath $FilePath -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Refactoring Agent failed: $_"
    }
}

Set-Alias -Name refactor-code -Value Invoke-RefactoringAgent