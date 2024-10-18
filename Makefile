# Указываем имя образа и пользователя на Docker Hub
IMAGE_NAME = dev
TAG = latest

# Цель по умолчанию - сборка и пуш образа с latest тегом
.PHONY: all
all: build push

# Сборка Docker-образа
.PHONY: build
build:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG) .

# Сборка образа с конкретной версией
.PHONY: build-version
build-version:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION_TAG) .

# Пуш Docker-образа в Docker Hub с latest тегом
.PHONY: push
push:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)

# Пуш Docker-образа с версией
.PHONY: push-version
push-version:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION_TAG)

# Логин в Docker Hub (запросит логин и пароль)
.PHONY: login
login:
	docker login

# Очистка локальных образов (опционально, чтобы освободить место)
.PHONY: clean
clean:
	docker rmi $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)
	docker rmi $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION_TAG)

# Запуск контейнера с монтированием SSH-ключей и проектов
# Передача путей через аргументы командной строки
.PHONY: run
run:
	docker run --rm -v $(SSH):/root/.ssh -v $(PROJECTS):/projects $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)
