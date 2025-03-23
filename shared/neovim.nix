{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      bufferline-nvim
      neo-tree-nvim
      gitsigns-nvim
    ];
    extraLuaConfig = ''
    require('nvim-treesitter.configs').setup {
      higlight = {
        enable = true
      },
      indent = {
        enable = true
      }
    }

    require('bufferline').setup {
      options = {
        diagnostics = "coc"
      }
    }

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

    vim.api.nvim_create_user_command("T", "below terminal", {})

    require("gitsigns").setup()
    '';
    extraConfig = ''
    set tabstop=2
    set shiftwidth=2
    set expandtab

    set number
    '';
    coc = {
      enable = true;
      settings = {
        languageserver = {
          terraform = {
            command = "${pkgs.terraform-ls}/bin/terraform-ls";
            args = ["serve"];
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
	          filetypes = ["nix"];
	        };
        };
      };
    };
  };
}
