{ stdenv, pkgs, ... }:
{
  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      crystal
    ];

    stateVersion = "24.05";
  };
}