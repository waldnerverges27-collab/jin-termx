# 9Router - FREE AI Router & Token Saver

**Never stop coding. Save 20-40% tokens with RTK + auto-fallback to FREE & cheap AI models.**

**Connect All AI Code Tools to 40+ AI Providers & 100+ Models.**

**Package:** 9router  
**Author:** decolua  
**Repository:** https://github.com/decolua/9router  
**Type:** AI Model Router / Proxy  
**License:** MIT

## Description

9Router is an AI model router that connects your AI coding tools to 40+ AI providers and 100+ models. It features:

- **RTK Token Saver** - Auto-compress tool output, save 20-40% tokens
- **Auto fallback** - Subscription → Cheap → Free, zero downtime
- **Multi-account** - Round-robin between accounts per provider
- **Universal** - Works with any OpenAI/Claude-compatible CLI

## Usage

```bash
# Start 9Router with default settings
9router

# Custom port
9router --port 8080

# Don't open browser
9router --no-browser
```

Dashboard opens at `http://localhost:20128`

## Connect your CLI tools

Configure any OpenAI/Claude-compatible CLI tool with:

```
Endpoint: http://localhost:20128/v1
API Key:  [copy from dashboard]
Model:    kr/claude-sonnet-4.5
```

## Requirements

- Node.js (installed automatically)
- ~50 MB disk space
