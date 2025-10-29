function Invoke-ElectronicsAgent {
    <#
    .SYNOPSIS
    Electronics design, PCB layout, circuit debugging, and component pricing expert
    
    .PARAMETER Task
    Type of electronics task
    
    .PARAMETER FilePath
    Path to KiCad project, schematic, or circuit description
    
    .PARAMETER Prompt
    Custom electronics design prompt
    
    .PARAMETER SearchPrices
    Enable automatic price search for components (requires web search)
    
    .PARAMETER Suppliers
    Comma-separated list of suppliers to check (default: RS,Farnell,Mouser,LCSC)
    
    .EXAMPLE
    Invoke-ElectronicsAgent -Task design -Prompt "Create ESP32 temperature monitor with OLED display"
    Invoke-ElectronicsAgent -Task debug -FilePath ".\project.kicad_sch" -Prompt "Circuit not working, no output on pin 5"
    Invoke-ElectronicsAgent -Task pcb -Prompt "Layout 4-layer board for motor controller"
    Invoke-ElectronicsAgent -Task bom -FilePath ".\schematic.pdf" -SearchPrices
    electronics-design "WiFi-enabled soil moisture sensor"
    search-component-prices "ESP32-WROOM-32"
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
            $fullPrompt += "`n- Shipping cost estimates"
            $fullPrompt += "`n- Best supplier recommendations"
            
            if ($SearchPrices) {
                $fullPrompt += "`n`nCRITICAL: Use web search to find current UK pricing for all components."
                $fullPrompt += "`nSearch each component at: RS Components UK, Farnell UK, Mouser UK, Digikey UK, LCSC"
                $fullPrompt += "`nProvide real, current prices in GBP (£) from actual supplier websites."
            }
        }
        'review' {
            $fullPrompt += "`n`nTASK: Review circuit design for errors and improvements"
            if ($Prompt) {
                $fullPrompt += "`n`nReview Focus:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Detailed review of power supply, signal integrity, component selection, PCB layout, and manufacturability."
        }
        'test' {
            $fullPrompt += "`n`nTASK: Create testing and validation procedures"
            if ($Prompt) {
                $fullPrompt += "`n`nTesting Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Complete test plan, equipment list, acceptance criteria, and troubleshooting guide."
        }
        'simulate' {
            $fullPrompt += "`n`nTASK: Circuit simulation and analysis"
            if ($Prompt) {
                $fullPrompt += "`n`nSimulation Requirements:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: SPICE netlist or simulation setup, expected results, and analysis of circuit behavior."
        }
        'pricing' {
            $fullPrompt += "`n`nTASK: Component price search and comparison across UK suppliers"
            if ($Prompt) {
                $fullPrompt += "`n`nComponent(s) to price:`n$Prompt"
            }
            $fullPrompt += "`n`nProvide: Comprehensive price comparison in GBP including:"
            $fullPrompt += "`n- Current pricing from: $Suppliers"
            $fullPrompt += "`n- Stock levels and availability"
            $fullPrompt += "`n- Volume pricing breaks"
            $fullPrompt += "`n- Delivery times and costs"
            $fullPrompt += "`n- Alternative/equivalent components"
            $fullPrompt += "`n- Best value recommendation"
            $fullPrompt += "`n`nUse web search to get current real-world pricing."
        }
    }
    
    # Add currency and pricing context
    $fullPrompt += "`n`n=== PRICING REQUIREMENTS ==="
    $fullPrompt += "`nCurrency: GBP (£) - British Pounds Sterling"
    $fullPrompt += "`nPrices: Exclude VAT (add 20% for UK customers)"
    $fullPrompt += "`nSuppliers Priority: UK/EU suppliers first, then international"
    $fullPrompt += "`nShipping: Include UK delivery estimates"
    
    # Add file content if provided
    if ($FilePath) {
        if (Test-Path $FilePath) {
            $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
            
            # Handle different file types
            if ($extension -match '\.(kicad_sch|kicad_pcb|kicad_pro)$') {
                $fullPrompt += "`n`nKiCad Project File: $FilePath`n"
                $fileContent = Get-Content $FilePath -Raw
                $fullPrompt += "`n$fileContent"
            }
            elseif ($extension -match '\.(sch|brd|pcb)$') {
                $fullPrompt += "`n`nCircuit File: $FilePath`n"
                $fileContent = Get-Content $FilePath -Raw
                $fullPrompt += "`n$fileContent"
            }
            elseif ($extension -match '\.(txt|md|csv)$') {
                $fullPrompt += "`n`nDesign Document: $FilePath`n"
                $fileContent = Get-Content $FilePath -Raw
                $fullPrompt += "`n$fileContent"
            }
            elseif ($extension -match '\.(pdf|png|jpg|jpeg)$') {
                $fullPrompt += "`n`nImage/PDF File: $FilePath (provide description or extract text if able)`n"
            }
            else {
                $fullPrompt += "`n`nFile: $FilePath`n"
                $fileContent = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
                if ($fileContent) {
                    $fullPrompt += "`n$fileContent"
                }
            }
        } else {
            Write-Warning "File not found: $FilePath"
            Write-Host "Continuing without file input..." -ForegroundColor Yellow
        }
    }
    
    # Execute agent
    try {
        $response = claude-code $fullPrompt
        Write-Host $response
        
        # Log interaction
        Write-AgentLog -AgentName "Electronics" -FilePath $FilePath -Prompt "$Task : $Prompt" -Response $response
        
        Write-Host ""
        Write-Host "💡 Tips: " -ForegroundColor Cyan
        Write-Host "   • Save KiCad files and schematics for version control" -ForegroundColor Gray
        Write-Host "   • Use -SearchPrices flag for BOM tasks to get current UK pricing" -ForegroundColor Gray
        Write-Host "   • Compare multiple suppliers before ordering" -ForegroundColor Gray
        Write-Host "   • Check LCSC for lowest prices (longer delivery from China)" -ForegroundColor Gray
    }
    catch {
        Write-Error "Electronics Agent failed: $_"
    }
}

# Helper function for component price search
function Search-ComponentPrices {
    <#
    .SYNOPSIS
    Search for component prices across UK suppliers
    
    .PARAMETER Component
    Component manufacturer part number or description
    
    .PARAMETER Suppliers
    Comma-separated list of suppliers to check
    
    .EXAMPLE
    Search-ComponentPrices "ESP32-WROOM-32"
    Search-ComponentPrices "AMS1117-3.3" -Suppliers "RS,Farnell,Mouser"
    price-search "STM32F103C8T6"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Component,
        
        [Parameter(Mandatory=$false)]
        [string]$Suppliers = "RS,Farnell,Mouser,Digikey,LCSC"
    )
    
    Write-Host "🔍 Searching prices for: $Component" -ForegroundColor Cyan
    Write-Host "   Suppliers: $Suppliers" -ForegroundColor Gray
    Write-Host ""
    
    # Use electronics agent in pricing mode
    Invoke-ElectronicsAgent -Task pricing -Prompt $Component -SearchPrices -Suppliers $Suppliers
}

# Helper function to generate BOM with automatic pricing
function New-ElectronicsBOM {
    <#
    .SYNOPSIS
    Generate Bill of Materials with UK supplier pricing
    
    .PARAMETER FilePath
    Path to schematic or component list
    
    .PARAMETER OutputFormat
    Output format (csv, xlsx, markdown)
    
    .EXAMPLE
    New-ElectronicsBOM -FilePath ".\project.kicad_sch"
    New-ElectronicsBOM -FilePath ".\components.txt" -OutputFormat xlsx
    generate-bom ".\schematic.pdf"
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('csv', 'xlsx', 'markdown', 'html')]
        [string]$OutputFormat = 'csv'
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    
    Write-Host "📦 Generating BOM with UK pricing..." -ForegroundColor DarkGreen
    Write-Host "   Input: $FilePath" -ForegroundColor Gray
    Write-Host "   Output Format: $OutputFormat" -ForegroundColor Gray
    Write-Host ""
    
    # Use electronics agent in BOM mode with price search
    Invoke-ElectronicsAgent -Task bom -FilePath $FilePath -SearchPrices -Prompt "Generate BOM in $OutputFormat format with comprehensive UK supplier pricing"
    
    Write-Host ""
    Write-Host "💾 Save the output to a file for import into Excel or KiCad" -ForegroundColor Cyan
}

# Helper function to compare UK supplier prices
function Compare-SupplierPrices {
    <#
    .SYNOPSIS
    Compare prices across UK suppliers for a list of components
    
    .PARAMETER ComponentList
    Array of component part numbers
    
    .PARAMETER Quantity
    Quantity to price for
    
    .EXAMPLE
    Compare-SupplierPrices -ComponentList @("ESP32-WROOM-32", "AMS1117-3.3") -Quantity 10
    compare-prices @("STM32F103", "74HC595") -Quantity 100
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string[]]$ComponentList,
        
        [Parameter(Mandatory=$false)]
        [int]$Quantity = 1
    )
    
    Write-Host "📊 Comparing prices for $($ComponentList.Count) components at quantity: $Quantity" -ForegroundColor Cyan
    Write-Host ""
    
    $prompt = "Compare UK supplier pricing for these components at quantity $Quantity :`n"
    $prompt += ($ComponentList | ForEach-Object { "- $_" }) -join "`n"
    $prompt += "`n`nProvide a comparison table showing best prices in GBP from RS Components, Farnell, Mouser UK, Digikey UK, and LCSC."
    
    Invoke-ElectronicsAgent -Task pricing -Prompt $prompt -SearchPrices
}

# Helper function to find cheapest supplier for a BOM
function Get-CheapestSupplier {
    <#
    .SYNOPSIS
    Analyze BOM and recommend cheapest supplier mix
    
    .PARAMETER BOMFile
    Path to BOM file (CSV, Excel, or text)
    
    .PARAMETER Quantity
    Production quantity
    
    .EXAMPLE
    Get-CheapestSupplier -BOMFile ".\bom.csv" -Quantity 100
    cheapest-supplier ".\project_bom.xlsx" -Quantity 1000
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$BOMFile,
        
        [Parameter(Mandatory=$false)]
        [int]$Quantity = 1
    )
    
    if (-not (Test-Path $BOMFile)) {
        Write-Error "BOM file not found: $BOMFile"
        return
    }
    
    Write-Host "💰 Finding cheapest supplier mix for $Quantity units..." -ForegroundColor DarkGreen
    Write-Host ""
    
    $prompt = "Analyze this BOM and recommend the cheapest supplier mix for $Quantity units. "
    $prompt += "Consider: component prices, shipping costs, minimum orders, and delivery times. "
    $prompt += "Provide cost breakdown for: 1) single supplier, 2) multi-supplier optimal mix."
    
    Invoke-ElectronicsAgent -Task bom -FilePath $BOMFile -SearchPrices -Prompt $prompt
}

# Create aliases
Set-Alias -Name electronics-design -Value Invoke-ElectronicsAgent
Set-Alias -Name pcb-design -Value Invoke-ElectronicsAgent
Set-Alias -Name circuit-debug -Value Invoke-ElectronicsAgent
Set-Alias -Name price-search -Value Search-ComponentPrices
Set-Alias -Name generate-bom -Value New-ElectronicsBOM
Set-Alias -Name compare-prices -Value Compare-SupplierPrices
Set-Alias -Name cheapest-supplier -Value Get-CheapestSupplier

# Export functions
Export-ModuleMember -Function Invoke-ElectronicsAgent, Search-ComponentPrices, New-ElectronicsBOM, Compare-SupplierPrices, Get-CheapestSupplier
Export-ModuleMember -Alias electronics-design, pcb-design, circuit-debug, price-search, generate-bom, compare-prices, cheapest-supplier
