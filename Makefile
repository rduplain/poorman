include .Makefile.d/bats-command.mk

all: test

test: bats-command
	@$(BATS) test/*.bats

coverage: bats-command
	@bashcov $(BATS) test/*.bats

run:
	@./poorman start

clean: clean-bats

.PHONY: test
