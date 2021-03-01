CMD?=
VERSION?=1.5
DOCKER_IMAGE?=saxix/flower
DOCKERFILE?=Dockerfile
BUILD_OPTIONS?=--squash --compress --rm
DEVELOP?="0"
WORKERS?=1

help:
	@echo 'Options:                                                       '
	@echo '   options can be passed via environment variables             '
	@echo '   TARGET:   package version and tag                           '
	@echo '   DEVELOP:  1=Use local code - 0=feth release from github     '
	@echo 'Usage:                                                         '
	@echo '   make clean            removes images and containers         '
	@echo '   make build            build container                       '
	@echo '   make test             test container                        '
	@echo '   make run              run container (only app)              '
	@echo '   make shell                                                  '
	@echo '   make push             push image to docker hub              '
	@echo '                                                               '

clean:
	docker rmi --force ${DOCKER_IMAGE}:${VERSION}

dev:
	DEVELOP=1 $(MAKE) build

build:
	docker build ${BUILD_OPTIONS} \
			--build-arg PIP_INDEX_URL=${PIP_INDEX_URL} \
			--build-arg PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST} \
			-t ${DOCKER_IMAGE}:${VERSION} \
			-f ${DOCKERFILE} .
	@docker images | grep ${DOCKER_IMAGE}

.run:
	docker run \
			-p 5555:5555 \
			-p 8000:8000 \
			--rm \
			-e CELERY_BROKER_URL=redis://192.168.66.66:6379/2 \
			-e FLOWER_ADDRESS=0.0.0.0 \
			-e FLOWER_AUTH_PROVIDER=${FLOWER_AUTH_PROVIDER} \
			-it ${DOCKER_IMAGE}:${VERSION} \
			${CMD}

run:
	$(MAKE) .run

config:
	CMD='config' $(MAKE) .run

shell:
	CMD='/bin/sh' $(MAKE) run

release:
	docker tag ${DOCKER_IMAGE}:${VERSION} ${DOCKER_IMAGE}:latest
	docker push ${DOCKER_IMAGE}:${VERSION}
	docker push ${DOCKER_IMAGE}:latest


.PHONY: run
