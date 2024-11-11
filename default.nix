{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.emacs29
    pkgs.curl
    pkgs.wget
    pkgs.nano
    pkgs.git
    pkgs.go
    pkgs.python3
    pkgs.clojure
    pkgs.leiningen
    pkgs.zsh
    pkgs.cmake
    pkgs.libvterm-neovim
    pkgs.direnv
    pkgs.glib
    pkgs.pkg-config
    pkgs.gcc
    pkgs.tmux
    pkgs.docker
    pkgs.docker-compose
    pkgs.postgresql.liby
  ];
}

