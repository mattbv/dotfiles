return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  enable = true,
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    vim.cmd 'hi! link MiniCursorword Visual'
    vim.cmd 'hi! MiniCursorwordCurrent gui=nocombine guifg=NONE guibg=NONE'

    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = true }

    require('mini.pairs').setup()

    require('mini.cursorword').setup()

    require('mini.comment').setup()

    require('mini.move').setup {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-h>',
        down = '<M-j>',
        right = '<M-l>',
        up = '<M-k>',

        -- Move current line in Normal mode
        line_left = '<M-h>',
        line_right = '<M-l>',
        line_down = '<M-j>',
        line_up = '<M-k>',
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    }
  end,
}
