{ stdenv, pkgs, ... }:
{
  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      crystal
      emacs
    ];

    file.".emacs.d/init.el".source = ../shared/emacs.el;

    stateVersion = "24.05";
  };
}
