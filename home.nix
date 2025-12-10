{ config, pkgs, lib, username ? "dev", homeDirectory ? "/home/dev", ... }:

{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  #---------------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Editors
    emacs

    # Languages
    go
    gopls
    gotools
    python3
    python3Packages.pip
    python3Packages.python-lsp-server
    python3Packages.black
    clojure
    leiningen
    clojure-lsp
    nodejs_22  # for copilot and other tools

    # Build tools
    gcc
    cmake
    gnumake
    pkg-config

    # DevOps
    docker
    docker-compose
    kind
    kubectl
    kubernetes-helm

    # Shell & terminal
    zsh
    tmux
    mosh
    fzf
    ripgrep
    fd
    tree
    htop
    jq
    yq

    # VCS
    git

    # Utils
    curl
    wget
    direnv
    nix-direnv


    # Database clients
    postgresql

    # Security / encryption
    age
  ];

  #---------------------------------------------------------------------------
  # Programs with configuration
  #---------------------------------------------------------------------------

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      # Terminal settings for proper colors
      export TERM=xterm-direct
      export COLORTERM=truecolor

      # Source Nix profile (for non-NixOS systems)
      if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      elif [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      # Source Home Manager environment
      if [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
        source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      fi

      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Oh-my-zsh
      export ZSH="$HOME/.oh-my-zsh"
      ZSH_THEME="powerlevel10k/powerlevel10k"
      plugins=(git colored-man-pages colorize pip python kubectl)
      [[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # SSH agent forwarding
      socks=(/tmp/ssh-*/agent.*(N))
      if [[ -z $SSH_AUTH_SOCK && ''${#socks[@]} -gt 0 && -S ''${socks[1]} ]]; then
        export SSH_AUTH_SOCK=''${socks[1]}
      fi

      # Claude Code with encrypted API key
      claude-init() {
        local key_file="$HOME/.config/claude/age-key.txt"
        local encrypted_file="$HOME/.config/claude/api-key.age"

        if [[ ! -f "$key_file" ]]; then
          echo "Error: Age key not found at $key_file"
          echo "Generate with: age-keygen -o $key_file"
          return 1
        fi

        if [[ ! -f "$encrypted_file" ]]; then
          echo "Error: Encrypted API key not found at $encrypted_file"
          echo "Create with: echo 'ANTHROPIC_API_KEY=sk-ant-...' | age -e -r \$(age-keygen -y $key_file) > $encrypted_file"
          return 1
        fi

        eval "$(age -d -i "$key_file" "$encrypted_file")"
        echo "API key loaded. Starting Claude..."
        claude "$@"
      }
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g set-clipboard on
      set -g allow-passthrough on
      set -g mouse on
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB,xterm-direct:RGB"
    '';
  };

  programs.git = {
    enable = true;
    # User config should be set per-machine or via git config
  };

  #---------------------------------------------------------------------------
  # Dotfiles
  #---------------------------------------------------------------------------

  home.file = {
    ".emacs.d/init.el" = {
      source = ./links/emacs/init.el;
      force = true;
    };
    ".emacs.d/stuff" = {
      source = ./links/emacs/stuff;
      recursive = true;
      force = true;
    };
    ".oh-my-zsh" = {
      source = ./links/oh-my-zsh;
      recursive = true;
      force = true;
    };
    ".p10k.zsh" = {
      source = ./links/p10k.zsh;
      force = true;
    };
  };

  #---------------------------------------------------------------------------
  # Environment variables
  #---------------------------------------------------------------------------

  home.sessionVariables = {
    EDITOR = "emacs -nw";
    GOPATH = "$HOME/go";
    TERM = "xterm-direct";
    COLORTERM = "truecolor";
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];
}
