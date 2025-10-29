"""
Command Line Interface for AI Powerhouse
"""

import asyncio
import click
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from ai_powerhouse import AIPowerhouse


console = Console()


@click.group()
def cli():
    """AI Powerhouse - Unified interface for multiple AI providers"""
    pass


@cli.command()
@click.argument('prompt')
@click.option('--claude', 'providers', flag_value=['claude'], help='Use Claude only')
@click.option('--gemini', 'providers', flag_value=['gemini'], help='Use Gemini only')
@click.option('--openai', 'providers', flag_value=['openai'], help='Use OpenAI only')
@click.option('--all', 'providers', flag_value=None, help='Use all available providers')
def ask(prompt, providers):
    """Ask a question to AI providers"""
    async def run_ask():
        ai = AIPowerhouse()
        
        if providers is None:
            # Use all providers
            responses = await ai.ask(prompt)
        else:
            # Use specific provider
            responses = await ai.ask(prompt, providers)
        
        # Display responses
        for provider, response in responses.items():
            panel = Panel(
                response,
                title=f"[bold blue]{provider.title()}[/bold blue]",
                border_style="blue"
            )
            console.print(panel)
            console.print()
    
    asyncio.run(run_ask())


@cli.command()
def status():
    """Show status of all AI providers"""
    ai = AIPowerhouse()
    provider_info = ai.get_provider_info()
    
    table = Table(title="AI Provider Status")
    table.add_column("Provider", style="cyan")
    table.add_column("Model", style="magenta")
    table.add_column("Status", style="green")
    
    for name, info in provider_info.items():
        status = "✅ Available" if info['available'] else "❌ Not Available"
        table.add_row(name.title(), info['model'], status)
    
    console.print(table)


@cli.command()
@click.argument('prompt')
def claude(prompt):
    """Ask Claude specifically"""
    async def run_claude():
        ai = AIPowerhouse()
        response = await ai.ask_claude(prompt)
        
        panel = Panel(
            response,
            title="[bold blue]Claude[/bold blue]",
            border_style="blue"
        )
        console.print(panel)
    
    asyncio.run(run_claude())


@cli.command()
@click.argument('prompt')
def gemini(prompt):
    """Ask Gemini specifically"""
    async def run_gemini():
        ai = AIPowerhouse()
        response = await ai.ask_gemini(prompt)
        
        panel = Panel(
            response,
            title="[bold green]Gemini[/bold green]",
            border_style="green"
        )
        console.print(panel)
    
    asyncio.run(run_gemini())


@cli.command()
@click.argument('prompt')
def openai(prompt):
    """Ask OpenAI specifically"""
    async def run_openai():
        ai = AIPowerhouse()
        response = await ai.ask_openai(prompt)
        
        panel = Panel(
            response,
            title="[bold red]OpenAI[/bold red]",
            border_style="red"
        )
        console.print(panel)
    
    asyncio.run(run_openai())


if __name__ == '__main__':
    cli()
