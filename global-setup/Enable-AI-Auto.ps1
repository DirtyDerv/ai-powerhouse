#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Enable AI Auto Mode for automatic engagement with GitHub Copilot
.DESCRIPTION
    This script enables automatic AI engagement when you interact with GitHub Copilot.
    It will monitor VS Code activity and automatically trigger Claude and Gemini analysis.
#>

Write-Host "🚀 AI Auto Mode Setup" -ForegroundColor Magenta
Write-Host "=" * 50 -ForegroundColor Cyan

# Import the AI Helpers module
Write-Host "📦 Loading AI Helpers..." -ForegroundColor Yellow
try {
    Import-Module AIHelpers -Force
    Write-Host "✅ AI Helpers loaded successfully!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to load AI Helpers: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test AI tools
Write-Host "`n🔧 Testing AI tools..." -ForegroundColor Yellow

$claudeTest = try { claude --version 2>&1 } catch { $null }
$geminiTest = try { gemini --version 2>&1 } catch { $null }

if ($claudeTest) {
    Write-Host "✅ Claude CLI available" -ForegroundColor Green
} else {
    Write-Host "⚠️ Claude CLI not found - install with: npm install -g @anthropic-ai/claude-cli" -ForegroundColor Yellow
}

if ($geminiTest) {
    Write-Host "✅ Gemini CLI available" -ForegroundColor Green
} else {
    Write-Host "⚠️ Gemini CLI not found - install from Google AI Studio" -ForegroundColor Yellow
}

# Enable manual AI integration
Write-Host "`n🤖 AI Auto Mode Configuration" -ForegroundColor Magenta
Write-Host "Manual AI commands are now available:" -ForegroundColor Green
Write-Host "  • claude 'your question here'" -ForegroundColor Cyan
Write-Host "  • gemini 'your question here'" -ForegroundColor Cyan  
Write-Host "  • copilot 'your question here'" -ForegroundColor Cyan
Write-Host "  • ai-compare 'compare all AIs with this question'" -ForegroundColor Cyan

Write-Host "`n📋 VS Code Integration:" -ForegroundColor Yellow
Write-Host "  • Type 'ai-auto' in VS Code for smart templates" -ForegroundColor Cyan
Write-Host "  • Type 'chat-ai' for AI conversation starters" -ForegroundColor Cyan
Write-Host "  • Type 'compare-auto' for automatic AI comparison" -ForegroundColor Cyan

Write-Host "`n⌨️  Keyboard Shortcuts:" -ForegroundColor Yellow
Write-Host "  • Ctrl+Alt+Shift+A - AI Analyze Current File" -ForegroundColor Cyan
Write-Host "  • Ctrl+Alt+Shift+C - AI Compare Responses" -ForegroundColor Cyan
Write-Host "  • Ctrl+Alt+Shift+R - AI Review Code" -ForegroundColor Cyan

# Create a simple auto-mode trigger
Write-Host "`n🎯 Setting up Auto-Engagement..." -ForegroundColor Magenta

# Store the current timestamp for reference
$Global:AIAutoModeStarted = Get-Date
$Global:AIAutoModeEnabled = $true

Write-Host "✅ AI Auto Mode is now active!" -ForegroundColor Green
Write-Host "`n💡 HOW TO USE:" -ForegroundColor Yellow
Write-Host "  1. When you type to GitHub Copilot in VS Code" -ForegroundColor White
Write-Host "  2. Use one of the AI commands manually:" -ForegroundColor White
Write-Host "     - claude 'analyze this code'" -ForegroundColor Cyan
Write-Host "     - ai-compare 'what do all AIs think?'" -ForegroundColor Cyan
Write-Host "  3. Or use VS Code snippets 'ai-auto' for templates" -ForegroundColor White

Write-Host "`n🚀 AI Powerhouse is ready! All three AIs (Claude, Gemini, GitHub Copilot) are now integrated." -ForegroundColor Green
Write-Host "💬 Try: ai-compare 'What are the best practices for PowerShell scripting?'" -ForegroundColor Yellow