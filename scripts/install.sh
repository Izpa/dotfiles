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

# Detect system architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  NIX_SYSTEM="x86_64-linux" ;;
  aarch64) NIX_SYSTEM="aarch64-linux" ;;
  arm64)   NIX_SYSTEM="aarch64-darwin" ;;
  *)       NIX_SYSTEM="x86_64-linux" ;;
esac

# macOS detection
if [[ "$(uname -s)" == "Darwin" ]]; then
  case "$ARCH" in
    x86_64)  NIX_SYSTEM="x86_64-darwin" ;;
    arm64)   NIX_SYSTEM="aarch64-darwin" ;;
  esac
fi

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
      system = "$NIX_SYSTEM";
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

# Add flake.nix (+ flake.lock if present) to the git index so nix sees them.
# flake.nix is generated per-run and gitignored; flake.lock is committed so
# nixpkgs/home-manager are pinned (run `nix flake update` to bump).
git add -f flake.nix
[ -f flake.lock ] && git add -f flake.lock

nix run home-manager -- switch --flake ".#$USERNAME"

# Remove only the generated flake.nix from the index; keep flake.lock so it can
# be committed for reproducible pins.
git reset HEAD flake.nix 2>/dev/null || true
rm -f "$DOTFILES_DIR/flake.nix"
if [ -n "$(git status --porcelain flake.lock 2>/dev/null)" ]; then
    echo "==> flake.lock changed -- commit it to pin dependency versions:"
    echo "    git add flake.lock && git commit -m 'update flake.lock'"
fi

#-----------------------------------------------------------------------------
# Install Claude Code via official native installer
# Docs: https://docs.claude.com/en/docs/claude-code/setup
#-----------------------------------------------------------------------------
if ! [ -x "$HOME/.local/bin/claude" ]; then
    echo "==> Installing Claude Code (native installer)..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "==> Claude Code already installed at ~/.local/bin/claude (self-updating)."
fi

echo ""
echo "==> Done! Run 'exec zsh' to reload shell."
