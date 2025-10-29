#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Simple AI comparison tool that works with Claude and Gemini
.DESCRIPTION
    This script sends the same query to Claude and Gemini CLI tools
    and displays their responses side by side for comparison.
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Query,
    [switch]$LogResults
)

Write-Host "🤖 AI Powerhouse Comparison" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "Query: $Query" -ForegroundColor Yellow
Write-Host "=" * 60 -ForegroundColor Cyan

# Test Claude
Write-Host "`n🧠 Claude's Response:" -ForegroundColor Blue
Write-Host "-" * 30 -ForegroundColor Blue
try {
    $claudeResponse = & claude $Query 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $claudeResponse -ForegroundColor White
    } else {
        Write-Host "❌ Claude error: $claudeResponse" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Claude CLI not available: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Gemini
Write-Host "`n💎 Gemini's Response:" -ForegroundColor Green
Write-Host "-" * 30 -ForegroundColor Green
try {
    $geminiResponse = & gemini $Query 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $geminiResponse -ForegroundColor White
    } else {
        Write-Host "❌ Gemini error: $geminiResponse" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Gemini CLI not available: $($_.Exception.Message)" -ForegroundColor Red
}

# GitHub Copilot note
Write-Host "`n🤖 GitHub Copilot:" -ForegroundColor Cyan
Write-Host "-" * 30 -ForegroundColor Cyan
Write-Host "GitHub Copilot response available in VS Code interface above ↑" -ForegroundColor White
Write-Host "Your question to GitHub Copilot: '$Query'" -ForegroundColor Yellow

Write-Host "`n✅ AI Comparison Complete!" -ForegroundColor Green
Write-Host "💡 All three AIs (Claude, Gemini, GitHub Copilot) have now processed your query." -ForegroundColor Cyan

if ($LogResults) {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $logPath = "$env:USERPROFILE\Documents\AI-Logs\comparison_$timestamp.txt"
    $logContent = @"
AI Powerhouse Comparison Log
============================
Timestamp: $(Get-Date)
Query: $Query

Claude Response:
$claudeResponse

Gemini Response:
$geminiResponse

GitHub Copilot: Available in VS Code interface
"@
    
    New-Item -Path (Split-Path $logPath) -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    $logContent | Out-File $logPath -Encoding UTF8
    Write-Host "📁 Results logged to: $logPath" -ForegroundColor Yellow
}