all: test

run:
	@./poorman start

test: bats-command
	@$(BATS) test/*.bats

coverage: bashcov-command bats-command
	@bashcov $(BATS) test/*.bats

include .Makefile.d-init.mk
include .Makefile.d/bats.mk

bashcov-command: gem-command
	@which bashcov > /dev/null || \
		gem install --no-document \
			simplecov:0.12.0 \
			coveralls:0.8.19 \
			bashcov:1.3.1

.PHONY: test
