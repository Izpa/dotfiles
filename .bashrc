# Автоматический вход в nix-shell и запуск tmux с Emacs
if [ -z "$IN_NIX_SHELL" ]; then
    export NIXPKGS_ALLOW_UNFREE=1
    exec nix-shell /root/default.nix --run "tmux attach -t emacs_session || tmux new -s emacs_session 'TERM=xterm-direct emacs -nw'"
fi

