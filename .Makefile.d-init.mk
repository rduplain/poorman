MAKEFILE_D_INIT_MK := $(abspath $(lastword $(MAKEFILE_LIST)))

MAKEFILE_D_URL ?= https://github.com/rduplain/Makefile.d.git
MAKEFILE_D_REV ?= v1.3.1 # Use --ref instead of --tag below if untagged.

ifeq ($(QWERTY_SH),)
QWERTY_SH := curl -sSL qwerty.sh | sh -s -
endif

.Makefile.d/%.mk: .Makefile.d/path.mk
	@touch $@

.Makefile.d/path.mk: $(MAKEFILE_D_INIT_MK)
	$(QWERTY_SH) -f -o .Makefile.d --tag $(MAKEFILE_D_REV) $(MAKEFILE_D_URL)
	@touch $@
