"""
Tests for configuration management
"""

import os
import pytest
from ai_powerhouse.config import Config


def test_config_load_from_env(monkeypatch):
    """Test loading configuration from environment variables"""
    # Set test environment variables
    monkeypatch.setenv("ANTHROPIC_API_KEY", "test-claude-key")
    monkeypatch.setenv("GOOGLE_API_KEY", "test-gemini-key")
    monkeypatch.setenv("OPENAI_API_KEY", "test-openai-key")
    monkeypatch.setenv("MAX_TOKENS", "2000")
    monkeypatch.setenv("TEMPERATURE", "0.5")
    
    config = Config.load_from_env()
    
    assert config.anthropic_api_key == "test-claude-key"
    assert config.google_api_key == "test-gemini-key"
    assert config.openai_api_key == "test-openai-key"
    assert config.max_tokens == 2000
    assert config.temperature == 0.5


def test_config_validate_keys():
    """Test API key validation"""
    config = Config(
        anthropic_api_key="test-key",
        google_api_key=None,
        openai_api_key="test-key"
    )
    
    available = config.validate_keys()
    
    assert available["claude"] is True
    assert available["gemini"] is False
    assert available["openai"] is True


def test_config_defaults():
    """Test default configuration values"""
    config = Config()
    
    assert config.claude_model == "claude-3-sonnet-20240229"
    assert config.gemini_model == "gemini-pro"
    assert config.openai_model == "gpt-4"
    assert config.max_tokens == 4000
    assert config.temperature == 0.7
