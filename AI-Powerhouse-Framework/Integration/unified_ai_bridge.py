"""
AI Powerhouse Framework - Cross-System Integration Bridge

This module provides seamless integration between:
- Python AI Powerhouse (multi-provider AI)
- PowerShell Claude Agents (specialized development agents)

Enables Python to call PowerShell agents and PowerShell to use Python AI providers.
"""

import subprocess
import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Optional, Any
import logging

class PowerShellAgentBridge:
    """Bridge to execute PowerShell Claude Agents from Python"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.powershell_path = self._find_powershell()
        self.agents_available = self._check_agents_available()
        
    def _find_powershell(self) -> str:
        """Find PowerShell 7+ executable"""
        possible_paths = [
            "pwsh.exe",  # PowerShell 7+ in PATH
            "powershell.exe",  # Windows PowerShell fallback
            r"C:\Program Files\PowerShell\7\pwsh.exe",
            r"C:\Program Files (x86)\PowerShell\7\pwsh.exe"
        ]
        
        for path in possible_paths:
            try:
                result = subprocess.run([path, "-Version"], 
                                      capture_output=True, text=True, timeout=5)
                if result.returncode == 0:
                    return path
            except (subprocess.TimeoutExpired, FileNotFoundError):
                continue
                
        raise RuntimeError("PowerShell not found. Please install PowerShell 7+")
    
    def _check_agents_available(self) -> bool:
        """Check if Claude Agents module is available"""
        try:
            cmd = [
                self.powershell_path, 
                "-Command", 
                "Get-Module -ListAvailable -Name ClaudeAgents | Select-Object -First 1"
            ]
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
            return result.returncode == 0 and "ClaudeAgents" in result.stdout
        except:
            return False
    
    def list_agents(self) -> List[str]:
        """Get list of available Claude Agents"""
        if not self.agents_available:
            return []
            
        try:
            cmd = [
                self.powershell_path,
                "-Command",
                "Import-Module ClaudeAgents -Force; agent-help | Out-String"
            ]
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=15)
            
            if result.returncode == 0:
                # Parse agent names from help output
                agents = []
                for line in result.stdout.split('\n'):
                    if 'Expert' in line and '→' in line:
                        agent_name = line.split('→')[0].strip()
                        agents.append(agent_name)
                return agents
            return []
        except Exception as e:
            self.logger.error(f"Failed to list agents: {e}")
            return []
    
    def execute_agent(self, agent_command: str, prompt: str, file_path: Optional[str] = None) -> Dict[str, Any]:
        """
        Execute a Claude Agent from Python
        
        Args:
            agent_command: The agent command (e.g., 'security-review', 'electronics-design')
            prompt: The prompt/question for the agent
            file_path: Optional file path for file-based analysis
            
        Returns:
            Dict with 'success', 'output', 'error' keys
        """
        if not self.agents_available:
            return {
                'success': False,
                'output': '',
                'error': 'Claude Agents module not available'
            }
        
        try:
            # Build PowerShell command
            if file_path and os.path.exists(file_path):
                ps_command = f'Import-Module ClaudeAgents -Force; {agent_command} -FilePath "{file_path}" -Prompt "{prompt}"'
            else:
                ps_command = f'Import-Module ClaudeAgents -Force; {agent_command} "{prompt}"'
            
            cmd = [self.powershell_path, "-Command", ps_command]
            
            result = subprocess.run(
                cmd, 
                capture_output=True, 
                text=True, 
                timeout=120,  # 2 minutes timeout for AI responses
                encoding='utf-8',
                errors='replace'
            )
            
            return {
                'success': result.returncode == 0,
                'output': result.stdout,
                'error': result.stderr if result.returncode != 0 else ''
            }
            
        except subprocess.TimeoutExpired:
            return {
                'success': False,
                'output': '',
                'error': 'Agent execution timed out (2 minutes)'
            }
        except Exception as e:
            return {
                'success': False,
                'output': '',
                'error': f'Execution failed: {str(e)}'
            }
    
    def security_review(self, prompt: str, file_path: Optional[str] = None) -> str:
        """Execute Security Expert Agent"""
        result = self.execute_agent('security-review', prompt, file_path)
        return result['output'] if result['success'] else f"Error: {result['error']}"
    
    def generate_tests(self, prompt: str, file_path: Optional[str] = None) -> str:
        """Execute Testing Expert Agent"""
        result = self.execute_agent('generate-tests', prompt, file_path)
        return result['output'] if result['success'] else f"Error: {result['error']}"
    
    def electronics_design(self, prompt: str, file_path: Optional[str] = None) -> str:
        """Execute Electronics Expert Agent"""
        result = self.execute_agent('electronics-design', prompt, file_path)
        return result['output'] if result['success'] else f"Error: {result['error']}"
    
    def code_review(self, prompt: str, file_path: Optional[str] = None) -> str:
        """Execute Code Review Agent"""
        result = self.execute_agent('code-review', prompt, file_path)
        return result['output'] if result['success'] else f"Error: {result['error']}"
    
    def debug_issue(self, prompt: str, file_path: Optional[str] = None) -> str:
        """Execute Debug Expert Agent"""
        result = self.execute_agent('debug-issue', prompt, file_path)
        return result['output'] if result['success'] else f"Error: {result['error']}"
    
    def generate_docs(self, prompt: str, file_path: Optional[str] = None) -> str:
        """Execute Documentation Expert Agent"""
        result = self.execute_agent('generate-docs', prompt, file_path)
        return result['output'] if result['success'] else f"Error: {result['error']}"
    
    def agent_pipeline(self, agents: List[str], prompt: str, file_path: Optional[str] = None) -> str:
        """Execute multiple agents in sequence"""
        agents_str = ','.join(agents)
        if file_path and os.path.exists(file_path):
            ps_command = f'Import-Module ClaudeAgents -Force; agent-pipeline {agents_str} -FilePath "{file_path}" -Prompt "{prompt}"'
        else:
            ps_command = f'Import-Module ClaudeAgents -Force; agent-pipeline {agents_str} "{prompt}"'
        
        cmd = [self.powershell_path, "-Command", ps_command]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)  # 5 minutes for pipeline
            return result.stdout if result.returncode == 0 else f"Error: {result.stderr}"
        except subprocess.TimeoutExpired:
            return "Error: Pipeline execution timed out (5 minutes)"
        except Exception as e:
            return f"Error: Pipeline failed: {str(e)}"


class PythonAIBridge:
    """Bridge to use Python AI providers from PowerShell"""
    
    def __init__(self, ai_powerhouse_path: Optional[str] = None):
        self.logger = logging.getLogger(__name__)
        
        # Try to find AI Powerhouse
        if ai_powerhouse_path:
            self.ai_path = Path(ai_powerhouse_path)
        else:
            # Look for AI Powerhouse in common locations
            current_dir = Path(__file__).parent
            possible_paths = [
                current_dir / "PythonAI",
                current_dir.parent / "Core" / "PythonAI",
                current_dir.parent.parent / "Core" / "PythonAI"
            ]
            
            for path in possible_paths:
                if (path / "ai_powerhouse").exists():
                    self.ai_path = path
                    break
            else:
                raise RuntimeError("AI Powerhouse not found")
        
        # Add to Python path
        if str(self.ai_path) not in sys.path:
            sys.path.insert(0, str(self.ai_path))
    
    def get_available_providers(self) -> List[str]:
        """Get list of available AI providers"""
        try:
            from ai_powerhouse.core import AIPowerhouse
            ai = AIPowerhouse()
            return ai.get_available_providers()
        except Exception as e:
            self.logger.error(f"Failed to get providers: {e}")
            return []
    
    def ask_claude(self, prompt: str) -> str:
        """Ask Claude AI"""
        try:
            from ai_powerhouse.core import AIPowerhouse
            ai = AIPowerhouse()
            return ai.ask_claude(prompt)
        except Exception as e:
            return f"Error calling Claude: {str(e)}"
    
    def ask_gemini(self, prompt: str) -> str:
        """Ask Google Gemini"""
        try:
            from ai_powerhouse.core import AIPowerhouse
            ai = AIPowerhouse()
            return ai.ask_gemini(prompt)
        except Exception as e:
            return f"Error calling Gemini: {str(e)}"
    
    def ask_openai(self, prompt: str) -> str:
        """Ask OpenAI"""
        try:
            from ai_powerhouse.core import AIPowerhouse
            ai = AIPowerhouse()
            return ai.ask_openai(prompt)
        except Exception as e:
            return f"Error calling OpenAI: {str(e)}"
    
    def ask_all(self, prompt: str) -> Dict[str, str]:
        """Ask all available providers"""
        try:
            from ai_powerhouse.core import AIPowerhouse
            ai = AIPowerhouse()
            return ai.ask_all(prompt)
        except Exception as e:
            return {"error": f"Error calling providers: {str(e)}"}


class UnifiedAI:
    """Unified interface combining Python AI and PowerShell Agents"""
    
    def __init__(self):
        self.ps_bridge = PowerShellAgentBridge()
        self.py_bridge = PythonAIBridge()
        self.logger = logging.getLogger(__name__)
        
    def get_capabilities(self) -> Dict[str, Any]:
        """Get all available capabilities"""
        return {
            'powershell_agents': self.ps_bridge.list_agents(),
            'python_providers': self.py_bridge.get_available_providers(),
            'agents_available': self.ps_bridge.agents_available,
            'integration_ready': True
        }
    
    def analyze_with_multiple_agents(self, prompt: str, file_path: Optional[str] = None) -> Dict[str, str]:
        """
        Analyze with multiple agents and AI providers for comprehensive analysis
        """
        results = {}
        
        # Get Claude AI analysis (Python)
        try:
            results['claude_ai'] = self.py_bridge.ask_claude(prompt)
        except Exception as e:
            results['claude_ai'] = f"Error: {str(e)}"
        
        # Get specialized agent analysis (PowerShell)
        if self.ps_bridge.agents_available:
            try:
                results['security_agent'] = self.ps_bridge.security_review(prompt, file_path)
                results['code_review_agent'] = self.ps_bridge.code_review(prompt, file_path)
            except Exception as e:
                results['agent_error'] = f"Error: {str(e)}"
        
        return results
    
    def comprehensive_code_analysis(self, file_path: str) -> Dict[str, str]:
        """
        Perform comprehensive code analysis using both systems
        """
        if not os.path.exists(file_path):
            return {"error": "File not found"}
        
        # Read file content for AI analysis
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            return {"error": f"Failed to read file: {str(e)}"}
        
        prompt = f"Analyze this code for issues, improvements, and best practices:\n\n{content}"
        
        results = {}
        
        # Python AI providers
        try:
            results['claude_analysis'] = self.py_bridge.ask_claude(prompt)
            results['gemini_analysis'] = self.py_bridge.ask_gemini(prompt)
        except Exception as e:
            results['ai_error'] = f"AI analysis failed: {str(e)}"
        
        # PowerShell agents with file context
        if self.ps_bridge.agents_available:
            try:
                results['security_review'] = self.ps_bridge.security_review("Comprehensive security analysis", file_path)
                results['code_review'] = self.ps_bridge.code_review("Detailed code review", file_path)
                results['performance_analysis'] = self.ps_bridge.execute_agent('analyze-performance', "Performance optimization suggestions", file_path)['output']
            except Exception as e:
                results['agents_error'] = f"Agent analysis failed: {str(e)}"
        
        return results


# CLI interface for cross-system integration
def main():
    """CLI interface for the unified AI framework"""
    import argparse
    
    parser = argparse.ArgumentParser(description='AI Powerhouse Framework - Unified AI Interface')
    parser.add_argument('command', choices=['capabilities', 'analyze', 'agent', 'ai', 'comprehensive'])
    parser.add_argument('--prompt', '-p', help='Prompt for AI/Agent')
    parser.add_argument('--file', '-f', help='File path for analysis')
    parser.add_argument('--agent', '-a', help='Specific agent to use')
    parser.add_argument('--provider', help='AI provider (claude, gemini, openai, all)')
    
    args = parser.parse_args()
    
    unified = UnifiedAI()
    
    if args.command == 'capabilities':
        caps = unified.get_capabilities()
        print(json.dumps(caps, indent=2))
    
    elif args.command == 'analyze' and args.prompt:
        results = unified.analyze_with_multiple_agents(args.prompt, args.file)
        for source, result in results.items():
            print(f"\n=== {source.upper()} ===")
            print(result)
    
    elif args.command == 'agent' and args.prompt and args.agent:
        result = unified.ps_bridge.execute_agent(args.agent, args.prompt, args.file)
        print(result['output'] if result['success'] else f"Error: {result['error']}")
    
    elif args.command == 'ai' and args.prompt:
        provider = args.provider or 'claude'
        if provider == 'claude':
            print(unified.py_bridge.ask_claude(args.prompt))
        elif provider == 'gemini':
            print(unified.py_bridge.ask_gemini(args.prompt))
        elif provider == 'openai':
            print(unified.py_bridge.ask_openai(args.prompt))
        elif provider == 'all':
            results = unified.py_bridge.ask_all(args.prompt)
            for prov, result in results.items():
                print(f"\n=== {prov.upper()} ===")
                print(result)
    
    elif args.command == 'comprehensive' and args.file:
        results = unified.comprehensive_code_analysis(args.file)
        for analysis, result in results.items():
            print(f"\n=== {analysis.upper()} ===")
            print(result)
    
    else:
        parser.print_help()


if __name__ == "__main__":
    main()