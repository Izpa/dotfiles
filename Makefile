GIT_COMMIT_HASH := $(shell git ls-remote https://github.com/Izpa/dotfiles.git HEAD | awk '{ print $$1 }')

.PHONY: build
build:
	docker build --build-arg GIT_COMMIT_HASH=$(GIT_COMMIT_HASH) -t dev .

.PHONY: run
run:
	docker run -it --rm dev 

.PHONY: rm
rm:
	docker rm dev
