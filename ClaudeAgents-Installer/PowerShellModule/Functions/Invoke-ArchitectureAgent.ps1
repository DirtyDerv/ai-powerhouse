function Invoke-ArchitectureAgent {
    <#
    .SYNOPSIS
    Provides architectural guidance and system design
    
    .PARAMETER Prompt
    Description of system to design
    
    .EXAMPLE
    Invoke-ArchitectureAgent -Prompt "Design a scalable e-commerce platform"
    design-architecture "real-time chat application with 10k users"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$Prompt
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "architecture"
    if (-not $agentPrompt) { return }
    
    Write-Host "🏗️  Architecture Agent designing..." -ForegroundColor DarkCyan
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    if ($Prompt) {
        $fullPrompt += "`n`nArchitectural Challenge:`n$Prompt"
    }
    
    try {
        $response = claude $fullPrompt
        Write-Host $response
        
        Write-AgentLog -AgentName "Architecture" -FilePath "" -Prompt $Prompt -Response $response
    }
    catch {
        Write-Error "Architecture Agent failed: $_"
    }
}

Set-Alias -Name design-architecture -Value Invoke-ArchitectureAgent