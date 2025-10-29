function Invoke-DatabaseAgent {
    <#
    .SYNOPSIS
    Invokes the Database Expert Agent for database design, optimization, and management tasks.
    
    .DESCRIPTION
    The Database Agent specializes in database design, SQL optimization, schema management,
    and performance tuning across all major database systems (SQL and NoSQL).
    
    .PARAMETER Query
    The database-related question or task you want the agent to help with.
    
    .PARAMETER Context
    Optional context about your current database setup, performance issues, or requirements.
    
    .EXAMPLE
    Invoke-DatabaseAgent "Optimize this slow SQL query: SELECT * FROM users WHERE email LIKE '%@domain.com'"
    
    .EXAMPLE
    Invoke-DatabaseAgent "Design a database schema for an e-commerce platform" -Context "PostgreSQL, 1M+ users, high read load"
    
    .EXAMPLE
    Invoke-DatabaseAgent "Help me migrate from MySQL to PostgreSQL with minimal downtime"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Query,
        
        [Parameter(Mandatory = $false)]
        [string]$Context = ""
    )
    
    $AgentPath = Join-Path $PSScriptRoot ".." "AgentPrompts" "database-agent.txt"
    
    if (-not (Test-Path $AgentPath)) {
        Write-Error "Database agent prompt file not found: $AgentPath"
        return
    }
    
    try {
        $AgentPrompt = Get-Content $AgentPath -Raw
        
        $FullQuery = if ($Context) {
            "Context: $Context`n`nQuery: $Query"
        } else {
            $Query
        }
        
        Write-Host "🗄️  Database Agent Processing..." -ForegroundColor Cyan
        Write-Host "Query: $Query" -ForegroundColor Gray
        if ($Context) {
            Write-Host "Context: $Context" -ForegroundColor Gray
        }
        Write-Host ""
        
        # Execute Claude with the agent prompt
        $Response = claude $AgentPrompt $FullQuery
        
        Write-Host "Database Agent Response:" -ForegroundColor Green
        Write-Host $Response
        
        return $Response
    }
    catch {
        Write-Error "Failed to invoke Database Agent: $_"
    }
}

# Export the function
Export-ModuleMember -Function Invoke-DatabaseAgent