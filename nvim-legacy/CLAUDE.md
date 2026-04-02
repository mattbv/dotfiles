# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Neovim configuration based on the Kickstart.nvim template, customized with modern Lua-based plugins. The configuration uses lazy.nvim as the plugin manager and is structured in a modular way with plugin configurations separated into individual files.

## Project Structure

- `init.lua` - Main entry point with basic Neovim settings and keymaps
- `lua/config/lazy.lua` - Lazy.nvim plugin manager setup and core plugin definitions
- `lua/config/plugins/` - Individual plugin configurations:
  - `lsp.lua` - Language Server Protocol configuration with Mason
  - `telescope.lua` - Fuzzy finder and search functionality
  - `autoformat.lua` - Code formatting with conform.nvim
  - `ai.lua` - GitHub Copilot configuration with privacy controls
  - `init.lua` - Additional plugin imports (currently empty)
- `lua/config/telescope/multigrep.lua` - Custom telescope multigrep functionality
- `lazy-lock.json` - Plugin version lock file

## Key Configuration Details

### Language Servers
LSP servers are managed through Mason and include:
- `lua_ls` for Lua
- `clangd` for C/C++
- `gopls` for Go
- `pyright` for Python
- `rust_analyzer` for Rust

### Formatting
- Stylua for Lua formatting
- Python uses ruff_format/ruff_organize_imports if available, falls back to isort/black
- Format on save is enabled for most file types (disabled for C/C++)

### Key Mappings
- Leader key: `<Space>`
- Format buffer: `<leader>f`
- Telescope file search: `<leader>sf`
- Telescope git files: `<leader>gf`
- Telescope live grep: `<leader>sg` (multigrep)
- Edit Neovim config: `<leader>ne`

### AI Features
GitHub Copilot is configured with privacy controls - automatically disabled for projects under `~/code/_private/`.

## Development Commands

Since this is a Neovim configuration, development is primarily done by:
1. Editing configuration files
2. Restarting Neovim or using `:source %` to reload changes
3. Using `:Lazy` to manage plugins
4. Using `:Mason` to manage LSP servers and tools

## Plugin Management

- Use `:Lazy` to open the plugin manager interface
- Use `:Lazy update` to update all plugins
- Use `:Lazy clean` to remove unused plugins
- Plugin versions are locked in `lazy-lock.json`

## LSP and Tools Management

- Use `:Mason` to manage LSP servers, formatters, and linters
- Use `:LspInfo` to check LSP server status
- Use `:ConformInfo` to check formatter status