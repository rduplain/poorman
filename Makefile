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
		gem install --no-ri --no-rdoc 'coveralls:~> 0.8' 'bashcov:~> 1.3'

clean: clean-bats

.PHONY: test
