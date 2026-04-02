# LSP configuration: core settings, fidget, keymaps, and LspAttach autocmd
# Translated from nvim/lua/config/plugins/lsp.lua
#
# NVF provides vim.lsp.mappings but the defaults use <leader>l* prefix.
# We override them to match the kickstart-style bindings (gd, gr, etc.)
# since those bindings need telescope pickers, we set them to null here
# and define them as raw keymaps + Lua in the LspAttach autocmd.
{lib, ...}: {
  config.vim = {
    lsp = {
      enable = true;
      formatOnSave = false; # Handled by conform.nvim in autoformat.nix

      # Disable NVF's default LSP keymaps -- we define our own in the LspAttach autocmd
      # that use telescope pickers and match the kickstart bindings
      mappings = {
        goToDefinition = null;
        goToDeclaration = null;
        goToType = null;
        listReferences = null;
        listImplementations = null;
        listDocumentSymbols = null;
        listWorkspaceSymbols = null;
        renameSymbol = null;
        codeAction = null;
        hover = null;
        format = null;
        toggleFormatOnSave = null;
        signatureHelp = null;
        documentHighlight = null;
        openDiagnosticFloat = null;
        nextDiagnostic = null;
        previousDiagnostic = null;
        addWorkspaceFolder = null;
        removeWorkspaceFolder = null;
        listWorkspaceFolders = null;
      };
    };

    # Fidget: LSP progress indicator (was a dependency of lspconfig in the original)
    visuals.fidget-nvim = {
      enable = true;
      setupOpts = {};
    };

    # LSP keymaps and document highlight via LspAttach autocmd
    # This preserves the kickstart-style telescope-backed LSP keymaps
    # and capability-gated document highlight / inlay hints toggle
    luaConfigRC.lsp-attach = ''
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Telescope-backed LSP navigation
          local tb = require('telescope.builtin')
          map('gd', tb.lsp_definitions, '[G]oto [D]efinition')
          map('gr', tb.lsp_references, '[G]oto [R]eferences')
          map('gI', tb.lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', tb.lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', tb.lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', tb.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Standard LSP actions
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Document highlight on CursorHold (capability-gated)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Inlay hints toggle (capability-gated)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
    '';
  };
}
