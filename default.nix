{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.emacs
    pkgs.curl
    pkgs.wget
    pkgs.nano
    pkgs.git
    pkgs.go
    pkgs.python3
    pkgs.clojure
    pkgs.leiningen
    pkgs.openssh
    pkgs.ngrok
    pkgs.zsh   # Устанавливаем zsh
  ];

  shellHook = ''
    # Установка oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
      echo "Установка oh-my-zsh..."
      sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
      echo "oh-my-zsh уже установлен."
    fi
  '';
}
