# Dotfiles

Portable development environment with Nix, Home Manager, and Flakes.

## What's included

- **Emacs** with custom configuration
- **Languages**: Go, Python, Clojure
- **DevOps**: Docker, docker-compose, kind, kubectl, helm
- **Shell**: Zsh with Oh-My-Zsh, Powerlevel10k, tmux
- **Tools**: direnv, ripgrep, fzf, mosh, git

## Quick start (fresh Ubuntu/Debian)

```bash
curl -fsSL https://raw.githubusercontent.com/Izpa/dotfiles/master/bootstrap.sh | bash
```

Or step by step:

```bash
# 1. Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# 2. Restart shell or source nix
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# 3. Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 4. Clone and install
git clone --recurse-submodules https://github.com/Izpa/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
nix run home-manager -- switch --flake .#dev
```

## Claude Code

Claude Code uses an encrypted API key for security. The key is encrypted with [age](https://github.com/FiloSottile/age) and decrypted only in memory when running.

### Setup (on local machine)

```bash
# 1. Generate encryption key
make claude-keygen

# 2. Encrypt your API key
make claude-encrypt KEY=sk-ant-api03-xxxxx

# 3. Copy to server
make claude-copy HOST=user@server
```

### Usage (on server)

```bash
claude-init
```

The `claude-init` function decrypts the API key, exports it as `ANTHROPIC_API_KEY`, and starts Claude.

### Security

- API key is stored encrypted with age
- Decrypted only in memory at runtime
- If server is compromised, attacker needs both the encrypted file and age private key
- You can rotate keys anytime by regenerating with `make claude-keygen` and re-encrypting

## Remote access with mosh

### Server setup

Open UDP ports for mosh:

```bash
sudo ufw allow 60000:61000/udp
```

Ensure zsh is default shell:

```bash
sudo chsh -s $(which zsh) $USER
```

### Client setup (macOS)

```bash
brew install mosh
```

### Connect

**1. Simple connection (just shell):**

```bash
mosh root@YOUR_SERVER_IP
```

**2. With tmux (persistent shell session):**

```bash
mosh root@YOUR_SERVER_IP -- tmux new -A -s main
```

**3. Straight to Emacs in tmux (recommended for development):**

```bash
mosh --server=/root/.nix-profile/bin/mosh-server root@YOUR_SERVER_IP -- tmux new -A -s emacs "emacs -nw"
```

This connects via mosh, attaches to tmux session "emacs", and runs Emacs. If session exists — reattaches to running Emacs.

**4. Kill and restart Emacs session:**

```bash
mosh --server=/root/.nix-profile/bin/mosh-server root@YOUR_SERVER_IP -- tmux kill-session -t emacs
mosh --server=/root/.nix-profile/bin/mosh-server root@YOUR_SERVER_IP -- tmux new -A -s emacs "emacs -nw"
```

Or in one command:

```bash
mosh --server=/root/.nix-profile/bin/mosh-server root@YOUR_SERVER_IP -- sh -c 'tmux kill-session -t emacs 2>/dev/null; tmux new -s emacs "emacs -nw"'
```

### Blink Shell (iPad)

In Blink, create a new host:
- Host: `dev` (or any name)
- Hostname: `YOUR_SERVER_IP`
- User: `root`
- Mosh: enabled

Set mosh server path in Blink host settings: `/root/.nix-profile/bin/mosh-server`

Commands:
```
mosh dev                                              # just shell
mosh dev -- tmux new -A -s main                       # shell in tmux
mosh dev -- tmux new -A -s emacs "emacs -nw"          # emacs in tmux
mosh dev -- sh -c 'tmux kill-session -t emacs 2>/dev/null; tmux new -s emacs "emacs -nw"'  # restart emacs
```

Or set the emacs command as default in host settings for one-tap access.

## Emacs recovery

If Emacs hangs or becomes unresponsive:

```bash
# 1. Soft - send SIGUSR2 (toggle debug-on-quit, may help with loops)
pkill -USR2 emacs

# 2. Medium - send SIGTERM (graceful shutdown, saves buffers)
pkill -TERM emacs

# 3. Hard - send SIGKILL (force kill, no save)
pkill -9 emacs
```

Or by PID if you have multiple instances:

```bash
# Find emacs processes
pgrep -a emacs

# Kill specific PID
kill -TERM <PID>    # graceful
kill -9 <PID>       # force
```

## Updating

```bash
cd ~/.dotfiles
git pull
nix flake update        # Update flake.lock
home-manager switch --flake .
```

## Structure

```
.
├── flake.nix          # Nix flake - entry point
├── flake.lock         # Locked dependency versions
├── home.nix           # Home Manager configuration
├── bootstrap.sh       # Bootstrap script for fresh systems
└── links/
    ├── emacs/         # Emacs configuration
    │   ├── init.el
    │   └── stuff/     # Modular emacs configs
    ├── oh-my-zsh/     # Oh-My-Zsh (submodule)
    └── p10k.zsh       # Powerlevel10k config
```

## Customization

Edit `home.nix` to add/remove packages or change configuration.

To add a new package:
```nix
home.packages = with pkgs; [
  # ... existing packages
  your-new-package
];
```

Apply changes:
```bash
home-manager switch --flake .
```

