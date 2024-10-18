# Используем базовый образ с NixOS
FROM nixos/nix

# Копируем файл default.nix
COPY default.nix /home/default.nix

# Устанавливаем пакеты из default.nix
ENV NIXPKGS_ALLOW_UNFREE=1
RUN nix-shell /home/default.nix

# Копируем файл init.el в директорию пользователя Emacs
COPY links/emacs/init.el /root/.emacs.d/init.el
COPY links/emacs/stuff /root/.emacs.d/stuff

# Устанавливаем рабочую директорию
WORKDIR /home

# Устанавливаем пакеты Emacs
RUN nix-shell /home/default.nix --run "emacs --batch -l /root/.emacs.d/init.el -f package-refresh-contents -f package-install-selected-packages"

# Опционально: запускаем Emacs в консольном режиме для проверки
CMD nix-shell /home/default.nix --run "emacs"