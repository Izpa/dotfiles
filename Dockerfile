FROM nixos/nix

COPY default.nix /home/default.nix

ENV NIXPKGS_ALLOW_UNFREE=1
RUN nix-shell /home/default.nix

RUN nix-shell /home/default.nix --run "git clone https://github.com/Izpa/dotfiles.git /home/.dotfiles \
    && cd /home/.dotfiles && ./install"

WORKDIR /home

RUN nix-shell /home/default.nix --run "emacs --batch -l /root/.emacs.d/init.el -f package-refresh-contents -f package-install-selected-packages"

EXPOSE 2222

CMD nix-shell /home/default.nix --run "TERM=xterm-direct emacs -nw"