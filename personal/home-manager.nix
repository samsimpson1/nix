{ stdenv, pkgs, ... }:
{
  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      crystal
      emacs
    ];

    file.".emacs.d/init.el".source = import ../shared/emacs.nix { inherit pkgs; };

    stateVersion = "24.05";
  };
}
