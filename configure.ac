# -*- Autoconf -*-
# $Id: configure.ac 266 2006-08-27 20:07:58Z r3mi $
#
# Top-level configure.ac file for djmount
#
# Process this file with autoconf to produce a configure script.
#
# (C) Copyright 2005 R�mi Turboult <r3mi@users.sourceforge.net>
#

AC_PREREQ([2.71])
AC_INIT([djmount], [0.71], [r3mi@users.sourceforge.net])

# share auxiliary files with sub-configure in "libupnp"
AC_CONFIG_AUX_DIR(libupnp/config.aux)
AC_CONFIG_MACRO_DIRS([m4],[gl/m4],[libupnp/m4])

AC_CONFIG_SRCDIR(djmount/djfs.c)

AM_INIT_AUTOMAKE([1.9 -Wall std-options gnu subdir-objects])

AC_CONFIG_HEADERS(config.h)

AC_COPYRIGHT([Copyright (C) 2005 R�mi Turboult])
AC_REVISION([$Revision: 266 $])


#
# --enable-FEATURE flags
# ----------------------
#

RT_BOOL_ARG_ENABLE([debug], [yes], [extra debugging code])
if test x"$enable_debug" = xyes; then
	AC_DEFINE([DEBUG],[1],[Define to 1 to compile debug code])
fi


RT_BOOL_ARG_ENABLE([charset], [yes], 
	[charset conversion code and -o iocharset option (assume all UTF-8 when disabled)])
if test x"$enable_charset" = xyes; then
	AC_DEFINE([HAVE_CHARSET],1,
		  [Define to 1 to have charset conversion code])
fi



#
# Checks for programs
#
AC_PROG_CC
gl_EARLY

# build static libraries by default (for bundled libupnp and talloc)
AM_PROG_AR
LT_INIT([disable-shared])

AC_PROG_INSTALL
AC_PROG_MAKE_SET
AC_PROG_LN_S

AC_PATH_PROG(PERL,perl)

# for pkg_config
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig



#
# Default compilation flags
#
if test x"$enable_debug" = xyes; then
	# AC_PROG_CC already sets CFLAGS to "-g -O2" by default
	:
else
	# add optimise for size
	AX_CFLAGS_GCC_OPTION([-Os])
fi
AX_CFLAGS_WARN_ALL

# Arrange for large-file support / large off_t
# Define _FILE_OFFSET_BITS and _LARGE_FILES if necessary
# See also http://unix.freshmeat.net/articles/view/709/
AC_SYS_LARGEFILE


#
# Checks for header files
#
AC_HEADER_DIRENT
AC_CHECK_HEADERS([inttypes.h stddef.h stdint.h stdarg.h])
if test x"$enable_charset" = xyes; then
	AC_CHECK_HEADERS([locale.h langinfo.h])
fi


#
# Checks for typedefs, structures, and compiler characteristics
#
AC_HEADER_STDBOOL
AC_C_CONST
AC_C_INLINE


#
# Checks for library functions
#
AC_CHECK_FUNCS([setxattr mktime])
if test x"$enable_charset" = xyes; then
	AC_CHECK_FUNCS([setlocale])
fi
AC_FUNC_FSEEKO

# Optional GNU extensions
AH_TEMPLATE([_GNU_SOURCE],[Define to 1 to get GNU extensions])
AC_CHECK_FUNCS([open_memstream], [AC_DEFINE([_GNU_SOURCE])])


#
# gnulib 
# ------
# Configuration for imported modules.
# Use "gnulib-tool --import" to update the modules : 
# see http://lists.gnu.org/archive/html/bug-gnulib/2005-08/msg00241.html
gl_INIT



#
# talloc 
# ------
#

AC_MSG_CHECKING([whether to use external talloc])
AC_ARG_WITH([external-talloc], 
	AS_HELP_STRING([--with-external-talloc],
	[use external talloc library (not recommended) @<:@default = use internal bundled library@:>@]))

if test x"$with_external_talloc" = xyes; then
	AC_MSG_RESULT([yes])
	# Find the library. This macro handles the TALLOC_CFLAGS and _LIBS,
	# the --with-talloc-prefix arg, and pkg-config (if any).
	RT_PACKAGE_FIND([talloc], [], [-ltalloc], [talloc >= 4.0], 
	[
/* those include are currently missing from "talloc.h" */
#include <stdio.h>
#include <stdlib.h>
#ifdef HAVE_STDARG_H
#  include <stdarg.h>
#else
#  include <varargs.h>
#endif
#include "talloc.h"
	], 
	[
		/* test for recent talloc functions */
		(void) talloc_get_size (talloc_autofree_context());
	],
	[],[AC_MSG_ERROR([
** Can't find external talloc library (or it is too old). 
** Try to configure again --without-external-talloc (this is the default) to
** use the internal bundled library. 
** Or $TALLOC_MSG_ERRORS
	])])
else
	AC_MSG_RESULT([no (build bundled library)])
	# Configure bundled talloc
	m4_include(talloc/talloc/config.m4)
	AC_SUBST(TALLOC_CFLAGS, '-I$(top_srcdir)/talloc/talloc')
	AC_SUBST(TALLOC_LIBS, '-L$(top_builddir)/talloc -ltalloc')
fi
AM_CONDITIONAL(INTERNAL_TALLOC, test x"$with_external_talloc" != xyes)


#
# readline (option)
# -----------------
# Checks for readline and history compatible libraries
#

VL_LIB_READLINE


#
# iconv & langinfo
# ----------------
#

if test x"$enable_charset" = xyes; then
	# Checks for function in C library or libiconv 
	# (AM macros from "gettext" package)
	AM_ICONV
	AM_LANGINFO_CODESET
	# TBD print warning if no setlocale or nl_langinfo(CODESET) implemented
fi
AM_CONDITIONAL(WANT_ICONV, 
   	  test x"$enable_charset" = xyes && test x"$am_cv_func_iconv" = xyes)


#
# POSIX Threads
# -------------
#
ACX_PTHREAD([],[AC_MSG_ERROR([POSIX threads are required to build this program])])

# We are only building threads programs so we add the pthread flags directly
# to the default compilation variables. This will also allow the tests below
# (fuse, libupnp, ...) to pick these flags.
LIBS="$PTHREAD_LIBS $LIBS"
CFLAGS="$CFLAGS $PTHREAD_CFLAGS"
CC="$PTHREAD_CC"


#
# FUSE 
# ----
#

# Find the library. This macro handles the FUSE_CFLAGS and FUSE_LIBS,
# the --with-fuse-prefix arg, and pkg-config (if any).
RT_PACKAGE_FIND([fuse], [-D_FILE_OFFSET_BITS=64], [-lfuse], [fuse >= 2.2], 
	[ 
/* must request latest API (25) else don't work when using FUSE 2.5 */
#define FUSE_USE_VERSION 25 
#include <fuse.h> 
/* Missing in earlier FUSE versions e.g. 2.2 */
#ifndef FUSE_VERSION
#	define FUSE_VERSION	(FUSE_MAJOR_VERSION * 10 + FUSE_MINOR_VERSION)
#endif
#if FUSE_VERSION < 22
#	error FUSE version is too old
#endif
	],
	[ fuse_destroy(0) ],
	[],[AC_MSG_ERROR([
** Can't find fuse library (or it is too old). 
** $FUSE_MSG_ERRORS
	])])

FUSE_CFLAGS="$FUSE_CFLAGS -DFUSE_USE_VERSION=22"


#
# libupnp 
# -------
#
AC_MSG_CHECKING([whether to use external libupnp])
AC_ARG_WITH([external-libupnp], 
	AS_HELP_STRING([--with-external-libupnp],
	[use external libupnp library (at least 1.3.1) @<:@default = use internal bundled library@:>@]))

if test x"$with_external_libupnp" = xyes; then
	AC_MSG_RESULT([yes])
	# Find the library. This macro handles the LIBUPNP_CFLAGS and _LIBS,
	# the --with-libupnp-prefix arg, and pkg-config (if any).
	RT_PACKAGE_FIND([libupnp], [], [-lupnp -lthreadutil -lixml], 
			[libupnp >= 1.3.1], 
	[
#	include <upnp/ixml.h>
#	include <upnp/upnp.h>
#	include <upnp/upnptools.h>
#if (!defined UPNP_VERSION) || (UPNP_VERSION < 10301)
#	error libupnp version is too old
#endif
	],
	[
		UpnpResolveURL (NULL, NULL, NULL);
		/* test for functions added after libupnp-1.2.1a */
		ixmlRelaxParser (0);
		UpnpSetMaxContentLength (0);
	],
	[],[AC_MSG_ERROR([
** Can't find external libupnp library (or it is too old). 
** Try to configure again --without-external-libupnp (this is the default) to
** use the internal bundled library. 
** Or $LIBUPNP_MSG_ERRORS
	])])
else
	AC_MSG_RESULT([no (build bundled library)])
	# Configure bundled libupnp :
	# compile only necessary subset (static client libraries), 
	# plus debug code if necessary.
	# XXX there is no documented way to pass additional arguments 
	# XXX to sub-configure, so we just hack the internal variable 
	# XXX '$ac_configure_args' ...
	mysave_ac_arg=$ac_configure_args
	ac_configure_args="$ac_configure_args --enable-client --disable-device --disable-shared --enable-debug=$enable_debug"
	AC_CONFIG_SUBDIRS(libupnp)
	# Set compilation variables to the internal libupnp.
	# The includes are a bit tricky to set because the uninstalled 
	# include tree does not match the installed structure <upnp/*.h> :
	# this is handled in djmount/Makefile.am
	AC_SUBST(LIBUPNP_CFLAGS)
	bd='$(top_builddir)/libupnp' # ! shall not expand $top_builddir !
	AC_SUBST(LIBUPNP_LIBS, 
	 ["-L$bd/upnp -lupnp -L$bd/threadutil -lthreadutil -L$bd/ixml -lixml"])
	# Set specific libupnp debug flag (not provided by bundled library,
	# but provided by external libupnp version >= 1.3)
	if test x"$enable_debug" = xyes; then
		AC_DEFINE([UPNP_HAVE_DEBUG],1,
			  [Define to 1 if libupnp debug code enabled])
	fi
fi
AM_CONDITIONAL(INTERNAL_LIBUPNP, test x"$with_external_libupnp" != xyes)



#
# Output Makefiles
#

AC_CONFIG_FILES([Makefile
		 gl/Makefile
                 djmount/Makefile
                 ])

if test x"$with_external_talloc" != xyes; then
	AC_CONFIG_FILES([talloc/Makefile])
fi

AC_OUTPUT

