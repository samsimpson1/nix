{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    slack
    vscode
    squeezelite
  ];

  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.primaryUser = "samsimpson";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = {
    allowUnfree = true;
  };

  users.users.samsimpson = {
    name = "samsimpson";
    home = "/Users/samsimpson";
  };

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    enable = true;
    onActivation.autoUpdate = false;
    casks = [
      {
        name = "firefox";
        greedy = true;
      }
      {
        name = "megasync";
        greedy = true;
      }
      {
        name = "1password@beta";
        greedy = true;
      }
      {
        name = "podman-desktop";
        greedy = true;
      }
      {
        name = "logseq";
        greedy = true;
      }
      {
        name = "wezterm";
        greedy = true;
      }
    ];
    taps = [ "alphagov/gds" ];
    brews = [
      "gds-cli"
      "prometheus"
    ];
  };
}
