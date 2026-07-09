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
    emacs30  # Emacs 30 with native :vc support in use-package

    # Languages
    go
    (lib.hiPrio gopls)
    gotools
    golangci-lint
    delve  # dlv: Go debugger (dape adapter)
    python3
    python3Packages.pip
    python3Packages.python-lsp-server
    python3Packages.black
    python3Packages.debugpy  # Python debugger (dape adapter)
    ruff  # fast Python linter/formatter
    clojure
    leiningen
    clojure-lsp
    nodejs_22  # for copilot and other tools

    # Nix / shell tooling (for editing this repo in Emacs)
    nixd  # Nix LSP
    nixfmt-rfc-style  # Nix formatter
    shellcheck

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
    btop
    jq
    yq
    # Modern unix replacements
    eza  # ls
    bat  # cat
    zoxide  # smart cd (also configured via programs.zoxide)

    # VCS
    git

    # Utils
    curl
    wget
    direnv
    nix-direnv

    # Database clients
    postgresql
  ];

  #---------------------------------------------------------------------------
  # Programs with configuration
  #---------------------------------------------------------------------------

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Smart cd; `z <dir>` jumps by frecency. Adds a `zsh` init hook.
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Synced, searchable shell history. Binds Ctrl-r.
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    # Without this atuin also grabs the Up arrow, shadowing oh-my-zsh's
    # up-line-or-beginning-search.
    flags = [ "--disable-up-arrow" ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza --icons --git";
      ll = "eza -la --icons --git";
      lt = "eza --tree --level=2 --icons";
      cat = "bat";
    };
    initContent = ''
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

    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g set-clipboard on
      set -g mouse on
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB,xterm-direct:RGB"
      # allow-passthrough requires tmux 3.3+, check version before enabling
      if-shell '[ "$(tmux -V | cut -d" " -f2 | tr -d "a-z")" \> "3.2" ]' \
        'set -g allow-passthrough on'
      # Ensure nix PATH is available in all tmux commands
      set -g default-command "zsh -l"
    '';
  };

  programs.git = {
    enable = true;
    # User config should be set per-machine or via git config
    delta.enable = true;  # syntax-highlighted diff pager
  };

  #---------------------------------------------------------------------------
  # Dotfiles
  #---------------------------------------------------------------------------

  home.file = {
    ".emacs.d/early-init.el" = {
      source = ./links/emacs/early-init.el;
      force = true;
    };
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
    "$HOME/.rokit/bin"  # Rokit-managed Roblox toolchain (rojo, luau-lsp, ...)
    "$HOME/.nix-profile/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];
}
