"""
Basic usage examples for AI Powerhouse
"""

import asyncio
from ai_powerhouse import AIPowerhouse


async def basic_example():
    """Basic usage example"""
    print("🤖 AI Powerhouse - Basic Example")
    print("=" * 40)
    
    # Initialize
    ai = AIPowerhouse()
    
    # Check available providers
    providers = ai.get_available_providers()
    if not providers:
        print("❌ No providers available. Please configure API keys in .env file.")
        return
    
    print(f"Available providers: {', '.join(providers)}")
    
    # Ask a simple question
    prompt = "What is artificial intelligence?"
    print(f"\nPrompt: {prompt}")
    print("-" * 40)
    
    responses = await ai.ask(prompt)
    
    for provider, response in responses.items():
        print(f"\n🤖 {provider.title()}:")
        print(response[:300] + "..." if len(response) > 300 else response)


async def individual_provider_example():
    """Example using individual providers"""
    print("\n\n🎯 Individual Provider Examples")
    print("=" * 40)
    
    ai = AIPowerhouse()
    
    # Test each provider individually
    prompt = "Write a Python function to calculate factorial"
    
    # Claude
    claude_response = await ai.ask_claude(prompt)
    print(f"\n🔵 Claude:\n{claude_response[:200]}...")
    
    # Gemini
    gemini_response = await ai.ask_gemini(prompt)
    print(f"\n🟢 Gemini:\n{gemini_response[:200]}...")
    
    # OpenAI
    openai_response = await ai.ask_openai(prompt)
    print(f"\n🔴 OpenAI:\n{openai_response[:200]}...")


if __name__ == "__main__":
    asyncio.run(basic_example())
    asyncio.run(individual_provider_example())
