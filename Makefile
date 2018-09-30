#!/usr/bin/env make

PACKAGE							:= stategraph
PACKAGE_AUTHORS			:= Chris Bode
PACKAGE_CONTACT			:= chris@eonz.net

M4	?= $(shell which m4)
DOT	?= $(shell which dot)

### UTILITIES ##################################################################

util_searcher				=	. ./* ./*/* ./*/*/* ./*/*/*/*
util_cross					= $(foreach a,$(1),$(foreach b,$(2), $(a)$(3)$(b)))

### STANDARD DIRECTORIES #######################################################

prefix							?= /usr/local
exec_prefix					?= $(prefix)
bindir							?= $(exec_prefix)/bin
libdir							?= $(exec_prefix)/lib
sbindir							?= $(exec_prefix)/sbin
libexecdir					?= $(exec_prefix)/libexec
datarootdir					?= $(prefix)/share
datadir							?= $(datarootdir)
sysconfdir					?= $(prefix)/etc
sharedstatedir			?= $(prefix)/com
localstatedir				?= $(prefix)/var
runstatedir					?= $(localstatedir)/run
includedir					?= $(prefix)/include
pkgdatadir					?= $(datarootdir)/$(PACKAGE)
docdir							?= $(datarootdir)/doc/$(PACKAGE)
mandir							?= $(datarootdir)/man
man1dir							?= $(mandir)/man1
man1ext							?= .1
manext							?= $(man1ext)
srcdir 							?= .

# NON-STANDARD:

examplesdir					:= $(srcdir)/../examples
example_SOURCES			:= $(notdir $(wildcard $(examplesdir)/*.gv.m4))
example_GVS					:= $(example_SOURCES:.gv.m4=.gv)
example_PNGS				:= $(example_SOURCES:.gv.m4=.png)

VPATH               := .:$(srcdir):$(examplesdir)

### OUTPUTS ####################################################################

built_files					:= 
build_patterns			:= *.gv *.png
build_dirs					:= $(util_searcher)

all_built						:= $(wildcard $(call util_cross,$(build_dirs),$(build_patterns),/))

%.gv: %.gv.m4
	$(M4) -I"$(srcdir)" -P $< > $@

%.png: %.gv
	$(DOT) -Tpng $< > $@	

all: examples

examples: $(example_GVS) $(example_PNGS)

install:
	@echo "not configured (target: $@)"

uninstall:
	@echo "not configured (target: $@)"

list_all_built:
	@echo "$(all_built)"
	
clean:
	rm -rf $(all_built)

distclean:
	@echo "not configured (target: $@)"

mostlyclean:
	@echo "not configured (target: $@)"

check:
	@echo "not configured (target: $@)"
	
.PHONY: all examples install uninstall list_all_built clean distclean mostlyclean check
















