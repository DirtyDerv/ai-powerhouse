function Compare-AgentResponses {
    <#
    .SYNOPSIS
    Gets responses from multiple agents on the same question for comparison
    
    .PARAMETER Prompt
    Question/task for agents
    
    .PARAMETER FilePath
    Optional file for context
    
    .PARAMETER Agents
    Which agents to compare
    
    .EXAMPLE
    Compare-AgentResponses -Prompt "How to implement caching?" -Agents architecture,performance
    compare-agents "best practices for error handling"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt,
        
        [Parameter(Mandatory=$false)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string[]]$Agents = @('security', 'performance', 'review')
    )
    
    Write-Host "🔄 Comparing Agent Responses..." -ForegroundColor White
    Write-Host "Question: $Prompt" -ForegroundColor Gray
    Write-Host ""
    
    foreach ($agent in $Agents) {
        Write-Host ("="*60) -ForegroundColor DarkGray
        Write-Host "Agent: $agent" -ForegroundColor White -BackgroundColor DarkGray
        Write-Host ("="*60) -ForegroundColor DarkGray
        Write-Host ""
        
        $agentPrompt = Get-AgentPrompt -AgentName $agent
        if ($agentPrompt) {
            $fullPrompt = $agentPrompt + "`n`n" + $Prompt
            
            if ($FilePath -and (Test-Path $FilePath)) {
                $fileContent = Get-Content $FilePath -Raw
                $fullPrompt += "`n`nFile Context:`n$fileContent"
            }
            
            try {
                $response = claude $fullPrompt
                Write-Host $response
                Write-Host ""
            }
            catch {
                Write-Error "Agent $agent failed: $_"
            }
        }
        
        Start-Sleep -Seconds 1
    }
    
    Write-Host ("="*60) -ForegroundColor DarkGray
    Write-Host "✅ Comparison Complete!" -ForegroundColor Green
}

Set-Alias -Name compare-agents -Value Compare-AgentResponses