"""
Setup script for AI Powerhouse
"""

import os
import shutil
from pathlib import Path


def setup_environment():
    """Set up the AI Powerhouse environment"""
    print("🚀 Setting up AI Powerhouse...")
    
    # Create .env file from template
    env_example = Path(".env.example")
    env_file = Path(".env")
    
    if env_example.exists() and not env_file.exists():
        shutil.copy(env_example, env_file)
        print("✅ Created .env file from template")
        print("📝 Please edit .env file and add your API keys:")
        print("   - ANTHROPIC_API_KEY (for Claude)")
        print("   - GOOGLE_API_KEY (for Gemini)")
        print("   - OPENAI_API_KEY (for OpenAI)")
    elif env_file.exists():
        print("✅ .env file already exists")
    else:
        print("❌ .env.example not found")
    
    # Create directories
    directories = ["logs", "cache", "temp"]
    for directory in directories:
        Path(directory).mkdir(exist_ok=True)
        print(f"✅ Created {directory}/ directory")
    
    print("\n🎉 Setup complete!")
    print("\nNext steps:")
    print("1. Edit .env file with your API keys")
    print("2. Install dependencies: pip install -r requirements.txt")
    print("3. Run the application: python main.py")
    print("4. Or use CLI: python cli.py --help")


if __name__ == "__main__":
    setup_environment()
