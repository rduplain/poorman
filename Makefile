include .Makefile.d/bats-command.mk

all: test

test: bats-command
	@$(BATS) test/*.bats

clean: clean-bats

.PHONY: test
