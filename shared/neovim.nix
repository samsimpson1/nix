{ pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      tree-sitter = prev.tree-sitter.override {
        extraGrammars = {
          tree-sitter-terraform = {
            url = "https://github.com/MichaHoffmann/tree-sitter-hcl";
            location = "dialects/terraform";
            rev = "de10d494dbd6b71cdf07a678fecbf404dbfe4398";
            sha256 = "sha256-oRNNxE5AnI0TyJl92pk0E9xGj5xom/+0kpPMUE/O/TY=";
            fetchSubmodules = false;
          };
        };
      };
    })
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      {
        plugin = (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars));
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true
            },
            indent = {
              enable = true
            }
          }
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require('bufferline').setup {
            options = {
              diagnostics = "coc"
            }
          }
        '';
      }
      {
        plugin = neo-tree-nvim;
        type = "lua";
        config = ''
          vim.api.nvim_create_augroup("neotree", {})
          vim.api.nvim_create_autocmd("UiEnter", {
            desc = "Open Neotree",
            group = "neotree",
            callback = function()
              if vim.fn.argc() == 0 then
                vim.cmd "Neotree toggle"
              end
            end
          })
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = "require('gitsigns').setup()";
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require("telescope.builtin")
          vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
          vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
          vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
          vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })
        '';
      }
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin-mocha";
      }
      {
        plugin = neorg;
        type = "lua";
        config = "require('neorg').setup()";
      }
    ];

    extraPackages = [
      # required by telescope
      pkgs.ripgrep
    ];
    extraLuaConfig = ''
      vim.api.nvim_create_user_command("T", "below terminal", {})

      ${builtins.readFile ./neovim-coc-config.lua}
    '';
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set expandtab

      set number

      tnoremap <Esc> <C-\><C-n>
    '';
    coc = {
      enable = true;
      settings = {
        languageserver = {
          terraform = {
            command = "${pkgs.terraform-ls}/bin/terraform-ls";
            args = [ "serve" ];
            filetypes = [
              "tf"
              "terraform"
            ];
            rootPatterns = [
              ".terraform.lock.hcl"
            ];
          };
          nix = {
            command = "${pkgs.nixd}/bin/nixd";
            filetypes = [ "nix" ];
          };
          yaml = {
            command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            filetypes = [
              "yaml"
              "yml"
            ];
          };
          go = {
            command = "${pkgs.gopls}/bin/gopls";
            filetypes = [ "go" ];
            rootPatterns = [
              "go.work"
              "go.mod"
            ];
            initializationOptions = {
              usePlaceholders = true;
            };
          };
          python = {
            command = "${pkgs.pylyzer}/bin/pylyzer --server";
            filetypes = [
              "py"
            ];
          };
          ruby = {
            command = "${pkgs.ruby-lsp}/bin/ruby-lsp";
            filetypes = [
              "rb"
            ];
            rootPatterns = [
              "Gemfile"
              "Gemfile.lock"
            ];
          };
          bash = {
            command = "${pkgs.bash-language-server}/bin/bash-language-server";
            args = [ "start" ];
            filetypes = [ "sh" ];
            ignoredRootPaths = [ "~" ];
          };
        };
      };
    };
  };
}
