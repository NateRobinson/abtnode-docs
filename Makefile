TOP_DIR=.

VERSION=$(strip $(shell cat version))

build: clean
	@echo "Building static pages..."
	@DEBUG=@arcblock/* yarn build
	@rm public/*.js.map

all: build

init:
	@echo "Install npm dependencies required for this repo..."
	@npm install -g gatsby-cli yarn
	@yarn --force

clean:
	@rm -rf public && rm -rf .cache
	@echo "All pages are cleaned."

deploy:
	@echo "Building and publishing the documenation..."
	@gem install travis -v 1.8.9
	@.makefiles/trigger_main_build.sh

run:
	@yarn start

redep:
	@echo "Rebuilding dependencies..."
	@rm -rf node_modules
	@rm -f yarn.lock
	@yarn
	@git checkout yarn.lock

serve: build
	@yarn serve

travis: init
	@echo "Prepare travis build env"

include .makefiles/release.mk

.PHONY: all clean $(DIRS) build run watch
