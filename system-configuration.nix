{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = { allowUnfree = true; };

  users.users.samsimpson = {
    name = "samsimpson";
    home = "/Users/samsimpson";
  };

  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";

    casks = [
      { name = "1password"; greedy = true; }
      { name = "obsidian"; greedy = true; }
      { name = "firefox"; greedy = true; }
      { name = "makemkv"; greedy = true; }
      { name = "wezterm"; greedy = true; }
      { name = "sonic-pi"; greedy = true; }
    ];
  };
}