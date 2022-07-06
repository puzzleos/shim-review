#
# UEFI shim build/review makefile
#

SHELL=/bin/bash

.PHONY: all
all: help

#@ help:                        help message
.PHONY: help
help:
	@echo "Make Targets"
	@echo ""
	@cat Makefile | sed -n 's/^#@\(.*\)/\1/p'
	@echo ""

#@ build:                       build the uefi shim bootloader using docker
.PHONY: build
build: Dockerfile
	ts=`date "+%Y%m%d%H%M%S"`; \
	d=artifacts.$$ts; \
	mkdir $$d && \
	docker build -t shim . |& tee $$d/build.log && \
	c=`docker create shim` && \
	for i in shimx64.efi mmx64.efi fbx64.efi \
		 vendor_db.esl; do \
		docker cp $$c:/shim-15.6/$$i $$d; \
	done && \
	docker rm $$c

#@ clean:                       clean the docker images
.PHONY: clean
clean:
	-docker rmi shim

#@ clean-artifacts:             clean all build artifacts
.PHONY: clean-artifacts
clean-artifacts:
	-rm -rf artifacts.*

#@ clean-unsafe:                clean the docker images and all build artifacts
.PHONY: clean-unsafe
clean-unsafe: clean-artifacts clean
