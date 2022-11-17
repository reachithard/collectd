# to adapter the collectd make process, so set some var
set(dist_man_MANS 
    ${BASE_DIR}/src/collectd.1
    ${BASE_DIR}/src/collectd.conf.5
    ${BASE_DIR}/src/collectd-email.5
    ${BASE_DIR}/src/collectd-exec.5
    ${BASE_DIR}/src/collectdctl.1
    ${BASE_DIR}/src/collectd-java.5
    ${BASE_DIR}/src/collectd-lua.5
    ${BASE_DIR}/src/collectdmon.1
    ${BASE_DIR}/src/collectd-nagios.1
    ${BASE_DIR}/src/collectd-perl.5
    ${BASE_DIR}/src/collectd-python.5
    ${BASE_DIR}/src/collectd-snmp.5
    ${BASE_DIR}/src/collectd-tg.1
    ${BASE_DIR}/src/collectd-threshold.5
    ${BASE_DIR}/src/collectd-unixsock.5
    ${BASE_DIR}/src/types.db.5)

set(BUILT_SOURCES
	${BASE_DIR}/src/libcollectdclient/collectd/lcc_features.h
	${BASE_DIR}/src/liboconfig/parser.h
    ${dist_man_MANS})


set(CLEANFILES
    ${BASE_DIR}/.perl-directory-stamp
    ${BASE_DIR}/bindings/buildperl/Collectd.pm
    ${BASE_DIR}/bindings/buildperl/Collectd/Plugins/OpenVZ.pm
    ${BASE_DIR}/bindings/buildperl/Collectd/Unixsock.pm
    ${BASE_DIR}/bindings/buildperl/Makefile.PL
    ${BASE_DIR}/collectd-api.jar
    ${BASE_DIR}/collectd.grpc.pb.cc
    ${BASE_DIR}/collectd.grpc.pb.h
    ${BASE_DIR}/collectd.pb.cc
    ${BASE_DIR}/collectd.pb.h
    ${BASE_DIR}/generic-jmx.jar
    ${BASE_DIR}/org/collectd/api/*.class
    ${BASE_DIR}/org/collectd/java/*.class
    ${BASE_DIR}/prometheus.pb-c.c
    ${BASE_DIR}/prometheus.pb-c.h
    ${BASE_DIR}/src/pinba.pb-c.c
    ${BASE_DIR}/src/pinba.pb-c.h
    ${BASE_DIR}/types.grpc.pb.cc
    ${BASE_DIR}/types.grpc.pb.h
    ${BASE_DIR}/types.pb.cc
    ${BASE_DIR}/types.pb.h)

set(EXTRA_DIST
    ${BASE_DIR}/bindings/perl/Makefile.PL
    ${BASE_DIR}/bindings/perl/lib/Collectd.pm
    ${BASE_DIR}/bindings/perl/lib/Collectd/Plugins/Monitorus.pm
    ${BASE_DIR}/bindings/perl/lib/Collectd/Plugins/OpenVZ.pm
    ${BASE_DIR}/bindings/perl/lib/Collectd/Unixsock.pm
    ${BASE_DIR}/bindings/perl/uninstall_mod.pl
    ${BASE_DIR}/contrib
    ${BASE_DIR}/proto/collectd.proto
    ${BASE_DIR}/proto/prometheus.proto
    ${BASE_DIR}/proto/types.proto
    ${BASE_DIR}/src/collectd-email.pod
    ${BASE_DIR}/src/collectd-exec.pod
    ${BASE_DIR}/src/collectd-java.pod 
    ${BASE_DIR}/src/collectd-lua.pod
    ${BASE_DIR}/src/collectd-nagios.pod
    ${BASE_DIR}/src/collectd-perl.pod
    ${BASE_DIR}/src/collectd-python.pod
    ${BASE_DIR}/src/collectd-snmp.pod
    ${BASE_DIR}/src/collectd-tg.pod
    ${BASE_DIR}/src/collectd-threshold.pod
    ${BASE_DIR}/src/collectd-unixsock.pod
    ${BASE_DIR}/src/collectd.conf.pod
    ${BASE_DIR}/src/collectd.pod
    ${BASE_DIR}/src/collectdctl.pod
    ${BASE_DIR}/src/collectdmon.pod
    ${BASE_DIR}/src/pinba.proto
    ${BASE_DIR}/src/postgresql_default.conf
    ${BASE_DIR}/src/types.db
    ${BASE_DIR}/src/types.db.pod
    ${BASE_DIR}/src/valgrind.FreeBSD.suppress
    ${BASE_DIR}/src/valgrind.suppress
    ${BASE_DIR}/testwrapper.sh 
    ${BASE_DIR}/version-gen.sh)

set(nodist_pkgconfig_DATA 
    ${BASE_DIR}/src/libcollectdclient/libcollectdclient.pc)

set(pkginclude_HEADERS
    ${BASE_DIR}/src/libcollectdclient/collectd/client.h
    ${BASE_DIR}/src/libcollectdclient/collectd/lcc_features.h
    ${BASE_DIR}/src/libcollectdclient/collectd/network_buffer.h
    ${BASE_DIR}/src/libcollectdclient/collectd/network.h
    ${BASE_DIR}/src/libcollectdclient/collectd/network_parse.h
    ${BASE_DIR}/src/libcollectdclient/collectd/server.h
    ${BASE_DIR}/src/libcollectdclient/collectd/types.h)

# TODO
# lib_LTLIBRARIES = libcollectdclient.la

# if BUILD_WIN32
# # TODO: Build all executables on Windows as well.
# sbin_PROGRAMS = \
#         collectd

# bin_PROGRAMS =
# else
# sbin_PROGRAMS = \
# 	collectd \
# 	collectdmon


# bin_PROGRAMS = \
# 	collectd-nagios \
# 	collectd-tg \
# 	collectdctl
# endif # BUILD_WIN32

# noinst_LTLIBRARIES = \
# 	libavltree.la \
# 	libcmds.la \
# 	libcommon.la \
# 	libformat_influxdb.la \
# 	libformat_graphite.la \
# 	libformat_json.la \
# 	libheap.la \
# 	libignorelist.la \
# 	liblatency.la \
# 	libllist.la \
# 	liblookup.la \
# 	libmetadata.la \
# 	libmount.la \
# 	liboconfig.la


# check_LTLIBRARIES = \
# 	libplugin_mock.la


# check_PROGRAMS = \
# 	test_common \
# 	test_format_graphite \
# 	test_meta_data \
# 	test_utils_avltree \
# 	test_utils_cmds \
# 	test_utils_heap \
# 	test_utils_latency \
# 	test_utils_message_parser \
# 	test_utils_mount \
# 	test_utils_subst \
# 	test_utils_time \
# 	test_utils_vl_lookup \
# 	test_libcollectd_network_parse \
# 	test_utils_config_cores

# TESTS = $(check_PROGRAMS)

# LOG_COMPILER = env VALGRIND="@VALGRIND@" $(abs_srcdir)/testwrapper.sh

# jardir = $(cpkgdatadir)/java

# pkglib_LTLIBRARIES =

# PLUGIN_LDFLAGS = \
# 	-module \
# 	-avoid-version \
# 	-export-symbols-regex '\<module_register\>'
# if BUILD_WIN32
# PLUGIN_LDFLAGS += -shared -no-undefined -lcollectd -L.
# endif

set(AM_CPPFLAGS
    -I${BASE_DIR}/src 
    -I${BASE_DIR}/src/daemon
    -DPREFIX=""
    -DCONFIGFILE=""
    -DLOCALSTATEDIR=""
    -DPKGLOCALSTATEDIR=""
    -DPLUGINDIR=""
    -DPKGDATADIR=""
    $<$<WIN32>:-DNOGDI>
    )


# AM_CPPFLAGS = \
# 	-I$(top_srcdir)/src -I$(top_srcdir)/src/daemon \
# 	-DPREFIX='"${prefix}"' \
# 	-DCONFIGFILE='"${sysconfdir}/${PACKAGE_NAME}.conf"' \
# 	-DLOCALSTATEDIR='"${localstatedir}"' \
# 	-DPKGLOCALSTATEDIR='"${cpkglocalstatedir}"' \
# 	-DPLUGINDIR='"${cpkglibdir}"' \
# 	-DPKGDATADIR='"${cpkgdatadir}"'
# if BUILD_WIN32
# AM_CPPFLAGS += -DNOGDI
# endif

# COMMON_DEPS =
# if BUILD_WIN32
# COMMON_DEPS += collectd.exe
# endif

# # Link to these libraries..
# COMMON_LIBS = $(PTHREAD_LIBS)
# if BUILD_WIN32
# COMMON_LIBS += -lws2_32
# endif
# if BUILD_WITH_GNULIB
# COMMON_LIBS += -lgnu
# endif
# if BUILD_WITH_CAPABILITY
# COMMON_LIBS += -lcap
# endif
# if BUILD_WITH_LIBRT
# COMMON_LIBS += -lrt
# endif
# if BUILD_WITH_LIBPOSIX4
# COMMON_LIBS += -lposix4
# endif
# if BUILD_WITH_LIBSOCKET
# COMMON_LIBS += -lsocket
# endif
# if BUILD_WITH_LIBKSTAT
# COMMON_LIBS += -lkstat
# endif
# if BUILD_WITH_LIBDEVINFO
# COMMON_LIBS += -ldevinfo
# endif