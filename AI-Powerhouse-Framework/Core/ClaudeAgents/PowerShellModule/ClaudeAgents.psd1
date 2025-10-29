@{
    RootModule = 'ClaudeAgents.psm1'
    ModuleVersion = '1.0.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'AI Powerhouse Team'
    Description = 'Specialized Claude AI Agents for software development tasks'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Invoke-SecurityAgent',
        'Invoke-TestingAgent',
        'Invoke-DocsAgent',
        'Invoke-PerformanceAgent',
        'Invoke-CodeReviewAgent',
        'Invoke-DebugAgent',
        'Invoke-ArchitectureAgent',
        'Invoke-RefactoringAgent',
        'Invoke-ElectronicsAgent',
        'electronics-design',
        'circuit-design',
        'pcb-layout',
        'component-pricing',
        'electronics-debug',
        'Invoke-AgentPipeline',
        'Compare-AgentResponses',
        'Get-AgentHelp'
    )
    AliasesToExport = @(
        'security-review',
        'generate-tests',
        'generate-docs',
        'analyze-performance',
        'code-review',
        'debug-issue',
        'design-architecture',
        'refactor-code',
        'agent-pipeline',
        'compare-agents',
        'agent-help'
    )
}