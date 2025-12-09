{
  description = "Development environment with Emacs, Go, Python, Clojure and tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      homeConfigurations = {
        # Generic configuration - works on any system
        # Usage: home-manager switch --flake .#dev
        "dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            username = "dev";
            homeDirectory = "/home/dev";
          };
        };
      };

      # Allow running with: nix run .#homeConfigurations.dev.activationPackage
      # Or more conveniently via bootstrap.sh

      # Development shell for working on this config
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = [ pkgs.home-manager ];
          };
        }
      );
    };
}
