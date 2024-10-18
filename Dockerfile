FROM nixos/nix

COPY default.nix /home/default.nix

ENV NIXPKGS_ALLOW_UNFREE=1
RUN nix-shell /home/default.nix

COPY links/emacs/init.el /root/.emacs.d/init.el
COPY links/emacs/stuff /root/.emacs.d/stuff
COPY links/zshrc /root/.zshrc /root/
COPY links/oh-my-zsh/oh-my-zsh /root/.oh-my-zsh

WORKDIR /home

RUN nix-shell /home/default.nix --run "emacs --batch -l /root/.emacs.d/init.el -f package-refresh-contents -f package-install-selected-packages"

CMD nix-shell /home/default.nix --run "TERM=xterm-direct emacs -nw"