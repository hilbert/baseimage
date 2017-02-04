NAME          ?= hilbert/baseimage
IMAGE_VERSION ?= latest
# export IMAGE_VERSION=devel

.PHONY: all build

# Get the latest git commit ID
GIT_COMMIT=$(strip $(shell git rev-parse --short HEAD))
# Get the git repository URL
GIT_ORIGIN_URL=$(strip $(shell git config --get remote.origin.url))
# Get the current checkout status
GIT_NOT_CLEAN_CHECK=$(strip $(shell git status --porcelain))

ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
DOCKER_TAG_SUFFIX = "-dirty"
endif

VCS_REF       ?= ${GIT_COMMIT}
VCS_URL       ?= ${GIT_ORIGIN_URL}


all: build

DOCKER_BUILD_OPTS=--pull=true --force-rm=true --rm=true \
--build-arg IMAGE_VERSION="${IMAGE_VERSION}" \
--build-arg VCS_REF="${VCS_REF}" \
--build-arg VCS_URL="${VCS_URL}" \
--build-arg GIT_NOT_CLEAN_CHECK="${GIT_NOT_CLEAN_CHECK}" \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`

build:
	docker build ${DOCKER_BUILD_OPTS} -t "$(NAME):$(IMAGE_VERSION)" image

devel:
	export IMAGE_VERSION=devel
	docker build -t $(NAME):$(IMAGE_VERSION) --rm image

pull:
	docker pull $(NAME):$(IMAGE_VERSION)
