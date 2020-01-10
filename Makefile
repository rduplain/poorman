all: test

run:
	@./poorman start

test: bats-command
	@$(BATS) test/*.bats

coverage: bashcov-command bats-command
	@$(BASHCOV) $(BATS) test/*.bats

MAKEFILE := $(lastword $(MAKEFILE_LIST))

include .Makefile.d-init.mk
include .Makefile.d/bats.mk
include .Makefile.d/ruby.mk

BASHCOV := $(GEM_HOME)/bin/bashcov

bashcov-command: $(BASHCOV)

$(BASHCOV): Gemfile | bundle-command
	@$(BUNDLE) install
	@touch $@

Gemfile: $(MAKEFILE)
	@echo "# GENERATED FILE - DO NOT EDIT"                   >  $@
	@echo                                                    >> $@
	@echo "source 'https://rubygems.org'"                    >> $@
	@echo                                                    >> $@
	@echo "gem 'bashcov', '~> 1.8'"                          >> $@
	@echo "gem 'coveralls', '~> 0.8'"                        >> $@

.PHONY: test
