# Use Debian as the base image for essential system utilities
FROM debian:stable-slim

# Install essential utilities for Nix and SSH
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    gnupg \
    openssh-server \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and permissions for multi-user Nix installation
RUN mkdir -p /nix && chmod 777 /nix && \
    groupadd -r -g 996 nixbld && \
    for i in $(seq 1 10); do \
      useradd -m -d /var/empty -g nixbld -s /sbin/nologin nixbld$i; \
    done

# Set environment variables for installation
ENV NIX_BUILD_GROUP_ID=996
ENV NIX_FIRST_BUILD_UID=1000

# Install the Nix package manager with multi-user mode
RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Set up Nix environment for all following commands
ENV NIX_PATH=/nix/var/nix/profiles/per-user/root/channels
ENV NIXPKGS_ALLOW_UNFREE=1
ENV PATH=/root/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH

# Source the Nix profile for non-interactive shells
SHELL ["/bin/bash", "-c"]

# Copy default.nix for defining the environment
COPY default.nix /root/default.nix

# Build the environment using Nix
RUN nix-shell /root/default.nix --run "echo 'Nix environment built'"

# Argument for specifying the GIT_COMMIT_HASH for dotfiles
ARG GIT_COMMIT_HASH
ENV GIT_COMMIT_HASH=${GIT_COMMIT_HASH}

# Clone dotfiles, checkout the specific commit
RUN nix-shell /root/default.nix --run "\
    git clone https://github.com/Izpa/dotfiles.git /root/.dotfiles && \
    cd /root/.dotfiles && git checkout ${GIT_COMMIT_HASH} && ./install"

# Set bash as the default shell for root
RUN chsh -s /bin/bash root

# Install Emacs packages
RUN nix-shell /root/default.nix --run "emacs --batch -l /root/.emacs.d/init.el -f package-refresh-contents -f package-install-selected-packages"

# Configure SSH server and generate SSH keys
RUN mkdir -p /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Expose port for SSH
EXPOSE 22
# Expose port for show web app
EXPOSE 8080

# Copy entrypoint script
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Copy .bashrc for auto-launching nix-shell and tmux
COPY .bashrc /root/.bashrc

# Set the entrypoint to start SSH and nix-shell
ENTRYPOINT ["nix-shell", "/root/default.nix", "--command", "/root/entrypoint.sh"]

#CMD nix-shell /home/default.nix --run "TERM=xterm-direct emacs -nw"

#ENTRYPOINT ["nix-shell", "/home/default.nix", "--run", "sshd -D"]
