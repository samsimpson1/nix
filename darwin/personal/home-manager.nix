{ pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home = {
    username = "samsimpson";
    homeDirectory = "/Users/samsimpson";

    packages = with pkgs; [
      ansible
      ansible-lint
      crystal
      crystalline
      gh
    ];

    stateVersion = "24.05";
  };

  programs = {
    zsh = {
      enable = true;
      initContent = ''
        eval "$(rbenv init - --no-rehash zsh)"
      '';
    };
  };
}
