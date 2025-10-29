function Invoke-ElectronicsAgent {
    <#
    .SYNOPSIS
    Electronics design, PCB layout, circuit debugging, and component pricing expert
    
    .PARAMETER Task
    Type of electronics task (design, debug, pcb, bom, review, test, simulate, pricing)
    
    .PARAMETER FilePath
    Path to KiCad project, schematic, or circuit description
    
    .PARAMETER Prompt
    Custom electronics design prompt
    
    .PARAMETER SearchPrices
    Enable comprehensive pricing from UK suppliers
    
    .PARAMETER Suppliers
    Comma-separated list of suppliers to check (default: RS,Farnell,Mouser,LCSC)
    
    .EXAMPLE
    Invoke-ElectronicsAgent -Task design -Prompt "Create ESP32 temperature monitor with OLED display"
    electronics-design "WiFi-enabled soil moisture sensor"
    pcb-layout "4-layer motor controller board"
    component-pricing "ESP32-WROOM-32"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('design', 'debug', 'pcb', 'bom', 'review', 'test', 'simulate', 'pricing')]
        [string]$Task = 'design',
        
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false, Position=1)]
        [string]$Prompt,
        
        [Parameter(Mandatory=$false)]
        [switch]$SearchPrices,
        
        [Parameter(Mandatory=$false)]
        [string]$Suppliers = "RS,Farnell,Mouser,LCSC"
    )
    
    if (-not (Test-ClaudeCode)) { return }
    
    $agentPrompt = Get-AgentPrompt -AgentName "electronics"
    if (-not $agentPrompt) { return }
    
    Write-Host "🔌 Electronics Expert Agent working..." -ForegroundColor DarkGreen
    Write-Host "   Task: $Task" -ForegroundColor Gray
    if ($SearchPrices) {
        Write-Host "   Price Search: Enabled (Suppliers: $Suppliers)" -ForegroundColor Cyan
    }
    Write-Host ""
    
    $fullPrompt = $agentPrompt
    
    # Add task-specific context
    switch ($Task) {
        'design' {
            $fullPrompt += "`n`nTASK: Complete circuit design with schematic and component selection"
            if ($Prompt) {
                $fullPrompt += "`n`nDesign Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Detailed schematic description, component selection rationale, and KiCad implementation guidance."
            if ($SearchPrices) {
                $fullPrompt += "`n`nIMPORTANT: Include comprehensive pricing from UK suppliers: $Suppliers"
            }
        }
        'debug' {
            $fullPrompt += "`n`nTASK: Debug electronics issue and provide fix"
            if ($Prompt) {
                $fullPrompt += "`n`nProblem Description:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Root cause analysis, step-by-step debugging procedure, and solution with circuit modifications if needed."
        }
        'pcb' {
            $fullPrompt += "`n`nTASK: PCB layout design and optimization"
            if ($Prompt) {
                $fullPrompt += "`n`nLayout Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Layer stackup, component placement strategy, routing guidelines, and KiCad PCB design instructions."
        }
        'bom' {
            $fullPrompt += "`n`nTASK: Generate complete Bill of Materials with UK supplier pricing and sourcing information"
            if ($Prompt) {
                $fullPrompt += "`n`nBOM Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Complete BOM in table format with:"
            $fullPrompt += "`n- Part numbers and specifications"
            $fullPrompt += "`n- Pricing in GBP from: $Suppliers"
            $fullPrompt += "`n- Stock availability and lead times"
            $fullPrompt += "`n- Volume pricing (1, 10, 100, 1000 units)"
            $fullPrompt += "`n- Alternative suppliers with price comparison"
            $fullPrompt += "`n- Total cost breakdown with VAT"
        }
        'review' {
            $fullPrompt += "`n`nTASK: Review circuit design for issues and improvements"
            if ($Prompt) {
                $fullPrompt += "`n`nReview Focus:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Comprehensive design review with potential issues, improvements, and compliance check."
        }
        'test' {
            $fullPrompt += "`n`nTASK: Design test procedures and validation methods"
            if ($Prompt) {
                $fullPrompt += "`n`nTest Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Test plan, required equipment, procedures, and acceptance criteria."
        }
        'simulate' {
            $fullPrompt += "`n`nTASK: Circuit simulation setup and analysis"
            if ($Prompt) {
                $fullPrompt += "`n`nSimulation Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: SPICE simulation setup, expected results, and analysis methodology."
        }
        'pricing' {
            $fullPrompt += "`n`nTASK: Component pricing search and cost optimization"
            if ($Prompt) {
                $fullPrompt += "`n`nComponent/Circuit:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Detailed pricing comparison across UK suppliers with cost optimization suggestions."
            $SearchPrices = $true  # Force price search for pricing task
        }
    }
    
    # Add file content if provided
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $fileContent = Get-Content $FilePath -Raw
            $fullPrompt += "`n`nFile Content:`nFile: $FilePath`n`n$fileContent"
        } else {
            Write-Error "File not found: $FilePath"
            return
        }
    }
    
    # Add pricing search instruction if enabled
    if ($SearchPrices) {
        $fullPrompt += "`n`n🔍 PRICING SEARCH REQUIRED:"
        $fullPrompt += "`nSearch the following UK suppliers for competitive pricing:"
        $supplierList = $Suppliers -split ','
        foreach ($supplier in $supplierList) {
            switch ($supplier.Trim()) {
                'RS' { $fullPrompt += "`n- RS Components UK (uk.rs-online.com)" }
                'Farnell' { $fullPrompt += "`n- Farnell UK (uk.farnell.com)" }
                'Mouser' { $fullPrompt += "`n- Mouser UK (mouser.co.uk)" }
                'Digikey' { $fullPrompt += "`n- Digikey UK (digikey.co.uk)" }
                'LCSC' { $fullPrompt += "`n- LCSC (lcsc.com) - Low cost option from China" }
                'CPC' { $fullPrompt += "`n- CPC (cpc.farnell.com)" }
                'Rapid' { $fullPrompt += "`n- Rapid Electronics (rapidonline.com)" }
            }
        }
        $fullPrompt += "`nProvide pricing in GBP (£) with VAT considerations and delivery costs."
    }
    
    try {
        $response = claude $fullPrompt
        Write-Host $response
        
        # Log interaction
        Write-AgentLog -AgentName "Electronics" -FilePath $FilePath -Prompt "$Task`: $Prompt" -Response $response
        
        # Additional helpful output
        Write-Host ""
        Write-Host "💡 Electronics Agent Tips:" -ForegroundColor DarkGreen
        Write-Host "  • Use '-SearchPrices' for component cost analysis" -ForegroundColor Gray
        Write-Host "  • Try different tasks: design, debug, pcb, bom, review" -ForegroundColor Gray
        Write-Host "  • Upload KiCad files for specific analysis" -ForegroundColor Gray
        
    }
    catch {
        Write-Error "Electronics Agent failed: $_"
    }
}

# Create wrapper functions for different use cases
function electronics-design {
    param([Parameter(Position=0)][string]$prompt)
    Invoke-ElectronicsAgent -Task design -Prompt $prompt
}

function circuit-design {
    param([Parameter(Position=0)][string]$prompt)
    Invoke-ElectronicsAgent -Task design -Prompt $prompt
}

function pcb-layout {
    param([Parameter(Position=0)][string]$prompt)
    Invoke-ElectronicsAgent -Task pcb -Prompt $prompt
}

function component-pricing {
    param([Parameter(Position=0)][string]$prompt)
    Invoke-ElectronicsAgent -Task pricing -Prompt $prompt -SearchPrices
}

function electronics-debug {
    param([Parameter(Position=0)][string]$prompt)
    Invoke-ElectronicsAgent -Task debug -Prompt $prompt
}