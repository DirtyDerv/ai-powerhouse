function Invoke-ResearchAgent {
    <#
    .SYNOPSIS
    Invokes the Research Expert Agent for comprehensive information gathering, analysis, and fact-checking.
    
    .DESCRIPTION
    The Research Agent specializes in thorough research across all domains, information synthesis,
    fact-checking, market analysis, and evidence-based reporting.
    
    .PARAMETER Query
    The research question or topic you want the agent to investigate.
    
    .PARAMETER ResearchType
    The type of research needed: Academic, Market, Technical, Historical, or General.
    
    .PARAMETER Depth
    The depth of research: Quick (surface-level), Standard (comprehensive), or Deep (exhaustive).
    
    .EXAMPLE
    Invoke-ResearchAgent "What are the latest trends in AI automation for small businesses?"
    
    .EXAMPLE
    Invoke-ResearchAgent "Research the competitive landscape for project management tools" -ResearchType "Market" -Depth "Deep"
    
    .EXAMPLE
    Invoke-ResearchAgent "Fact-check: Does quantum computing pose a threat to current encryption?" -ResearchType "Technical"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Academic", "Market", "Technical", "Historical", "General")]
        [string]$ResearchType = "General",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Quick", "Standard", "Deep")]
        [string]$Depth = "Standard"
    )
    
    $AgentPath = Join-Path $PSScriptRoot ".." "AgentPrompts" "research-agent.txt"
    
    if (-not (Test-Path $AgentPath)) {
        Write-Error "Research agent prompt file not found: $AgentPath"
        return
    }
    
    try {
        $AgentPrompt = Get-Content $AgentPath -Raw
        
        $FullQuery = @"
Research Type: $ResearchType
Research Depth: $Depth

Research Query: $Query

Please provide a comprehensive research analysis following your established framework.
"@
        
        Write-Host "🔍 Research Agent Processing..." -ForegroundColor Cyan
        Write-Host "Query: $Query" -ForegroundColor Gray
        Write-Host "Type: $ResearchType | Depth: $Depth" -ForegroundColor Gray
        Write-Host ""
        
        # Execute Claude with the agent prompt
        $Response = claude $AgentPrompt $FullQuery
        
        Write-Host "Research Agent Response:" -ForegroundColor Green
        Write-Host $Response
        
        return $Response
    }
    catch {
        Write-Error "Failed to invoke Research Agent: $_"
    }
}

# Export the function
Export-ModuleMember -Function Invoke-ResearchAgent