.PHONY: install
install:
	@./scripts/install.sh

.PHONY: update
update:
	@git pull
	@git submodule update --init --recursive
	@./scripts/install.sh
