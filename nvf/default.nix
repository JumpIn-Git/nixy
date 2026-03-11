{
  vim = {
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
      {
        key = "<leader>/";
        mode = "n";
        desc = "Grep";
        action = "<cmd>FzfLua live_grep<cr>";
      }
      {
        key = "<leader><space>";
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
        sources = {
          default = ["lazydev" "lsp" "path" "snippets" "buffer"];
          providers = {
            lazydev = {
              name = "LazyDev";
              module = "lazydev.integrations.blink";
              score_offset = 100;
            };
          };
        };
        keymap.preset = "super-tab";
        signature.enabled = true;
      };
    };
    fzf-lua.enable = true;
    lsp = {
      enable = true;
      inlayHints.enable = true;
      servers.lua-language-server.settings.Lua.workspace.library = ["\${3rd}/love2d/library"];
      formatOnSave = true;
      otter-nvim.enable = true;
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
      files = {
        setupOpts.windows.preview = true;
        enable = true;
      };
      icons.enable = true;
      tabline.enable = true;
      pairs.enable = true;
    };
  };
}
