#
# Makefile.am
#
# Author: Iago Toral Quiroga <itoral@igalia.com>
#
# Copyright (C) 2010, 2011 Igalia S.L. All rights reserved.

include $(top_srcdir)/gtester.mk

ext_LTLIBRARIES	= libgrlupnp.la

libgrlupnp_la_CFLAGS =	\
	$(DEPS_CFLAGS)	\
	-DG_LOG_DOMAIN=\"GrlUpnp\" \
	-DLOCALEDIR=\"$(localedir)\"

libgrlupnp_la_LIBADD =	\
	$(DEPS_LIBS)

libgrlupnp_la_LDFLAGS = \
	-no-undefined   \
	-module		\
	-avoid-version

libgrlupnp_la_SOURCES = \
	grl-upnp.c		\
	grl-upnp.h		\
	grl-upnp-utils.c	\
	grl-upnp-utils.h

extdir			= $(GRL_PLUGINS_DIR)

MAINTAINERCLEANFILES =	\
	*.in		\
	*~

DISTCLEANFILES = $(MAINTAINERCLEANFILES)
