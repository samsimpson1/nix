{ pkgs, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = {
    allowUnfree = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "samsimpson";

  users.users.samsimpson = {
    name = "samsimpson";
    home = "/Users/samsimpson";
  };

  environment.systemPackages = with pkgs; [
    cyberduck
  ];

  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation.autoUpdate = false;

    brews = [
      { name = "rbenv"; }
      { name = "ruby-build"; }
    ];

    casks = [
      {
        name = "1password";
        greedy = true;
      }
      {
        name = "logseq";
        greedy = true;
      }
      {
        name = "firefox";
        greedy = true;
      }
      {
        name = "megasync";
        greedy = true;
      }
      {
        name = "makemkv";
        greedy = true;
      }
      {
        name = "wezterm";
        greedy = true;
      }
      {
        name = "sonic-pi";
        greedy = true;
      }
      {
        name = "stremio";
        greedy = true;
      }
      {
        name = "vivaldi";
        greedy = true;
      }
      {
        name = "podman-desktop";
        greedy = true;
      }
      {
        name = "ghostty";
        greedy = true;
      }
    ];
  };
}
