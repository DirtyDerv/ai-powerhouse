function Invoke-N8NAgent {
    <#
    .SYNOPSIS
    Invokes the N8N Workflow Automation Expert Agent for creating and optimizing n8n workflows.
    
    .DESCRIPTION
    The N8N Agent specializes in n8n workflow design, node configuration, automation strategies,
    API integrations, and enterprise workflow orchestration.
    
    .PARAMETER Query
    The n8n workflow question or automation challenge you want help with.
    
    .PARAMETER WorkflowType
    The type of workflow: Integration, Automation, DataProcessing, or Monitoring.
    
    .PARAMETER Complexity
    The complexity level: Simple, Intermediate, or Advanced.
    
    .EXAMPLE
    Invoke-N8NAgent "Create a workflow to sync Salesforce leads with HubSpot contacts"
    
    .EXAMPLE
    Invoke-N8NAgent "Optimize my slow data processing workflow" -WorkflowType "DataProcessing" -Complexity "Advanced"
    
    .EXAMPLE
    Invoke-N8NAgent "Set up automated email alerts when system performance drops" -WorkflowType "Monitoring"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Integration", "Automation", "DataProcessing", "Monitoring", "General")]
        [string]$WorkflowType = "General",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Simple", "Intermediate", "Advanced")]
        [string]$Complexity = "Intermediate"
    )
    
    $AgentPath = Join-Path $PSScriptRoot ".." "AgentPrompts" "n8n-agent.txt"
    
    if (-not (Test-Path $AgentPath)) {
        Write-Error "N8N agent prompt file not found: $AgentPath"
        return
    }
    
    try {
        $AgentPrompt = Get-Content $AgentPath -Raw
        
        $FullQuery = @"
Workflow Type: $WorkflowType
Complexity Level: $Complexity

N8N Challenge: $Query

Please provide a comprehensive n8n workflow solution following your established framework, including specific node configurations and implementation guidance.
"@
        
        Write-Host "⚡ N8N Agent Processing..." -ForegroundColor Cyan
        Write-Host "Query: $Query" -ForegroundColor Gray
        Write-Host "Type: $WorkflowType | Complexity: $Complexity" -ForegroundColor Gray
        Write-Host ""
        
        # Execute Claude with the agent prompt
        $Response = claude $AgentPrompt $FullQuery
        
        Write-Host "N8N Agent Response:" -ForegroundColor Green
        Write-Host $Response
        
        return $Response
    }
    catch {
        Write-Error "Failed to invoke N8N Agent: $_"
    }
}

# Export the function
Export-ModuleMember -Function Invoke-N8NAgent