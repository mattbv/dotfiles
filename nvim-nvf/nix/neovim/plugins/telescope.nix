# Telescope: fuzzy finder with fzf-native extension
# Translated from nvim/lua/config/plugins/telescope.lua
#
# NVF has built-in telescope support. We use its declarative mappings where
# possible and inject custom keymaps (git-root grep, buffer fuzzy find,
# open-files grep, multigrep) via luaConfigRC.
{lib, pkgs, ...}: {
  config.vim = {
    telescope = {
      enable = true;

      # fzf-native extension for faster sorting
      extensions = [
        {
          name = "fzf";
          packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
          setup = {
            fzf = {};
          };
        }
      ];

      setupOpts = {
        defaults = {
          mappings = {
            i = {
              # Disable C-u and C-d in insert mode (matching original)
              "<C-u>" = false;
              "<C-d>" = false;
            };
          };
        };
      };

      # NVF telescope mappings use <leader> prefix format
      # We null out the defaults and define our own keymaps below
      mappings = {
        findFiles = null;
        liveGrep = null;
        buffers = null;
        helpTags = null;
        open = null;
        resume = null;
        diagnostics = null;
        treesitter = null;
        findProjects = null;
        gitBranches = null;
        gitBufferCommits = null;
        gitCommits = null;
        gitFiles = null;
        gitStash = null;
        gitStatus = null;
        lspDefinitions = null;
        lspDocumentSymbols = null;
        lspImplementations = null;
        lspReferences = null;
        lspTypeDefinitions = null;
        lspWorkspaceSymbols = null;
      };
    };

    # Telescope keymaps matching kickstart-style bindings
    keymaps = [
      {
        key = "<leader>?";
        mode = "n";
        action = "require('telescope.builtin').oldfiles";
        lua = true;
        desc = "[?] Find recently opened files";
      }
      {
        key = "<leader><space>";
        mode = "n";
        action = "require('telescope.builtin').buffers";
        lua = true;
        desc = "[ ] Find existing buffers";
      }
      {
        key = "<leader>/";
        mode = "n";
        action = ''
          function()
            require('telescope.builtin').current_buffer_fuzzy_find(
              require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
              }
            )
          end
        '';
        lua = true;
        desc = "[/] Fuzzily search in current buffer";
      }
      {
        key = "<leader>s/";
        mode = "n";
        action = ''
          function()
            require('telescope.builtin').live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end
        '';
        lua = true;
        desc = "[S]earch [/] in Open Files";
      }
      {
        key = "<leader>ss";
        mode = "n";
        action = "require('telescope.builtin').builtin";
        lua = true;
        desc = "[S]earch [S]elect Telescope";
      }
      {
        key = "<leader>gf";
        mode = "n";
        action = "require('telescope.builtin').git_files";
        lua = true;
        desc = "Search [G]it [F]iles";
      }
      {
        key = "<leader>sf";
        mode = "n";
        action = "require('telescope.builtin').find_files";
        lua = true;
        desc = "[S]earch [F]iles";
      }
      {
        key = "<leader>sh";
        mode = "n";
        action = "require('telescope.builtin').help_tags";
        lua = true;
        desc = "[S]earch [H]elp";
      }
      {
        key = "<leader>sw";
        mode = "n";
        action = "require('telescope.builtin').grep_string";
        lua = true;
        desc = "[S]earch current [W]ord";
      }
      {
        key = "<leader>sd";
        mode = "n";
        action = "require('telescope.builtin').diagnostics";
        lua = true;
        desc = "[S]earch [D]iagnostics";
      }
      {
        key = "<leader>sr";
        mode = "n";
        action = "require('telescope.builtin').resume";
        lua = true;
        desc = "[S]earch [R]esume";
      }
      {
        key = "<leader>ne";
        mode = "n";
        action = ''
          function()
            require('telescope.builtin').find_files {
              cwd = vim.fn.stdpath 'config',
            }
          end
        '';
        lua = true;
        desc = "[E]dit [N]eovim";
      }
    ];

    # LiveGrepGitRoot command and multigrep setup via raw Lua
    luaConfigRC.telescope-extras = ''
      -- Telescope live_grep in git root
      local function find_git_root()
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        if current_file == ''' then
          current_dir = cwd
        else
          current_dir = vim.fn.fnamemodify(current_file, ':h')
        end
        local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
          print 'Not a git repository. Searching on current working directory'
          return cwd
        end
        return git_root
      end

      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          require('telescope.builtin').live_grep {
            search_dirs = { git_root },
          }
        end
      end

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
      vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })

      -- Multigrep picker (search pattern ; glob filter)
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local make_entry = require 'telescope.make_entry'
      local conf = require('telescope.config').values

      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()
        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == "" then return nil end
            local pieces = vim.split(prompt, ';')
            local args = { 'rg' }
            if pieces[1] then
              table.insert(args, '-e')
              table.insert(args, pieces[1])
            end
            if pieces[2] then
              table.insert(args, '-g')
              table.insert(args, pieces[2])
            end
            return vim.iter({ args, { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' } }):flatten():totable()
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        }
        pickers.new(opts, {
          debounce = 100,
          prompt_title = 'Multi Grep',
          finder = finder,
          previewer = conf.grep_previewer(opts),
          sorter = require('telescope.sorters').empty(),
        }):find()
      end

      vim.keymap.set('n', '<leader>sg', live_multigrep)
    '';
  };
}
