.PHONY: build
build:
	docker build -t dev .

.PHONY: run
run:
	docker run -it --rm dev zsh 

.PHONY: rm
rm:
	docker rm dev
