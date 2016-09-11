include .Makefile.d/bats-command.mk

all: test

test: bats-command
	@$(BATS) test/*.bats

coverage: bats-command coverage-deps
	@bashcov $(BATS) test/*.bats

coverage-deps:
	@gem install --no-ri --no-rdoc coveralls -v '~> 0.8'
	@gem install --no-ri --no-rdoc bashcov -v '~> 1.3'

run:
	@./poorman start

clean: clean-bats

.PHONY: test
