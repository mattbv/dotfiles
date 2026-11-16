# Global keymaps translated from nvim/init.lua
# LSP, telescope, git, and plugin-specific keymaps will be added in later phases
{
  config.vim.keymaps = [
    # Disable space in normal and visual mode (leader key)
    {
      key = "<Space>";
      mode = ["n" "v"];
      action = "<Nop>";
      silent = true;
    }

    # Remap for dealing with word wrap
    {
      key = "k";
      mode = "n";
      action = "v:count == 0 ? 'gk' : 'k'";
      expr = true;
      silent = true;
    }
    {
      key = "j";
      mode = "n";
      action = "v:count == 0 ? 'gj' : 'j'";
      expr = true;
      silent = true;
    }

    # Diagnostic keymaps
    {
      key = "[d";
      mode = "n";
      action = "function() vim.diagnostic.jump({ count = -1 }) end";
      lua = true;
      desc = "Go to previous diagnostic message";
    }
    {
      key = "]d";
      mode = "n";
      action = "function() vim.diagnostic.jump({ count = 1 }) end";
      lua = true;
      desc = "Go to next diagnostic message";
    }
    {
      key = "<leader>e";
      mode = "n";
      action = "vim.diagnostic.open_float";
      lua = true;
      desc = "Open floating diagnostic message";
    }
    {
      key = "<leader>q";
      mode = "n";
      action = "vim.diagnostic.setloclist";
      lua = true;
      desc = "Open diagnostics list";
    }
  ];
}
