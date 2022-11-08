default: heroku-18 heroku-20

VERSION := 5.2.1
ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

clean:
	rm -rf src/ dist/

# Download missing source archives to ./src/
src/jemalloc-%.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -fsL https://github.com/jemalloc/jemalloc/releases/download/$*/jemalloc-$*.tar.bz2 -o $@

.PHONY: heroku-18 heroku-20 docker\:pull

# Updates the docker image to ensure we're building with the latest environment.
docker\:pull:
	docker pull heroku/heroku:18-build
	docker pull heroku/heroku:20-build

# Build for heroku-18 stack
heroku-18: src/jemalloc-$(VERSION).tar.bz2 docker\:pull
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:18-build /wrk/build.sh $(VERSION) heroku-18

# Build for heroku-20 stack
heroku-20: src/jemalloc-$(VERSION).tar.bz2 docker\:pull
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:20-build /wrk/build.sh $(VERSION) heroku-20

# Build recent releases for all supported stacks
all:
	$(MAKE) heroku-18 heroku-20 VERSION=5.2.1
	$(MAKE) heroku-18 heroku-20 VERSION=5.3.0