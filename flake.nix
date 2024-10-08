{
  description = "❄️";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nix-darwin, home-manager }:
  {
    # Personal MBP
    darwinConfigurations.Sams-MacBook-Pro = nix-darwin.lib.darwinSystem {
      system.configurationRevision = self.rev or self.dirtyRev or null;

      modules = [
        ./personal/system-configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.samsimpson.imports = [ ./personal/home-manager.nix ];
          };
        }
      ];
    };

    # Work MBP
    darwinConfigurations.GDS11405 = nix-darwin.lib.darwinSystem {
      system.configurationRevision = self.rev or self.dirtyRev or null;

      modules = [
        ./work/system-configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.samsimpson.imports = [ ./work/home-manager.nix ];
          };
        }
      ];
    };
  };
}
