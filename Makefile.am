# $Id: Makefile.am 216 2006-07-09 17:32:37Z r3mi $
#
# Top-level Makefile.am for djmount
#
# Copyright (C) 2005 R�mi Turboult <r3mi@users.sourceforge.net>
#

ACLOCAL_AMFLAGS = -I m4 -I gl/m4 -I libupnp/m4
CLEANFILES	= IUpnpErrFile.txt IUpnpInfoFile.txt

SUBDIRS 	= gl
if INTERNAL_TALLOC
    SUBDIRS 	+= talloc 
endif
if INTERNAL_LIBUPNP
    SUBDIRS	+= libupnp
endif
SUBDIRS 	+= djmount

EXTRA_DIST	= search_help.txt


# 
# Note : 'libupnp' has a complete autoconf/automake system, which also handles
# an 'install' target. But we don't want to install libupnp, and we don't want
# to modify its build system either, so we just forward all 'install*' targets
# to './djmount' only.
#
AUTOMAKE_OPTIONS = -Wno-override

# note: do not try to declare all targets together (install install-data ...)
# or automake will not detect the override.
install:
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@
install-data:
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@
install-exec:
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@
install-info:
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@
installdirs:
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@
uninstall:
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@
uninstall-info :
	$(MAKE) $(AM_MAKEFLAGS) -C djmount $@


