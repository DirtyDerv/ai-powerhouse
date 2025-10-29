function Get-AgentHelp {
    <#
    .SYNOPSIS
    Displays help information about available agents
    
    .EXAMPLE
    Get-AgentHelp
    agent-help
    #>
    
    [CmdletBinding()]
    param()
    
    Write-Host ""
    Write-Host "🤖 Claude Agents Help" -ForegroundColor Cyan
    Write-Host ("="*60) -ForegroundColor DarkGray
    Write-Host ""
    
    Write-Host "Available Agents:" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "🔒 Security Agent" -ForegroundColor Blue
    Write-Host "   Command: " -NoNewline
    Write-Host "security-review <file>" -ForegroundColor White
    Write-Host "   Purpose: Security vulnerability analysis"
    Write-Host "   Example: security-review .\auth.js"
    Write-Host ""
    
    Write-Host "🧪 Testing Agent" -ForegroundColor Green
    Write-Host "   Command: " -NoNewline
    Write-Host "generate-tests <file>" -ForegroundColor White
    Write-Host "   Purpose: Comprehensive test generation"
    Write-Host "   Example: generate-tests .\service.js"
    Write-Host ""
    
    Write-Host "📚 Documentation Agent" -ForegroundColor Yellow
    Write-Host "   Command: " -NoNewline
    Write-Host "generate-docs <file>" -ForegroundColor White
    Write-Host "   Purpose: Documentation generation"
    Write-Host "   Example: generate-docs .\api.js"
    Write-Host ""
    
    Write-Host "⚡ Performance Agent" -ForegroundColor Magenta
    Write-Host "   Command: " -NoNewline
    Write-Host "analyze-performance <file>" -ForegroundColor White
    Write-Host "   Purpose: Performance optimization"
    Write-Host "   Example: analyze-performance .\slow.js"
    Write-Host ""
    
    Write-Host "👁️  Code Review Agent" -ForegroundColor Cyan
    Write-Host "   Command: " -NoNewline
    Write-Host "code-review <file>" -ForegroundColor White
    Write-Host "   Purpose: Code quality review"
    Write-Host "   Example: code-review .\component.js"
    Write-Host ""
    
    Write-Host "🐛 Debug Agent" -ForegroundColor Red
    Write-Host "   Command: " -NoNewline
    Write-Host "debug-issue <file>" -ForegroundColor White
    Write-Host "   Purpose: Bug analysis and debugging"
    Write-Host "   Example: debug-issue .\buggy.js -ErrorMessage 'TypeError...'"
    Write-Host ""
    
    Write-Host "🏗️  Architecture Agent" -ForegroundColor DarkCyan
    Write-Host "   Command: " -NoNewline
    Write-Host "design-architecture '<prompt>'" -ForegroundColor White
    Write-Host "   Purpose: System architecture design"
    Write-Host "   Example: design-architecture 'scalable chat app'"
    Write-Host ""
    
    Write-Host "🔧 Refactoring Agent" -ForegroundColor DarkYellow
    Write-Host "   Command: " -NoNewline
    Write-Host "refactor-code <file>" -ForegroundColor White
    Write-Host "   Purpose: Code refactoring suggestions"
    Write-Host "   Example: refactor-code .\legacy.js"
    Write-Host ""
    
    Write-Host "🔌 Electronics Agent" -ForegroundColor DarkGreen
    Write-Host "   Command: " -NoNewline
    Write-Host "electronics-design '<prompt>'" -ForegroundColor White
    Write-Host "   Purpose: Circuit design, PCB layout, component pricing"
    Write-Host "   Example: electronics-design 'ESP32 temperature sensor'"
    Write-Host "   Tasks: design, debug, pcb, bom, review, test, pricing"
    Write-Host ""
    
    Write-Host "🗄️  Database Agent" -ForegroundColor DarkBlue
    Write-Host "   Command: " -NoNewline
    Write-Host "database-optimize '<query>'" -ForegroundColor White
    Write-Host "   Purpose: Database design, SQL optimization, performance tuning"
    Write-Host "   Example: database-optimize 'slow query optimization'"
    Write-Host "   Aliases: db-help, sql-optimize"
    Write-Host ""
    
    Write-Host "🔍 Research Agent" -ForegroundColor DarkMagenta
    Write-Host "   Command: " -NoNewline
    Write-Host "research-topic '<topic>'" -ForegroundColor White
    Write-Host "   Purpose: Comprehensive research, fact-checking, market analysis"
    Write-Host "   Example: research-topic 'AI automation trends 2025'"
    Write-Host "   Aliases: fact-check, market-research"
    Write-Host ""
    
    Write-Host "⚡ N8N Agent" -ForegroundColor Yellow
    Write-Host "   Command: " -NoNewline
    Write-Host "n8n-workflow '<description>'" -ForegroundColor White
    Write-Host "   Purpose: N8N workflow design, automation, API integrations"
    Write-Host "   Example: n8n-workflow 'sync Salesforce with HubSpot'"
    Write-Host "   Aliases: n8n-help, workflow-design"
    Write-Host ""
    
    Write-Host ("="*60) -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "Utility Commands:" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "🚀 agent-pipeline <file>" -ForegroundColor White
    Write-Host "   Run multiple agents in sequence"
    Write-Host "   Example: agent-pipeline .\module.js"
    Write-Host ""
    
    Write-Host "🔄 compare-agents '<prompt>'" -ForegroundColor White
    Write-Host "   Compare responses from multiple agents"
    Write-Host "   Example: compare-agents 'how to handle errors?'"
    Write-Host ""
    
    Write-Host ("="*60) -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "For more info: Get-Help <command-name> -Detailed" -ForegroundColor Gray
    Write-Host ""
}

Set-Alias -Name agent-help -Value Get-AgentHelp