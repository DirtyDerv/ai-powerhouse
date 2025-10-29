function Invoke-AgentPipeline {
    <#
    .SYNOPSIS
    Runs multiple agents in sequence for comprehensive analysis
    
    .PARAMETER FilePath
    Path to file to analyze
    
    .PARAMETER Agents
    Which agents to run (default: all core agents)
    
    .EXAMPLE
    Invoke-AgentPipeline -FilePath ".\module.js"
    agent-pipeline .\module.js -Agents security,testing,performance
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('security', 'testing', 'docs', 'performance', 'review', 'electronics', 'all')]
        [string[]]$Agents = @('all')
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    
    Write-Host "🚀 Agent Pipeline Starting..." -ForegroundColor White
    Write-Host "File: $FilePath" -ForegroundColor Gray
    Write-Host ""
    
    $agentList = if ($Agents -contains 'all') {
        @('security', 'review', 'performance', 'testing', 'electronics', 'docs')
    } else {
        $Agents
    }
    
    $results = @()
    
    foreach ($agent in $agentList) {
        Write-Host ("="*60) -ForegroundColor DarkGray
        
        switch ($agent) {
            'security' {
                Invoke-SecurityAgent -FilePath $FilePath
            }
            'testing' {
                Invoke-TestingAgent -FilePath $FilePath
            }
            'docs' {
                Invoke-DocsAgent -FilePath $FilePath
            }
            'performance' {
                Invoke-PerformanceAgent -FilePath $FilePath
            }
            'review' {
                Invoke-CodeReviewAgent -FilePath $FilePath
            }
            'electronics' {
                Invoke-ElectronicsAgent -Task review -FilePath $FilePath
            }
        }
        
        Write-Host ""
        Start-Sleep -Seconds 1  # Brief pause between agents
    }
    
    Write-Host ("="*60) -ForegroundColor DarkGray
    Write-Host "✅ Agent Pipeline Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Check logs at: $env:USERPROFILE\.claude-agents\logs\agent-interactions.log" -ForegroundColor Gray
}

Set-Alias -Name agent-pipeline -Value Invoke-AgentPipeline