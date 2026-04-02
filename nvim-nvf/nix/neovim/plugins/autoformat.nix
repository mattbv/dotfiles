# conform.nvim: format on save with per-filetype control
# Translated from nvim/lua/config/plugins/autoformat.lua
#
# NVF's built-in vim.lsp.formatOnSave is a simple boolean and cannot handle:
#   - Disabling format-on-save for specific filetypes (c, cpp)
#   - Dynamic Python formatter selection (ruff -> isort/black fallback)
#   - The <leader>f manual format keymap
# So we use conform.nvim directly via extraPlugins.
{pkgs, ...}: {
  config.vim = {
    extraPlugins = {
      conform-nvim = {
        package = pkgs.vimPlugins.conform-nvim;
        setup = ''
          require('conform').setup {
            notify_on_error = true,
            notify_no_formatters = true,
            format_on_save = function(bufnr)
              local disable_filetypes = { c = true, cpp = true }
              return {
                timeout_ms = 3000,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
              }
            end,
            formatters_by_ft = {
              lua = { 'stylua' },
              python = function(bufnr)
                if require('conform').get_formatter_info('ruff_format', bufnr).available then
                  return { 'ruff_format', 'ruff_organize_imports' }
                else
                  return { 'isort', 'black' }
                end
              end,
            },
          }
        '';
      };
    };

    keymaps = [
      {
        key = "<leader>f";
        mode = ["n" "v" "x"];
        action = "function() require('conform').format { async = true, lsp_fallback = true } end";
        lua = true;
        desc = "[F]ormat buffer";
      }
    ];
  };
}
