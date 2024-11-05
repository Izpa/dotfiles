FROM nixos/nix

COPY default.nix /home/default.nix

ENV NIXPKGS_ALLOW_UNFREE=1
RUN nix-shell /home/default.nix

ARG GIT_COMMIT_HASH
ENV GIT_COMMIT_HASH=${GIT_COMMIT_HASH}
RUN nix-shell /home/default.nix --run "git clone https://github.com/Izpa/dotfiles.git /home/.dotfiles \
    && cd /home/.dotfiles && git checkout ${GIT_COMMIT_HASH} && ./install"

WORKDIR /home

RUN nix-shell /home/default.nix --run "emacs --batch -l /root/.emacs.d/init.el -f package-refresh-contents -f package-install-selected-packages"

RUN echo "exec zsh" >> /home/.bashrc

COPY entrypoint.sh /home/entrypoint.sh

RUN chmod +x /home/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["nix-shell", "/home/default.nix", "--run", "\"/home/entrypoint.sh\""]

#ENTRYPOINT [ "nix-shell", "/home/default.nix", "--run" ]

#CMD ["zsh"]
