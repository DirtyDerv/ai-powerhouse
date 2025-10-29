# AI Powerhouse Copilot Instructions

This workspace contains an AI Powerhouse project that integrates multiple AI providers:
- **Claude** (Anthropic)
- **Google Gemini CLI** 
- **OpenAI Codex**

## Project Structure

- `ai_powerhouse/` - Main package containing core functionality
- `ai_powerhouse/providers/` - AI provider implementations
- `examples/` - Usage examples and demonstrations
- `tests/` - Unit tests
- `cli.py` - Command-line interface
- `main.py` - Main application entry point
- `setup.py` - Environment setup script

## Setup Instructions

1. ✅ Create `.env` file: Copy `.env.example` to `.env`
2. ✅ Add API keys to `.env` file
3. ✅ Install dependencies: All packages installed in virtual environment
4. ✅ Run setup: Use VS Code task "Setup Environment" or `python setup.py`
5. ✅ Test application: Use VS Code task "Run AI Powerhouse" or `python main.py`

## Available VS Code Tasks

- **Run AI Powerhouse** - Execute the main application
- **Setup Environment** - Run initial setup script
- **Run CLI** - Test the command-line interface

## Quick Start

```python
from ai_powerhouse import AIPowerhouse

# Initialize with your API keys in .env
ai = AIPowerhouse()

# Ask all providers
responses = await ai.ask("Your question here")

# Ask specific provider
claude_response = await ai.ask_claude("Your question")
```

All dependencies are installed and the project is ready to use once API keys are configured.
