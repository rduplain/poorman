DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/path.mk
include $(DIR)/utility-command.mk

BATS_VERSION = 0.4.0
BATS_FORK = sstephenson/bats

# Tag is prefixed with 'v'; unpacked directory is not.
BATS_TAG = v$(BATS_VERSION)
BATS_ARCHIVE = bats-$(BATS_VERSION).tar.gz
BATS_URL = https://github.com/$(BATS_FORK)/archive/$(BATS_TAG).tar.gz
BATS_SRC = $(PROJECT_ROOT)/opt/src
BATS_PREFIX = $(PROJECT_ROOT)/opt/bats
BATS = $(BATS_PREFIX)/bin/bats

export BATS

bats-command: $(BATS) curl-command

$(BATS): $(BATS_SRC)/bats-$(BATS_VERSION)/README.md
	@cd $(BATS_SRC); cd bats-$(BATS_VERSION); ./install.sh $(BATS_PREFIX)

$(BATS_SRC)/bats-$(BATS_VERSION)/README.md: $(BATS_SRC)/$(BATS_ARCHIVE)
	@cd $(BATS_SRC); tar -xvzf $(BATS_ARCHIVE)
	@touch $@

$(BATS_SRC)/$(BATS_ARCHIVE): $(DIR)/bats-command.mk
	@mkdir -p $(BATS_SRC)
	@cd $(BATS_SRC); curl -L -o $(BATS_ARCHIVE) $(BATS_URL)

clean-bats:
	rm -fr $(BATS_PREFIX) $(BATS_SRC)

.PHONY: bats-command
