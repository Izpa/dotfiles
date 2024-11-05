#!/usr/bin/env zsh

# Запускаем в nix-shell, чтобы иметь доступ ко всем установленным пакетам
nix-shell /home/default.nix --run "
    # Настройка SSH-ключа
    if [ -n \"\$SSH_PUBLIC_KEY\" ]; then
        echo \"Setting up SSH key authentication...\"
        mkdir -p /root/.ssh
        echo \"\$SSH_PUBLIC_KEY\" > /root/.ssh/authorized_keys
        chmod 600 /root/.ssh/authorized_keys
        chmod 700 /root/.ssh
        # Отключаем аутентификацию по паролю
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    else
        echo \"SSH_PUBLIC_KEY not provided.\"
    fi

    # Настройка пароля
    if [ -n \"\$SSH_PASSWORD\" ] && [ -z \"\$SSH_PUBLIC_KEY\" ]; then
        echo \"Setting up SSH password authentication...\"
        echo \"root:\$SSH_PASSWORD\" | chpasswd
        sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    else
        echo \"SSH_PASSWORD not provided or SSH_PUBLIC_KEY is set.\"
    fi

    # Проверка наличия хотя бы одной переменной
    if [ -z \"\$SSH_PUBLIC_KEY\" ] && [ -z \"\$SSH_PASSWORD\" ]; then
        echo \"Error: Either SSH_PUBLIC_KEY or SSH_PASSWORD must be provided.\"
        exit 1
    fi

    # Установка среды для Emacs
    echo 'exec env TERM=xterm-direct emacs -nw' > /root/.zshrc

    echo \"Starting SSH server...\"
    /usr/sbin/sshd -D
"

