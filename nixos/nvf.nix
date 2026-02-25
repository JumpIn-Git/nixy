{inputs, ...}: {
  imports = [inputs.nvf.nixosModules.default];
  programs.nvf = {
    enable = true;
    settings.vim = {
      statusline.lualine.enable = true;
      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };
      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
        };
      };
      keymaps = [
        #{ "<leader>/", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
        {
          key = "<leader>/";
          mode = "n";
          desc = "Grep";
          action = "<cmd>FzfLua live_grep<cr>";
        }
        {
          key = "<leader><space>"
          ;
          mode = "n";
          desc = "Find Files";
          action = "<cmd>FzfLua files<cr>";
        }
        {
          key = "<leader>e";
          mode = "n";
          desc = "Open mini.files";
          action = ''
            function()
                MiniFiles.open(vim.api.nvim_buf_get_name(0))
            end
          '';
          lua = true;
        }
        {
          key = "<leader>E";
          mode = "n";
          desc = "Open mini.files (cwd)";
          action = "MiniFiles.open";
          lua = true;
        }
      ];
      binds.whichKey.enable = true;
      autocomplete.blink-cmp = {
        enable = true;
        setupOpts = {
          keymap.preset = "enter";
          signature.enabled = true;
        };
      };
      fzf-lua.enable = true;
      lsp = {
        enable = true;
        inlayHints.enable = true;
        formatOnSave = true;
        # lspkind.enable = true;
      };
      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          lsp.servers = ["nixd"];
        };
        lua = {
          enable = true;
          lsp.lazydev.enable = true;
        };
        nu.enable = true;
        go.enable = true;
      };
      mini = {
        files.enable = true;
        icons.enable = true;
        tabline.enable = true;
        pairs.enable = true;
      };
    };
  };
}
