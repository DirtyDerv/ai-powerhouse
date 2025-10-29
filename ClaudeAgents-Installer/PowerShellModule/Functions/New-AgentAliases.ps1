# Convenient aliases for new Claude Agents

# Database Agent aliases
Set-Alias -Name "database-optimize" -Value "Invoke-DatabaseAgent"
Set-Alias -Name "db-help" -Value "Invoke-DatabaseAgent"
Set-Alias -Name "sql-optimize" -Value "Invoke-DatabaseAgent"

# Research Agent aliases  
Set-Alias -Name "research-topic" -Value "Invoke-ResearchAgent"
Set-Alias -Name "fact-check" -Value "Invoke-ResearchAgent"
Set-Alias -Name "market-research" -Value "Invoke-ResearchAgent"

# N8N Agent aliases
Set-Alias -Name "n8n-workflow" -Value "Invoke-N8NAgent"
Set-Alias -Name "n8n-help" -Value "Invoke-N8NAgent"
Set-Alias -Name "workflow-design" -Value "Invoke-N8NAgent"

# Export the aliases
Export-ModuleMember -Alias *