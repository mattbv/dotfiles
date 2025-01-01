return {
  {

    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require('refactoring').setup {}
    end,
    keys = {
      {
        '<leader>cR',
        ":lua require('refactoring').select_refactor()<CR>",
        mode = 'v',
        desc = 'Refactor',
      },
    },
  },

  {
    'cshuaimin/ssr.nvim',
    keys = {
      {
        '<leader>sR',
        function()
          require('ssr').open()
        end,
        mode = { 'n', 'x' },
        desc = 'Structural Replace',
      },
    },
  },

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>so', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      -- Your setup opts here
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
  },
}
