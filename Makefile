PHONY += all test clean docker docker-push
CURDIR := $(shell pwd)
GOBIN = $(CURDIR)/build/bin

# Define your docker repository
DOCKER_REPOSITORY := quay.io/alan
DOCKER_IMAGE := $(DOCKER_REPOSITORY)/$(notdir $(CURDIR))

ifeq ($(REV),)
REV := $(shell git rev-parse --short HEAD 2> /dev/null)
endif

CURRENT_DOCKER_IMAGE := $(DOCKER_IMAGE):$(REV)
LATEST_DOCKER_IMAGE := $(DOCKER_IMAGE):latest

APPS := $(sort $(notdir $(wildcard ./cmd/*)))
PHONY += $(APPS)

all: $(APPS)

.SECONDEXPANSION:
$(APPS): $(addprefix $(GOBIN)/,$$@)

$(GOBIN):
	@mkdir -p $@

$(GOBIN)/%: $(GOBIN) FORCE
	@go build -o $@ ./cmd/$(notdir $@)
	@echo "Done building."
	@echo "Run \"$(subst $(CURDIR),.,$@)\" to launch $(notdir $@)."

dep:
	@dep ensure

docker:
	@docker build -t $(CURRENT_DOCKER_IMAGE) -t $(LATEST_DOCKER_IMAGE) .

docker-push:
	@docker push $(CURRENT_DOCKER_IMAGE)
	@docker push $(LATEST_DOCKER_IMAGE)

test:
	@go test -v ./...

clean:
	@rm -fr $(GOBIN)

PHONY: help
help:
	@echo  'Generic targets:'
	@echo  '  all                         - Build all targets marked with [*]'
	@for app in $(APPS); do \
		printf "* %s\n" $$app; done
	@echo  ''
	@echo  'Docker targets:'
	@echo  '  docker                      - Build docker image'
	@echo  ''
	@echo  'Test targets:'
	@echo  '  test                        - Run all tests'
	@echo  ''
	@echo  'Cleaning targets:'
	@echo  '  clean                       - Remove built executables'
	@echo  ''
	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
	@echo  'For further info see the ./README.md file'

.PHONY: $(PHONY)

.PHONY: FORCE
FORCE:
