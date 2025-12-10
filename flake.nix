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

      # Helper to create home configuration for any system/user
      mkHomeConfig = { system, username, homeDirectory }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit username homeDirectory; };
        };
    in {
      homeConfigurations = {
        # Linux configurations
        "dev" = mkHomeConfig {
          system = "x86_64-linux";
          username = "dev";
          homeDirectory = "/home/dev";
        };

        "dev-arm" = mkHomeConfig {
          system = "aarch64-linux";
          username = "dev";
          homeDirectory = "/home/dev";
        };

        # macOS configurations
        "izpa" = mkHomeConfig {
          system = "aarch64-darwin";
          username = "izpa";
          homeDirectory = "/Users/izpa";
        };

        "izpa-x86" = mkHomeConfig {
          system = "x86_64-darwin";
          username = "izpa";
          homeDirectory = "/Users/izpa";
        };
      };

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
