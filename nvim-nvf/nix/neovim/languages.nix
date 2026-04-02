# Language support: LSP servers, formatters, and treesitter grammars
# Translated from nvim/lua/config/plugins/lsp.lua (server list)
# and nvim/lua/config/plugins/autoformat.lua (formatters_by_ft)
#
# NOTE: NVF language modules handle LSP, formatting, and treesitter together.
# Mason is fully replaced -- all tools are provisioned via Nix.
{
  config.vim = {
    lsp.enable = true;

    languages = {
    # Global toggles inherited by all language modules
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = false;

    # -- Lua --
    # LSP: lua-language-server, Format: stylua
    lua = {
      enable = true;
      lsp.enable = true;
      lsp.lazydev.enable = true; # Neovim API completion/annotations
      format.enable = true;
    };

    # -- C/C++ --
    # LSP: clangd (format handled by LSP; format-on-save disabled in autoformat.nix)
    clang = {
      enable = true;
      lsp.enable = true;
    };

    # -- Go --
    # LSP: gopls
    go = {
      enable = true;
      lsp.enable = true;
    };

    # -- Python --
    # LSP: pyright (matching original config)
    # Format: ruff (NVF declarative; the dynamic ruff/black fallback from
    # autoformat.lua is handled in autoformat.nix via conform.nvim)
    python = {
      enable = true;
      lsp.enable = true;
      lsp.servers = ["pyright"];
      format.enable = true;
      format.type = ["ruff"];
    };

    # -- Rust --
    # LSP: rust_analyzer (format via LSP by default)
    rust = {
      enable = true;
      lsp.enable = true;
    };

    # -- TypeScript / JavaScript --
    # LSP: ts_ls, Format: prettierd (matching original prettierd/prettier tools)
    ts = {
      enable = true;
      lsp.enable = true;
      format.enable = true;
      format.type = ["prettierd"];
    };

    # -- Bash --
    bash = {
      enable = true;
    };

    # -- Markdown --
    markdown = {
      enable = true;
    };

    # -- YAML --
    yaml = {
      enable = true;
    };

    # -- Nix --
    # Added for editing this config and NixOS configuration
    nix = {
      enable = true;
      format.enable = true;
    };
  };
  };
}
