#!/usr/bin/env bash
set -e

#=============================================================================
# Bootstrap script for fresh Ubuntu/Debian server
# Installs Nix, enables flakes, and deploys home-manager configuration
#=============================================================================

REPO_URL="https://github.com/Izpa/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "==> Starting bootstrap..."

#-----------------------------------------------------------------------------
# Install Nix (if not installed)
#-----------------------------------------------------------------------------
if ! command -v nix &> /dev/null; then
    echo "==> Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon

    echo "==> Nix installed. Please restart your shell or run:"
    echo "    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    echo ""
    echo "Then run this script again."
    exit 0
fi

#-----------------------------------------------------------------------------
# Enable flakes
#-----------------------------------------------------------------------------
echo "==> Enabling Nix flakes..."
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

#-----------------------------------------------------------------------------
# Clone dotfiles
#-----------------------------------------------------------------------------
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "==> Cloning dotfiles..."
    git clone --recurse-submodules "$REPO_URL" "$DOTFILES_DIR"
else
    echo "==> Updating dotfiles..."
    cd "$DOTFILES_DIR"
    git pull
    git submodule update --init --recursive
fi

cd "$DOTFILES_DIR"

#-----------------------------------------------------------------------------
# Determine username and home directory
#-----------------------------------------------------------------------------
USERNAME=$(whoami)
HOME_DIR=$HOME

echo "==> Configuring for user: $USERNAME"
echo "==> Home directory: $HOME_DIR"

#-----------------------------------------------------------------------------
# Run home-manager
#-----------------------------------------------------------------------------
echo "==> Running home-manager..."

# Create a temporary flake with correct username
cat > "$DOTFILES_DIR/flake-local.nix" << EOF
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

nix run home-manager -- switch --flake "$DOTFILES_DIR/flake-local.nix#$USERNAME"

# Clean up temporary flake
rm -f "$DOTFILES_DIR/flake-local.nix"

#-----------------------------------------------------------------------------
# Source new environment
#-----------------------------------------------------------------------------
export PATH="$HOME/.nix-profile/bin:$PATH"
source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" 2>/dev/null || true

#-----------------------------------------------------------------------------
# Install Claude Code
#-----------------------------------------------------------------------------
echo "==> Installing Claude Code..."
if command -v npm &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
else
    echo "ERROR: npm not found. Please run 'exec zsh' and then 'npm install -g @anthropic-ai/claude-code'"
    exit 1
fi

#-----------------------------------------------------------------------------
# Post-install
#-----------------------------------------------------------------------------
echo ""
echo "==> Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal or run: exec zsh"
echo "  2. Run 'emacs' to install Emacs packages on first launch"
echo ""
echo "See README.md for Claude Code setup and other documentation."
echo ""
echo "To update later:"
echo "  cd $DOTFILES_DIR && git pull && home-manager switch --flake ."
