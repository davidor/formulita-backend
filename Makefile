MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

DOCKER_USER := formulita
DOCKER_APP_HOME := /home/$(DOCKER_USER)
DOCKER_PROJECT_PATH := $(DOCKER_APP_HOME)/app

IMAGE := formulita

SEASON := 2017

TEST_CMD := bundle exec rake
IMPORT_SEASON_CMD := bundle exec rake import_season[$(SEASON)]
RUN_CMD := bundle exec ruby -S rackup -w config.ru

.PHONY: build bash test import-season run

default: test

build:
	docker build -t $(IMAGE) $(PROJECT_PATH)

bash: build
	docker run --rm -t -i -v $(PROJECT_PATH):$(DOCKER_PROJECT_PATH):z $(IMAGE) /bin/bash

test: build
	docker run --rm -t $(IMAGE) $(TEST_CMD)

import-season:
	$(IMPORT_SEASON_CMD)

run: import-season build
	docker run --net=host --rm -t $(IMAGE) $(RUN_CMD)
