#!/usr/bin/make -f

include .env

KEY_GEN := false
BINDIR ?= $(GOPATH)/bin
ETHERMINT_BINARY := ethermintd
ETHERMINT_DIR := ethermint

# Ensure the KMS_DEV_VERSION matches the version in docker-compose-full.yml
KMS_DEV_VERSION ?= v0.7.1

export GO111MODULE := on

# Default target executed when no arguments are given to make.
default_target: all

.PHONY: default_target

# Process build tags
###############################################################################
###                                Single validator                         ###
###############################################################################

generate-fhe-keys:
	@bash ./scripts/copy-fhe-keys.sh $(KMS_DEV_VERSION) $(PWD)/network-fhe-keys $(PWD)/kms-fhe-keys

run-full:
	$(MAKE) generate-fhe-keys
	@docker compose --env-file docker-compose/.env.docker -f docker-compose/docker-compose-full.yml up --detach
	@echo 'Sleeping for a few seconds to allow Docker to start up...'
	sleep 5

stop-full:
	@docker compose --env-file docker-compose/.env.docker -f docker-compose/docker-compose-full.yml down

clean:
	$(MAKE) stop-full
	rm -rf network-fhe-keys kms-fhe-keys

print-info:
	@echo 'KMS_DEV_VERSION: $(KMS_DEV_VERSION) for KEY_GEN---extracted from Makefile'
