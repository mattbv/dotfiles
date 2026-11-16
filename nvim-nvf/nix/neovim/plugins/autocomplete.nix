# Autocompletion: nvim-cmp + LuaSnip + sources
# Translated from nvim/lua/config/plugins/autocomplete.lua
#
# The smart Tab chain (copilot suggestion -> cmp next -> luasnip expand ->
# cmp complete -> fallback) requires custom Lua in setupOpts.mapping.
# NVF's declarative mappings can't express this, so we null them out and
# define everything in setupOpts.
{lib, ...}: {
  config.vim = {
    # LuaSnip snippet engine with VSCode-style snippets
    snippets.luasnip = {
      enable = true;
      providers = ["friendly-snippets"]; # VSCode-style snippet library
      # Default loaders call require('luasnip.loaders.from_vscode').lazy_load()
      setupOpts = {};
    };

    # nvim-cmp completion
    autocomplete.nvim-cmp = {
      enable = true;

      # Null out NVF's default cmp keymaps -- we define our own in setupOpts
      mappings = {
        close = null;
        complete = null;
        confirm = null;
        next = null;
        previous = null;
        scrollDocsDown = null;
        scrollDocsUp = null;
      };

      # Completion sources with display labels
      # mkForce needed because NVF modules auto-register some sources (luasnip, copilot)
      sources = lib.mkForce {
        copilot = "[Copilot]";
        nvim_lsp = "[LSP]";
        luasnip = "[Snippet]";
        path = "[Path]";
        buffer = "[Buffer]";
      };

      setupOpts = {
        completion.completeopt = "menu,menuone,noinsert";

        # Custom mappings with smart Tab chain (defined as raw Lua)
        mapping = lib.generators.mkLuaInline ''
          (function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            local has_words_before = function()
              local unpack = unpack or table.unpack
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
            end

            return cmp.mapping.preset.insert {
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete {},
              ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              },
              ['<Tab>'] = cmp.mapping(function(fallback)
                if require('copilot.suggestion').is_visible() then
                  require('copilot.suggestion').accept()
                elseif cmp.visible() then
                  cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { 'i', 's' }),
            }
          end)()
        '';

        # Source ordering is handled by the declarative 'sources' attrset above.
        # Copilot source may also be added by NVF's assistant.copilot.cmp.enable.
        # If you see duplicate copilot entries, remove copilot from the sources map.
      };
    };
  };
}
