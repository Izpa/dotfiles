#!/usr/bin/env bash
set -e

#=============================================================================
# Install script - deploys home-manager configuration and tools
# Works for any username on any Unix system
#=============================================================================

echo "==> Installing environment..."

# Ensure nix profile is in PATH
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

#-----------------------------------------------------------------------------
# Determine username and home directory
#-----------------------------------------------------------------------------
USERNAME=$(whoami)
HOME_DIR=$HOME
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "==> Configuring for user: $USERNAME"
echo "==> Home directory: $HOME_DIR"
echo "==> Dotfiles directory: $DOTFILES_DIR"

#-----------------------------------------------------------------------------
# Create temporary flake with correct username
#-----------------------------------------------------------------------------
echo "==> Running home-manager..."

cat > "$DOTFILES_DIR/flake.nix" << EOF
{
  description = "Local development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = builtins.currentSystem;
      pkgs = nixpkgs.legacyPackages.\${system};
    in {
      homeConfigurations."$USERNAME" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          username = "$USERNAME";
          homeDirectory = "$HOME_DIR";
        };
      };
    };
}
EOF

cd "$DOTFILES_DIR"

# Add flake.nix to git index temporarily (nix requires tracked files)
git add -f flake.nix

nix run home-manager -- switch --flake ".#$USERNAME" --no-write-lock-file

# Clean up temporary flake
git reset HEAD flake.nix 2>/dev/null || true
rm -f "$DOTFILES_DIR/flake.nix" "$DOTFILES_DIR/flake.lock"

#-----------------------------------------------------------------------------
# Install Claude Code
#-----------------------------------------------------------------------------
echo "==> Installing Claude Code..."
if command -v npm &> /dev/null; then
    mkdir -p "$HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
    export PATH="$HOME/.npm-global/bin:$PATH"
    npm install -g @anthropic-ai/claude-code
else
    echo "WARNING: npm not found. Claude Code not installed."
    echo "After 'exec zsh', run: npm install -g @anthropic-ai/claude-code"
fi

echo ""
echo "==> Done! Run 'exec zsh' to reload shell."
