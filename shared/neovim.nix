{ stdenv, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
    extraLuaConfig = ''
    require'nvim-treesitter.configs'.setup {
      higlight = {
        enable = true
      }
    }
    '';
    extraConfig = ''
    set tabstop=2
    set shiftwidth=2
    set expandtab
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
