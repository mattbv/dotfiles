return {
  {
    'catppuccin/nvim',
    name = 'catppuccin-mocha',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        integrations = {
          telescope = true,
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
        },
        vim.cmd.colorscheme 'catppuccin-mocha',
      }
    end,
  },
}
