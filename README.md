# AI Powerhouse

A unified AI assistant system integrating multiple AI services:
- **Claude** - Anthropic's AI assistant
- **Google Gemini CLI** - Google's AI model
- **OpenAI Codex** - OpenAI's code generation model

## Features

- Unified API interface for multiple AI providers
- CLI tool for easy interaction
- Configuration management for API keys
- Response comparison and selection
- Extensible architecture for adding new AI providers

## Installation

1. Clone this repository
2. Install dependencies: `pip install -r requirements.txt`
3. Set up your API keys in `.env` file
4. Run the application: `python main.py`

## Configuration

Create a `.env` file with your API keys:

```
ANTHROPIC_API_KEY=your_claude_api_key
GOOGLE_API_KEY=your_gemini_api_key
OPENAI_API_KEY=your_openai_api_key
```

## Usage

```python
from ai_powerhouse import AIPowerhouse

# Initialize the AI powerhouse
ai = AIPowerhouse()

# Ask a question to all providers
response = ai.ask("Write a Python function to calculate fibonacci numbers")

# Get response from specific provider
claude_response = ai.ask_claude("Explain machine learning concepts")
gemini_response = ai.ask_gemini("Help me debug this code")
openai_response = ai.ask_openai("Generate a REST API endpoint")
```

## CLI Usage

```bash
# Ask all providers
python cli.py --all "What is quantum computing?"

# Ask specific provider
python cli.py --claude "Write a poem about AI"
python cli.py --gemini "Explain neural networks"
python cli.py --openai "Generate JavaScript code"
```
