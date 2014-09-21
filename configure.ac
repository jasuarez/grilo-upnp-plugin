#
# configure.ac
#
# Author: Juan A. Suarez Romero <jasuarez@igalia.com>
#
# Copyright (C) 2014 Igalia S.L.. All rights reserved.

m4_define([prj_name],    [grilo-upnp-plugin])
m4_define([prj_version], [0.2.1])

AC_INIT([prj_name],
        [prj_version],
        [https://github.com/jasuarez/grilo-upnp-plugin/issues/new],
        [prj_name],
        [https://github.com/jasuarez/grilo-upnp-plugin])

AM_INIT_AUTOMAKE([foreign])

AC_CONFIG_SRCDIR([src])

AC_CONFIG_HEADERS(config.h)

AC_PROG_CC
AC_PROG_INSTALL
AC_DISABLE_STATIC

if test -z "$PKG_CONFIG" ; then
	PKG_CONFIG="pkg-config"
	if test -n "$host" ; then
		PKG_CONFIG=$host-$PKG_CONFIG
	fi
fi

LT_PREREQ([2.2.6])
LT_INIT

AM_PROG_CC_C_O

AC_HEADER_STDC

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# ----------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------

GNOME_COMPILE_WARNINGS([maximum])
CFLAGS+=" ${WARN_CFLAGS} -Wmissing-declarations -std=c99 "

GNOME_MAINTAINER_MODE_DEFINES

# ----------------------------------------------------------
# DEBUG SUPPORT
# ----------------------------------------------------------

AC_ARG_ENABLE(debug,
        AC_HELP_STRING([--enable-debug],
                [include debug symbols (default: no)]),,
        [enable_debug=no])

if test "x$enable_debug" = "xyes"; then
	CFLAGS="$CFLAGS -g3 -O0"
fi

# ----------------------------------------------------------
# DEFINITIONS
# ----------------------------------------------------------

# Plugins directory

GRL_PLUGINS_DIR=`${PKG_CONFIG} --variable=plugindir grilo-0.2`
AC_SUBST(GRL_PLUGINS_DIR)
AC_DEFINE_UNQUOTED(GRL_PLUGINS_DIR, "$GRL_PLUGINS_DIR", [Plugins directory])

# ----------------------------------------------------------
# DEPENDENCIES
# ----------------------------------------------------------

GLIB_MIN_REQ=2.36
GRILO_MIN_REQ=0.2.10
GUPNP_MIN_REQ=0.13
GUPNP_AV_MIN_REQ=0.5

PKG_CHECK_MODULES([DEPS],
        glib-2.0 >= $GLIB_MIN_REQ
        gobject-2.0
        gmodule-2.0
        gssdp-1.0
        gupnp-1.0 >= $GUPNP_MIN_REQ
        gupnp-av-1.0 >= $GUPNP_AV_MIN_REQ
        libxml-2.0
        grilo-0.2 >= $GRILO_MIN_REQ)

GLIB_COMPILE_RESOURCES=`$PKG_CONFIG --variable glib_compile_resources gio-2.0`
AC_SUBST(GLIB_COMPILE_RESOURCES)

UPNP_PLUGIN_ID="grl-upnp"
AC_SUBST(UPNP_PLUGIN_ID)
AC_DEFINE_UNQUOTED([UPNP_PLUGIN_ID], ["$UPNP_PLUGIN_ID"], [UPnP plugin ID])

# ----------------------------------------------------------
# TESTS COVERAGE
# ----------------------------------------------------------

AC_ARG_ENABLE(gcov,
        AC_HELP_STRING([--enable-gcov],
                [enable coverage testing (default: no)]),
        [enable_gcov=$enableval],
        [enable_gcov=no])

if test "x$enable_gcov" = "xyes"; then
   AC_PATH_PROG([enable_gcov], [lcov], [no])
   if test "x$enable_gcov" = "xno"; then
      AC_MSG_ERROR([You need lcov to build with coverage testing])
   elif test "x$GCC" = "xno"; then
      AC_MSG_ERROR([You need to use gcc to build with coverage testing])
   else
      enable_gcov=yes
      CFLAGS="$CFLAGS -g -O0 -fprofile-arcs -ftest-coverage"
      LDFLAGS="$LDFLAGS -lgcov"
   fi
fi

AM_CONDITIONAL([GCOV_ENABLED], [test "x$enable_gcov" = "xyes"])

# ----------------------------------------------------------
# GETTEXT/INTLTOOL
# ----------------------------------------------------------

IT_PROG_INTLTOOL([0.40.0])
GETTEXT_PACKAGE=grl-upnp
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE", [The domain to use with gettext])

# ----------------------------------------------------------
# WORKAROUNDS
# ----------------------------------------------------------

AC_SUBST([abs_top_builddir])
AC_SUBST([builddir])

# ----------------------------------------------------------
# OUTPUT
# ----------------------------------------------------------

AC_CONFIG_FILES([
  Makefile
  po/Makefile.in
  po/Makefile
  src/Makefile
])

AC_OUTPUT
