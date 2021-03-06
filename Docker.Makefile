DEV_DOCKER_IMAGE_NAME = sphinx-docker-sample # change this to your own name!!
MOUNTS = -v "`pwd`":/usr/local/src/doc
ENVVARS =
BUILDARGS =

build: html

# build docker image
.PHONY: build_docker_image
build_docker_image:
	docker build $(BUILDARGS) -t $(DEV_DOCKER_IMAGE_NAME) -f ./Dockerfile .
	#docker pull $(DEV_DOCKER_IMAGE_NAME)

# build documents using a container
.PHONY: html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck doctest gettext
html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck doctest gettext: build_docker_image
	docker run --rm $(ENVVARS) $(MOUNTS) $(DEV_DOCKER_IMAGE_NAME) make $@

# clean build artifacts using a container
.PHONY: clean
clean: build_docker_image
	docker run --rm $(ENVVARS) $(MOUNTS) $(DEV_DOCKER_IMAGE_NAME) make clean

# clean docker image
.PHONY: clean_docker_image
clean_docker_image:
	docker rmi $(DEV_DOCKER_IMAGE_NAME)

# start container in interactive mode for inspection
.PHONY: dev
dev: build_docker_image
	docker run -it $(ENVVARS) $(MOUNTS) $(DEV_DOCKER_IMAGE_NAME) bash

shell: dev
