# Electronics Agent - UK Pricing & Component Search Guide

## Overview
The Electronics Agent now includes comprehensive UK supplier pricing, automatic price search, and multi-supplier comparison capabilities - all in GBP (£).

---

## UK Supplier Integration

### Supported Suppliers (in priority order):

1. **RS Components UK** (uk.rs-online.com)
   - ✓ Next-day delivery across UK
   - ✓ Excellent stock levels
   - ✓ Educational discounts available
   - Free shipping: Orders over £50

2. **Farnell/Element14 UK** (uk.farnell.com)
   - ✓ Huge component range
   - ✓ Competitive pricing
   - ✓ Fast UK delivery
   - Free shipping: Orders over £33

3. **Mouser UK** (mouser.co.uk)
   - ✓ Latest components
   - ✓ Ships from EU warehouse
   - ✓ Excellent for new designs
   - Free shipping: Orders over £50

4. **Digikey UK** (digikey.co.uk)
   - ✓ Comprehensive catalog
   - ✓ Excellent search tools
   - ✓ Full reel quantities
   - Free shipping: Orders over £50

5. **LCSC** (lcsc.com)
   - ✓ Very low prices (50-70% cheaper)
   - ✓ Huge stock from China
   - ✓ JLCPCB assembly integration
   - Shipping: ~£15-25 (7-14 days)

6. **CPC** (cpc.farnell.com)
   - ✓ Great for cables, tools, enclosures
   - ✓ Good mechanical component selection

7. **Rapid Electronics** (rapidonline.com)
   - ✓ Maker-friendly selection
   - ✓ Good for prototyping

---

## New Functions & Commands

### 1. Basic Electronics Design (with pricing)
```powershell
# Design with automatic UK pricing
electronics-design "ESP32 temperature sensor with OLED" -SearchPrices

# Quick design command
ed "Arduino motor controller board"
```

### 2. Component Price Search
```powershell
# Search single component across all UK suppliers
price-search "ESP32-WROOM-32"
Search-ComponentPrices "STM32F103C8T6"

# Search with specific suppliers
price-search "AMS1117-3.3" -Suppliers "RS,Farnell,Mouser"
```

### 3. Generate BOM with Pricing
```powershell
# Generate BOM from schematic with UK prices
generate-bom ".\project.kicad_sch"
New-ElectronicsBOM -FilePath ".\schematic.pdf"

# Generate BOM in specific format
generate-bom ".\design.txt" -OutputFormat xlsx
```

### 4. Compare Supplier Prices
```powershell
# Compare multiple components
compare-prices @("ESP32-WROOM-32", "AMS1117-3.3", "STM32F103") -Quantity 10

# Full comparison
Compare-SupplierPrices -ComponentList @("Component1", "Component2") -Quantity 100
```

### 5. Find Cheapest Supplier
```powershell
# Analyze BOM and find best supplier mix
cheapest-supplier ".\bom.csv" -Quantity 100
Get-CheapestSupplier -BOMFile ".\project_bom.xlsx" -Quantity 1000
```

### 6. Generate BOM with Full Pricing Analysis
```powershell
# Complete BOM generation with price search
Invoke-ElectronicsAgent -Task bom -FilePath ".\schematic.kicad_sch" -SearchPrices
```

---

## Usage Examples

### Example 1: Design New Circuit with UK Pricing
```powershell
# Design circuit and get UK component pricing
electronics-design "WiFi-enabled soil moisture sensor with ESP32, capacitive sensor, and solar charging" -SearchPrices

# Output includes:
# - Complete circuit design
# - Component selection
# - UK supplier pricing in GBP
# - Stock availability
# - Alternative components
# - Total cost breakdown
```

### Example 2: Price Check for Existing BOM
```powershell
# You have a BOM and want current UK prices
generate-bom ".\existing_bom.csv"

# Output includes:
# - Current prices from RS, Farnell, Mouser, LCSC
# - Stock levels
# - Volume pricing (1, 10, 100, 1000 units)
# - Delivery times
# - Total cost comparison
# - Best supplier recommendation
```

### Example 3: Compare Component Prices
```powershell
# Compare prices for multiple components
compare-prices @(
    "ESP32-WROOM-32",
    "AMS1117-3.3", 
    "STM32F103C8T6",
    "74HC595D"
) -Quantity 50

# Output shows:
# Side-by-side comparison from all suppliers
# Best price highlighted
# Total savings calculation
# Delivery time comparison
```

### Example 4: Find Cheapest Way to Build
```powershell
# Analyze complete BOM for best sourcing strategy
cheapest-supplier ".\complete_bom.csv" -Quantity 100

# Output shows:
# Option 1: Single supplier (convenience)
# Option 2: Multi-supplier optimal (cheapest)
# Option 3: LCSC bulk (lowest, longer wait)
# Shipping costs included
# Total cost comparison with VAT
```

### Example 5: Quick Component Search
```powershell
# Just want to know price and availability
price-search "ESP32-WROOM-32"

# Output:
# RS Components:  £2.85 (500+ in stock) - Next day
# Farnell:        £3.10 (250+ in stock) - Next day  
# Mouser UK:      £2.65 (1000+ in stock) - 1-2 days
# Digikey UK:     £2.90 (800+ in stock) - 1-2 days
# LCSC:           £1.45 (5000+ in stock) - 7-14 days
# BEST: LCSC at £1.45 (saves £1.40 but longer delivery)
# UK BEST: Mouser at £2.65 (saves £0.45 vs RS)
```

### Example 6: Complete Project Workflow
```powershell
# 1. Design the circuit
electronics-design "Battery-powered GPS tracker with LoRa" -SearchPrices

# 2. Get the BOM with prices
generate-bom ".\gps_tracker.kicad_sch"

# 3. Find best supplier mix
cheapest-supplier ".\gps_tracker_bom.csv" -Quantity 10

# 4. Order decision made! You now know:
# - What to buy from RS (urgent, next-day)
# - What to buy from LCSC (cheap, can wait)
# - Total cost breakdown
# - When components will arrive
```

---

## BOM Output Format

The agent generates BOMs in this comprehensive format:

```
📦 BILL OF MATERIALS (BOM)

Pricing Date: 2024-10-29
Currency: GBP (£) - Prices exclude VAT

╔═══════════════════════════════════════════════════════════════════════════╗
║  Component Price Comparison                                               ║
╚═══════════════════════════════════════════════════════════════════════════╝

Component: ESP32-WROOM-32 (WiFi/BT Module)
┌─────────────────┬──────────┬───────────┬──────────┬───────────┬──────────┐
│ Supplier        │ Unit (1) │ Unit (10) │ Unit(100)│ Stock     │ Delivery │
├─────────────────┼──────────┼───────────┼──────────┼───────────┼──────────┤
│ RS Components   │ £2.85    │ £2.65     │ £2.45    │ 500+      │ Next day │
│ Farnell         │ £3.10    │ £2.95     │ £2.70    │ 250+      │ Next day │
│ Mouser UK       │ £2.65    │ £2.50     │ £2.30    │ 1000+     │ 1-2 days │
│ Digikey UK      │ £2.90    │ £2.75     │ £2.50    │ 800+      │ 1-2 days │
│ LCSC            │ £1.45    │ £1.35     │ £1.25    │ 5000+     │ 7-14 days│
└─────────────────┴──────────┴───────────┴──────────┴───────────┴──────────┘
✓ BEST PRICE: LCSC £1.45 (49% savings vs RS)
✓ UK BEST: Mouser £2.65 (7% savings vs RS)

[Continues for all components...]

╔═══════════════════════════════════════════════════════════════════════════╗
║  Complete BOM Summary                                                      ║
╚═══════════════════════════════════════════════════════════════════════════╝

Total Components: 45
Unique Part Numbers: 32

COST BREAKDOWN BY QUANTITY:
┌──────────┬────────────────┬───────────────┬──────────────┬───────────────┐
│ Quantity │ BOM (excl VAT) │ BOM (inc VAT) │ Per Unit     │ Best Supplier │
├──────────┼────────────────┼───────────────┼──────────────┼───────────────┤
│ 1        │ £45.50         │ £54.60        │ £45.50       │ RS + Farnell  │
│ 10       │ £385.00        │ £462.00       │ £38.50       │ Farnell+LCSC  │
│ 100      │ £3,200.00      │ £3,840.00     │ £32.00       │ LCSC+Mouser   │
│ 1000     │ £28,500.00     │ £34,200.00    │ £28.50       │ LCSC          │
└──────────┴────────────────┴───────────────┴──────────────┴───────────────┘

SUPPLIER STRATEGIES:

Strategy 1: FASTEST (Next-Day UK Delivery)
- RS Components: £48.50
- Total with shipping: £48.50 (free over £50, add £6 for single board)
- Delivery: Tomorrow
- Best for: Urgent prototypes

Strategy 2: BALANCED (Best UK Value)
- Farnell (80% of parts): £38.00
- Mouser UK (20% of parts): £9.50
- Total with shipping: £47.50
- Delivery: 1-2 days
- Best for: Normal prototyping

Strategy 3: CHEAPEST (Mixed UK/China)
- LCSC (passive components): £12.00
- Mouser UK (ICs and modules): £25.50
- Total with shipping: £52.50
- Delivery: 7-14 days (wait for LCSC)
- Best for: Budget projects, can wait

Strategy 4: PRODUCTION (Bulk from China)
- LCSC (all components): £28.50
- Total with shipping: £43.50 (consolidated shipping)
- Delivery: 7-14 days
- Best for: Production runs >50 units

SHIPPING ESTIMATES:
- RS Components: FREE (order is £48.50)
- Farnell: FREE (order over £33)
- Mouser UK: £9.50 (under £50 threshold)
- LCSC: ~£15-20 via DHL (7-10 days)

RECOMMENDED ACTION FOR PROTOTYPE (qty 1):
→ Order from RS Components (£48.50 total, arrives tomorrow)
→ OR split between Farnell + one LCSC order for future builds
```

---

## Price Search Features

### Automatic Web Search
When `-SearchPrices` flag is used, the agent will:
1. Search actual UK supplier websites
2. Get real-time pricing and stock levels
3. Compare across multiple suppliers
4. Calculate total costs including shipping
5. Recommend optimal sourcing strategy

### Manual Price Search
Use dedicated `price-search` command for quick lookups:
```powershell
price-search "STM32F103C8T6"
```

### Volume Pricing
All price searches include volume breaks:
- 1 unit (prototyping)
- 10 units (small batch)
- 100 units (production pilot)
- 1000+ units (volume production)

---

## Cost Optimization Tips

### 1. Prototype vs Production
```powershell
# Prototype (speed matters)
electronics-design "design..." -SearchPrices
# Order from RS/Farnell for next-day

# Production (cost matters)
generate-bom "design.kicad_sch"
cheapest-supplier "bom.csv" -Quantity 100
# Order from LCSC + necessary items from UK
```

### 2. Shipping Optimization
- **RS Components**: Free over £50
- **Farnell**: Free over £33
- **Mouser UK**: Free over £50
- **Tip**: Combine orders to hit free shipping threshold

### 3. LCSC Strategy
- Order passive components from LCSC (cheapest)
- Order ICs/modules from UK suppliers (faster, safer)
- Use JLCPCB assembly with LCSC parts for best value

### 4. Educational Discounts
- RS Components offers education pricing
- Farnell has student/educator accounts
- Mention if designing for education

---

## VS Code Integration

### Keyboard Shortcuts
Add these to your `keybindings.json`:

```json
{
  "key": "ctrl+shift+alt+e",
  "command": "workbench.action.tasks.runTask",
  "args": "Electronics: Design Circuit"
},
{
  "key": "ctrl+shift+alt+m",
  "command": "workbench.action.tasks.runTask",
  "args": "Electronics: Generate BOM"
},
{
  "key": "ctrl+shift+alt+$",
  "command": "workbench.action.tasks.runTask",
  "args": "Electronics: Price Search"
}
```

### Tasks
Add to `tasks.json`:

```json
{
  "label": "Electronics: Generate BOM with UK Pricing",
  "type": "shell",
  "command": "powershell",
  "args": [
    "-Command",
    "generate-bom '${file}'"
  ]
},
{
  "label": "Electronics: Price Search",
  "type": "shell",
  "command": "powershell",
  "args": [
    "-Command",
    "price-search '${input:componentPartNumber}'"
  ]
},
{
  "label": "Electronics: Find Cheapest Supplier",
  "type": "shell",
  "command": "powershell",
  "args": [
    "-Command",
    "cheapest-supplier '${file}' -Quantity ${input:quantity}"
  ]
}
```

---

## Troubleshooting

### Price Search Not Working?
```powershell
# Verify web search capability
claude-code "search web for ESP32-WROOM-32 UK price"

# If that works, use -SearchPrices flag
electronics-design "project..." -SearchPrices
```

### Prices Seem Wrong?
- Prices are indicative and change frequently
- Always verify on supplier website before ordering
- Check for bulk pricing and promotions
- VAT is typically excluded from quoted prices

### Component Not Found?
```powershell
# Try alternative part numbers
price-search "ESP32" # broader search

# Search by description
electronics-design "I need a 3.3V LDO regulator" -SearchPrices
```

---

## Advanced Usage

### Custom Supplier List
```powershell
# Only check specific suppliers
electronics-design "project..." -SearchPrices -Suppliers "RS,Farnell"

# Check budget suppliers only
price-search "component" -Suppliers "LCSC,AliExpress"
```

### Batch Price Checking
```powershell
# Create component list file
$components = @(
    "ESP32-WROOM-32",
    "STM32F103C8T6",
    "AMS1117-3.3",
    "74HC595D"
)

# Check all prices
$components | ForEach-Object {
    Write-Host "`n=== $_ ===" -ForegroundColor Cyan
    price-search $_
    Start-Sleep -Seconds 2
}
```

### Export to Excel
```powershell
# Generate BOM and save output
generate-bom "project.kicad_sch" -OutputFormat xlsx > bom_output.txt

# Or redirect to file
Invoke-ElectronicsAgent -Task bom -FilePath "design.txt" -SearchPrices | 
    Out-File "bom_with_pricing.txt"
```

---

## Quick Reference

### All Commands
```powershell
# Design with pricing
electronics-design "description" -SearchPrices

# Generate BOM
generate-bom "file.kicad_sch"

# Search component price
price-search "part-number"

# Compare prices
compare-prices @("part1", "part2") -Quantity 10

# Find cheapest supplier
cheapest-supplier "bom.csv" -Quantity 100

# Debug circuit
circuit-debug -Task debug -FilePath "file" -Prompt "problem"

# PCB layout
pcb-design -Task pcb -Prompt "requirements"
```

### Quick Shortcuts
```powershell
ed "design"          # electronics-design
pd "pcb req"         # pcb-design  
cd "debug"           # circuit-debug
```

---

## Tips for Best Results

1. **Be Specific**: "ESP32-WROOM-32" better than "ESP32"
2. **Include Specs**: "3.3V 1A LDO regulator" helps find alternatives
3. **Check Multiple Sources**: Prices vary significantly
4. **Consider Lead Time**: Factor delivery time into decisions
5. **Bulk Orders**: LCSC for passive components in quantity
6. **UK Rush Jobs**: RS/Farnell for next-day delivery
7. **Keep BOMs Updated**: Re-run pricing before each order

---

## Support & Resources

### Supplier Websites
- RS Components: https://uk.rs-online.com
- Farnell: https://uk.farnell.com
- Mouser UK: https://www.mouser.co.uk
- Digikey UK: https://www.digikey.co.uk
- LCSC: https://www.lcsc.com

### Price Comparison Tools
- Octopart: https://octopart.com (multi-supplier search)
- Findchips: https://www.findchips.com
- SiliconExpert: For obsolescence checking

### Additional Help
```powershell
# Get help on any function
Get-Help Search-ComponentPrices -Detailed
Get-Help Invoke-ElectronicsAgent -Examples

# Agent help
agent-help
```

---

**Happy building! 🔌⚡💷**
