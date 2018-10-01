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

stategraph_SOURCES  := stategraph.m4 stategraph_styles.m4
stategraph_LIB			:= stategraph.m4f

examplesdir					:= $(srcdir)/../examples

example_SOURCES			:= $(notdir $(wildcard $(examplesdir)/*.gv.m4))
example_GVS					:= $(example_SOURCES:.gv.m4=.gv)
example_PNGS				:= $(example_SOURCES:.gv.m4=.png)

vpath %.gv.m4 $(examplesdir)
vpath %.m4 $(srcdir)

.SUFFIXES += .gv.m4 .m4

### OUTPUTS ####################################################################

built_files					:= $(stategraph_LIB)
build_patterns			:= *.gv *.png
build_dirs					:= $(util_searcher)
all_built						:= $(built_files) $(wildcard $(call util_cross,$(build_dirs),$(build_patterns),/))

%.m4f: %.m4 
	$(M4) -I"$(srcdir)" -P $< -F $@

%.gv: %.gv.m4 $(stategraph_LIB)
	$(M4) -R $(stategraph_LIB) -P $< > $@

%.png: %.gv 
	$(DOT) -Tpng $< > $@	

all: examples $(stategraph_LIB)

examples: $(example_GVS) $(example_PNGS)

install:
	@echo "not configured (target: $@)"

uninstall:
	@echo "not configured (target: $@)"

list_all_built:
	@echo "$(all_built)"
	
clean:
	rm -rf $(all_built)

distclean: clean

mostlyclean: clean

check:
	@echo "not configured (target: $@)"
	
.PHONY: all examples install uninstall list_all_built clean distclean mostlyclean check
















