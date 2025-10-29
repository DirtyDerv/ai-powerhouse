@{
    # Module manifest for AIHelpers
    
    # Script module or binary module file associated with this manifest.
    RootModule = 'AIHelpers.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0'
    
    # Supported PSEditions
    CompatiblePSEditions = @('Core', 'Desktop')
    
    # ID used to uniquely identify this module
    GUID = 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
    
    # Author of this module
    Author = 'AI Powerhouse Team'
    
    # Company or vendor of this module
    CompanyName = 'AI Powerhouse'
    
    # Copyright statement for this module
    Copyright = '(c) 2025 AI Powerhouse Team. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'PowerShell module for integrating Claude, Gemini, and GitHub Copilot with VS Code'
    
    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Invoke-ClaudeCode',
        'Invoke-GeminiCLI',
        'Invoke-GitHubCopilot',
        'Compare-AIResponses',
        'Write-AILog',
        'Get-AIHistory',
        'Clear-AILogs',
        'Test-AITools',
        'Enable-AIAutoMode',
        'Get-AIAutoStatus',
        'ai-compare',
        'ai-implement',
        'ai-review',
        'ai-pipeline',
        'ai-compare-auto',
        'claude',
        'gemini',
        'copilot',
        'ai-log',
        'ai-history'
    )
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()
    
    # Variables to export from this module
    VariablesToExport = @()
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @(
        'ai-compare',
        'ai-implement', 
        'ai-review',
        'ai-pipeline',
        'claude',
        'gemini',
        'copilot',
        'ai-log',
        'ai-history'
    )
    
    # List of all files packaged with this module
    FileList = @(
        'AIHelpers.psm1',
        'AIHelpers.psd1',
        'Functions\Invoke-ClaudeCode.ps1',
        'Functions\Invoke-GeminiCLI.ps1',
        'Functions\Invoke-Codex.ps1',
        'Functions\Compare-AIResponses.ps1',
        'Functions\Write-AILog.ps1'
    )
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        
        PSData = @{
            
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('AI', 'Claude', 'Gemini', 'GitHubCopilot', 'CLI', 'VSCode', 'Windows11')
            
            # A URL to the license for this module.
            LicenseUri = ''
            
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/ai-powerhouse/vscode-global-setup'
            
            # A URL to an icon representing this module.
            IconUri = ''
            
            # ReleaseNotes of this module
            ReleaseNotes = 'Initial release of AI Helpers module for global VS Code integration'
            
            # Prerelease string of this module
            # Prerelease = ''
            
            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $false
            
            # External dependent modules of this module
            ExternalModuleDependencies = @()
            
        } # End of PSData hashtable
        
    } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    DefaultCommandPrefix = ''
}
