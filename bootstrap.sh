#!/usr/bin/env bash
set -e

#=============================================================================
# Bootstrap script for fresh Ubuntu/Debian server
# Installs Nix, enables flakes, clones dotfiles, and runs install
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

#-----------------------------------------------------------------------------
# Run install script
#-----------------------------------------------------------------------------
cd "$DOTFILES_DIR"
./scripts/install.sh

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
echo "To update later:"
echo "  cd $DOTFILES_DIR && make update"
