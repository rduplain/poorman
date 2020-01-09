include .Makefile.d/bats-command.mk

all: test

run:
	@./poorman start

test: bats-command
	@$(BATS) test/*.bats

coverage: bashcov-command bats-command
	@bashcov $(BATS) test/*.bats

bashcov-command: gem-command
	@which bashcov > /dev/null || \
		gem install --no-document \
			simplecov:0.12.0 \
			coveralls:0.8.19 \
			bashcov:1.3.1

clean: clean-bats

.PHONY: test
