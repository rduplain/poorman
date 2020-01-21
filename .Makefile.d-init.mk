MAKEFILE_D_INIT_MK := $(abspath $(lastword $(MAKEFILE_LIST)))

MAKEFILE_D_URL ?= https://github.com/rduplain/Makefile.d.git
MAKEFILE_D_REV ?= v1.4 # Use --ref instead of --tag below if untagged.

QWERTY_SH_URL ?= https://qwerty.sh
QWERTY_SH ?= curl --proto '=https' --tlsv1.2 -sSf $(QWERTY_SH_URL) | sh -s -

.Makefile.d/%.mk: .Makefile.d/path.mk
	@touch $@

.Makefile.d/path.mk: $(MAKEFILE_D_INIT_MK)
	$(QWERTY_SH) -f -o .Makefile.d --tag $(MAKEFILE_D_REV) $(MAKEFILE_D_URL)
	@touch $@
