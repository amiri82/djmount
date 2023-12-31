dnl
dnl @synopsis RT_PACKAGE_FIND(package-name, [MYCFLAGS], [MYLIBS], 
dnl                           [pkg-config-spec], [try-include], [try-link], 
dnl		              [action-if-found], [action-if-not-found])
dnl
dnl This macro will check for the existence of a package library(ies).
dnl It does this by checking for the header files and the library objects
dnl files. A --with-<package-name>-prefix=DIR option is supported 
dnl as well, to search in DIR/include and DIR/lib.
dnl The macro also tries to locate the package using the pkg-config tool.
dnl
dnl The following shell variables are used to search for the libraries. 
dnl They are also augmented by the macro, and output with AC_SUBST: 
dnl 
dnl	<PACKAGE-NAME>_CFLAGS
dnl 	<PACKAGE-NAME>_LIBS
dnl
dnl You can use them like this in Makefile.am (for package "foo") :
dnl
dnl	AM_CFLAGS     = $(FOO_CFLAGS)
dnl	program_LDADD = $(FOO_LIBS)
dnl
dnl Additionally, the C preprocessor symbol HAVE_<PACKAGE-NAME> will be
dnl defined with AC_DEFINE if the package is available. 
dnl
dnl
dnl The _CFLAGS and _LIBS variables are computed as follow, before trying 
dnl to link the library(ies) :
dnl 1) use current value of shell variables
dnl 2) if the --with-<package-name>-prefix=DIR option is given, 
dnl    these directories are added to the variables, along with 
dnl    the MYCFLAGS and MYLIBS arguments.
dnl 3) if the shell variables are still empty, the macro tries to locate 
dnl    the package using the pkg-config tool.
dnl 4) if all else fails, and the shell variables are still empty, the macro
dnl    uses directly the MYCFLAGS and MYLIBS arguments.
dnl 
dnl If the librariy(ies) can't be linked, the shell variable 
dnl <PACKAGE-NAME>_MSG_ERRORS will contain an error message.
dnl
dnl
dnl Example:
dnl	RT_PACKAGE_FIND([foo],[-DFOO_STUFF],[-lfoo],[foo >= 1.2],
dnl			[#include "foo.h"],[foo_new()],
dnl			[],[AC_MSG_ERROR($FOO_MSG_ERROR)])
dnl
dnl	./configure --with-foo-prefix=/opt/local
dnl
dnl
dnl @version $Id$
dnl @author R�mi Turboult <r3mi@users.sourceforge.net>
dnl
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.
dnl

AC_DEFUN([RT_PACKAGE_FIND], [
dnl
m4_pushdef([Name],AS_TR_SH($1))dnl
m4_pushdef([NAME],AS_TR_CPP($1))dnl
dnl
AS_VAR_PUSHDEF([link_ok], [rt_package_find_[]Name[]_link_ok])dnl
AS_VAR_PUSHDEF([pkg_config_ok], [rt_package_find_[]Name[]_pkg_config_ok])dnl
dnl
AH_TEMPLATE([HAVE_]NAME, [Define if $1 is available])

#
# 1) Add any prefix lib or include directory
#

AC_ARG_WITH(Name[-prefix], 
	AS_HELP_STRING([--with-]Name[-prefix=DIR],
	[search for $1 in DIR/include and DIR/lib]))

if test x"$with_[]Name[]_prefix" != x ; then
	NAME[]_CFLAGS="$NAME[]_CFLAGS -I$with_[]Name[]_prefix/include $2"
	NAME[]_LIBS="$NAME[]_LIBS -L$with_[]Name[]_prefix/lib $3"
fi

#
# 2) If flags empty, try pkg-config.
# 3) If failure, try default values
#

if test -z "$NAME[]_CFLAGS" && test -z "$NAME[]_LIBS"; then
     	m4_ifvaln([$4], [PKG_CHECK_MODULES(NAME,$4, 
		[ 	# if found
	  		pkg_config_ok=yes
		],	 
		[ 	# if not found
		  	AC_MSG_RESULT($NAME[]_PKG_ERRORS)
		])
	])
	if test x"$pkg_config_ok" != xyes; then
		  NAME[]_CFLAGS="$2"
		  NAME[]_LIBS="$3"
	fi	
fi	

#
# Print values (if not already done by pkg-config)
#

if test x"$pkg_config_ok" != xyes; then
	AC_MSG_CHECKING(NAME[_CFLAGS])
	AC_MSG_RESULT($NAME[]_CFLAGS)
	AC_MSG_CHECKING(NAME[_LIBS])
	AC_MSG_RESULT($NAME[]_LIBS)
fi

#
# Now, try linking with the library(ies)
#

AC_MSG_CHECKING([whether NAME[_CFLAGS] and NAME[_LIBS] work])

AC_LANG_PUSH(C)
ac_save_CFLAGS="$CFLAGS"
ac_save_LIBS="$LIBS"
CFLAGS="$CFLAGS $NAME[]_CFLAGS"
LIBS="$LIBS $NAME[]_LIBS"
AC_LINK_IFELSE([AC_LANG_PROGRAM([[$5]],[[$6]])],[ link_ok=yes ], [link_ok=no ])
CFLAGS="$ac_save_CFLAGS"
LIBS="$ac_save_LIBS"
AC_LANG_POP(C)

AC_MSG_RESULT($link_ok)
if test x"$link_ok" = xyes ; then
	AC_DEFINE([HAVE_]NAME,1)
     	m4_ifvaln([$7], [$7], [:])dnl
else
	NAME[]_CFLAGS=""
	NAME[]_LIBS=""
	NAME[]_MSG_ERRORS="try to configure again 
 - using --with-[]Name[]-prefix=DIR if the package is installed in 
   non-standard location DIR/include and DIR/lib,
 - or set the NAME[]_CFLAGS and/or NAME[]_LIBS environment variables 
   before calling 'configure',
 - or add the directory containing '$1.pc' to the PKG_CONFIG_PATH 
   environment variable for pkg-config."
     	m4_ifvaln([$8], [$8])dnl
fi

# 
# Now just export out symbols
#
dnl We declare the variables as "precious", instead of simply AC_SUBST,
dnl in order to add some documentation, and to detect some inconsistencies 
dnl when using cache.
AC_ARG_VAR(NAME[_CFLAGS], [set compiler flags for $1])
AC_ARG_VAR(NAME[_LIBS], [set linker flags and libraries for $1])

AS_VAR_POPDEF([pkg_config_ok])dnl
AS_VAR_POPDEF([link_ok])dnl

m4_popdef([Name])dnl
m4_popdef([NAME])dnl
                   
])


