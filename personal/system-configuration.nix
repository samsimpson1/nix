{ pkgs, ... }: {
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = { allowUnfree = true; };

  security.pam.enableSudoTouchIdAuth = true;

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
    onActivation.autoUpdate = true;

    brews = [
      { name = "rbenv"; }
      { name = "ruby-build"; }
    ];

    casks = [
      { name = "1password"; greedy = true; }
      { name = "obsidian"; greedy = true; }
      { name = "firefox"; greedy = true; }
      { name = "makemkv"; greedy = true; }
      { name = "wezterm"; greedy = true; }
      { name = "sonic-pi"; greedy = true; }
      { name = "stremio"; greedy = true; }
      { name = "vivaldi"; greedy = true; }
      { name = "podman-desktop"; greedy = true; }
    ];
  };
}
