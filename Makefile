DOCKER=docker
IMAGE_NAME=garmin
CONTAINER_NAME=$(shell cat .container-name)
BIND_DIR=container-home
PROJECT_DIR=project
DOCKER_ARGS=-e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix \
    --mount type=bind,source=$(shell pwd)/$(BIND_DIR),target=/home/developer/ \
    --mount type=bind,source=$(shell pwd)/$(PROJECT_DIR),target=/home/developer/project
RUN_IN_CONTAINER=$(DOCKER) exec $(CONTAINER_NAME) /entrypoint.sh


.SECONDARY:

container-build:
	$(DOCKER) build -t $(IMAGE_NAME) .
	mkdir -p $(BIND_DIR)
	$(shell echo $(IMAGE_NAME)_$(shell date +%N) > .container-name)
	$(DOCKER) run --rm $(DOCKER_ARGS) --name $(shell cat .container-name) $(IMAGE_NAME) /post_install.sh

container-shell:
	$(DOCKER) run --rm -it $(DOCKER_ARGS) --name $(CONTAINER_NAME) $(IMAGE_NAME) /entrypoint.sh /bin/bash -i

container-attach:
	$(DOCKER) exec -it $(CONTAINER_NAME) /entrypoint.sh /bin/bash -i

container-clean:
	rm -rf $(BIND_DIR)


DEVICE=edge130

%.der:
	openssl genrsa -out $*.pem 4096
	openssl pkcs8 -topk8 -inform PEM -outform DER -in $*.pem -out $*.der -nocrypt

%.prg: %.jungle %.der
	$(RUN_IN_CONTAINER) monkeyc -d $(DEVICE) -f $< -o $@ -y $*.der

%: %.prg
	$(RUN_IN_CONTAINER) monkeydo $< $(DEVICE)
