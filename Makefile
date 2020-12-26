# kernel-style V=1 build verbosity
ifeq ('$(origin V)', 'command line')
	BUILD_VERBOSE = $(V)
endif
ifeq ($(BUILD_VERBOSE),1)
	Q =
else
	Q = @
endif

ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command 

REGISTRY_NAME := 
REPOSITORY_NAME := extentreports/
IMAGE_NAME := extentreports-dotnet-cli
TAG := :latest

all: build

build:
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) .

test: build
	docker run --rm -w /test -v $${PWD}:/test $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -i /test/PesterResults.xml -o /test/Results/
