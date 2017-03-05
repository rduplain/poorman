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
		gem install --no-ri --no-rdoc \
			simplecov:0.11.0 \
			coveralls:0.8.12 \
			bashcov:1.3.1

clean: clean-bats

.PHONY: test
