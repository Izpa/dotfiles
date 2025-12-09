# Claude Code setup
CLAUDE_CONFIG_DIR := ~/.config/claude
AGE_KEY := $(CLAUDE_CONFIG_DIR)/age-key.txt
AGE_ENCRYPTED := $(CLAUDE_CONFIG_DIR)/api-key.age

.PHONY: claude-keygen
claude-keygen:
	@mkdir -p $(CLAUDE_CONFIG_DIR)
	@if [ -f $(AGE_KEY) ]; then \
		echo "Age key already exists at $(AGE_KEY)"; \
		echo "Public key:"; \
		age-keygen -y $(AGE_KEY); \
	else \
		age-keygen -o $(AGE_KEY); \
		chmod 600 $(AGE_KEY); \
		echo "Key saved to $(AGE_KEY)"; \
	fi

.PHONY: claude-encrypt
claude-encrypt:
	@if [ -z "$(KEY)" ]; then \
		echo "Usage: make claude-encrypt KEY=sk-ant-..."; \
		exit 1; \
	fi
	@mkdir -p $(CLAUDE_CONFIG_DIR)
	@if [ ! -f $(AGE_KEY) ]; then \
		echo "Error: Run 'make claude-keygen' first"; \
		exit 1; \
	fi
	@echo "ANTHROPIC_API_KEY=$(KEY)" | age -e -r $$(age-keygen -y $(AGE_KEY)) > $(AGE_ENCRYPTED)
	@chmod 600 $(AGE_ENCRYPTED)
	@echo "Encrypted key saved to $(AGE_ENCRYPTED)"

.PHONY: claude-copy
claude-copy:
	@if [ -z "$(HOST)" ]; then \
		echo "Usage: make claude-copy HOST=user@server"; \
		exit 1; \
	fi
	ssh $(HOST) "mkdir -p ~/.config/claude"
	scp $(AGE_KEY) $(AGE_ENCRYPTED) $(HOST):~/.config/claude/
	@echo "Files copied to $(HOST)"

.PHONY: claude-install
claude-install:
	npm install -g @anthropic-ai/claude-code
