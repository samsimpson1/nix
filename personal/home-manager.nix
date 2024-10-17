{ stdenv, pkgs, ... }:
{
  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      crystal
      crystalline
      emacs
    ];

    file.".emacs.d/init.el".source = import ../shared/emacs.nix { inherit pkgs; };

    stateVersion = "24.05";
  };

  programs = {
    zsh = {
      enable = true;
      initExtra = ''
      $(rbenv init -)
      '';
    }
  }
}
