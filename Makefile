GIT_COMMIT_HASH := $(shell git ls-remote https://github.com/Izpa/dotfiles.git HEAD | awk '{ print $$1 }')

.PHONY: build
build:
	docker build --build-arg GIT_COMMIT_HASH=$(GIT_COMMIT_HASH) -t dev .

.PHONY: run
run:
	docker run --rm -d \
		-p 2222:22 \
		-p 8080:8080 \
		-e ROOT_SSH_KEY="$(shell cat ~/.ssh/id_rsa.pub)" \
		-e GIT_USER_NAME="$(shell git config --global user.name)" \
		-e GIT_USER_EMAIL="$(shell git config --global user.email)" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v ~/projects:/root/projects \
		-v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
		--network dev-net \
		--name dev \
			dev

.PHONY: conn
conn:
	ssh -p 2222 root@localhost

.PHONY: rm
rm:
	docker rm -f  dev

.PHONY: net-up
net-up:
	docker network create dev-net
