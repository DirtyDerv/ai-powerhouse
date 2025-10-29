"""
Main entry point for AI Powerhouse
"""

import asyncio
from ai_powerhouse import AIPowerhouse


async def main():
    """Main function demonstrating AI Powerhouse usage"""
    # Initialize AI Powerhouse
    ai = AIPowerhouse()
    
    # Check available providers
    providers = ai.get_available_providers()
    print(f"Available providers: {', '.join(providers)}")
    
    if not providers:
        print("No API keys configured. Please set up your .env file with API keys.")
        return
    
    # Show provider status
    provider_info = ai.get_provider_info()
    print("\nProvider Status:")
    for name, info in provider_info.items():
        status = "✅" if info['available'] else "❌"
        print(f"  {status} {name.title()}: {info['model']}")
    
    # Example usage
    prompt = "Write a simple 'Hello, World!' function in Python"
    print(f"\nAsking all providers: '{prompt}'")
    
    responses = await ai.ask(prompt)
    
    print("\nResponses:")
    for provider, response in responses.items():
        print(f"\n--- {provider.title()} ---")
        print(response[:200] + "..." if len(response) > 200 else response)


if __name__ == "__main__":
    asyncio.run(main())
