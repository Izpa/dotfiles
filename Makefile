.PHONY: install
install:
	@echo "==> Installing environment..."
	@# Ensure nix profile is in PATH
	@export PATH="$$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$$PATH"; \
	if [ -f "$$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then \
		. "$$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"; \
	fi; \
	echo "==> Running home-manager..."; \
	USERNAME=$$(whoami); \
	if [ "$$USERNAME" = "root" ]; then \
		nix run home-manager -- switch --flake .#root; \
	else \
		nix run home-manager -- switch --flake .#dev; \
	fi; \
	echo "==> Installing Claude Code..."; \
	mkdir -p $$HOME/.npm-global; \
	npm config set prefix $$HOME/.npm-global; \
	npm install -g @anthropic-ai/claude-code; \
	echo "==> Done! Run 'exec zsh' to reload shell."
