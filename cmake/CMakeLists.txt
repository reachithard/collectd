cmake_minimum_required(VERSION 3.12)

project(Monitor)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_STANDARD 99)

SET(CMAKE_POSITION_INDEPENDENT_CODE ON)

message(STATUS "Build type: ${CMAKE_BUILD_TYPE} version ${CMAKE_C_COMPILER} ${CMAKE_CXX_COMPILER}")
# ./collectd -C /root/workspace/collectd/src/collectd.conf
# TODO config.h
# TODO support the feature

# set BASE_DIR to the top dir
set(BASE_DIR ${CMAKE_SOURCE_DIR}/../)

# features
include(features/collectd_make_feature.cmake)
include(features/environment.cmake)
include(utils/intf.cmake)
include(utils/plugins.cmake)

message("COMMON_LIBS:${COMMON_LIBS}")

# conf file generate
configure_file(${BASE_DIR}/cmake/config.h.in ${CMAKE_CURRENT_SOURCE_DIR}/config.h)
configure_file(${BASE_DIR}/cmake/collectd.conf.in ${CMAKE_CURRENT_SOURCE_DIR}/collectd.conf)

# object end
ADD_LIBRARY(COMMON_INTER INTERFACE)
target_link_libraries(COMMON_INTER   INTERFACE
                                    pthread
                                    $<$<CONFIG:WIN32>:ws2_32>
                                    $<$<CONFIG:BUILD_WITH_GNULIB>:gnu>
                                    $<$<CONFIG:BUILD_WITH_CAPABILITY>:cap>
                                    $<$<CONFIG:BUILD_WITH_LIBRT>:rt>
                                    $<$<CONFIG:BUILD_WITH_LIBPOSIX4>:posix4>
                                    $<$<CONFIG:BUILD_WITH_LIBSOCKET>:socket>
                                    $<$<CONFIG:BUILD_WITH_LIBKSTAT>:devinfo>
                                    )

# object begin
add_library(avltree OBJECT ${BASE_DIR}/src/utils/avltree/avltree.c)
target_link_libraries(avltree PRIVATE intf)

add_library(common OBJECT ${BASE_DIR}/src/utils/common/common.c)
target_link_libraries(common PRIVATE COMMON_INTER intf)

add_library(heap OBJECT ${BASE_DIR}/src/utils/heap/heap.c)
target_link_libraries(heap PRIVATE intf)

add_library(ignorelist OBJECT ${BASE_DIR}/src/utils/ignorelist/ignorelist.c)
target_link_libraries(ignorelist PRIVATE intf)

add_library(llist OBJECT ${BASE_DIR}/src/daemon/utils_llist.c)
target_link_libraries(llist PRIVATE intf)

add_library(metadata OBJECT ${BASE_DIR}/src/utils/metadata/meta_data.c)
target_link_libraries(metadata PRIVATE intf)

add_library(plugin_mock OBJECT  ${BASE_DIR}/src/daemon/plugin_mock.c 
                                ${BASE_DIR}/src/daemon/utils_cache_mock.c
                                ${BASE_DIR}/src/daemon/utils_complain.c
                                ${BASE_DIR}/src/daemon/utils_complain.h
                                ${BASE_DIR}/src/daemon/utils_time.c
                                ${BASE_DIR}/src/daemon/utils_time.h)
target_link_libraries(plugin_mock PRIVATE common ignorelist COMMON_INTER)
target_link_libraries(plugin_mock PRIVATE intf)

add_library(format_influxdb OBJECT ${BASE_DIR}/src/utils/format_influxdb/format_influxdb.c)
target_link_libraries(format_influxdb PRIVATE intf)

add_library(format_graphite OBJECT ${BASE_DIR}/src/utils/format_graphite/format_graphite.c)
target_link_libraries(format_graphite PRIVATE intf)

add_library(format_json OBJECT ${BASE_DIR}/src/utils/format_json/format_json.c)
target_link_libraries(format_json PRIVATE intf)
if(BUILD_WITH_LIBYAJL)
# todo

endif(BUILD_WITH_LIBYAJL)

if(BUILD_PLUGIN_CEPH)
# todo

endif(BUILD_PLUGIN_CEPH)

add_library(latency OBJECT 	${BASE_DIR}/src/utils/latency/latency.c
							${BASE_DIR}/src/utils/latency/latency.h
							${BASE_DIR}/src/utils/latency/latency_config.c
							${BASE_DIR}/src/utils/latency/latency_config.h)
target_link_libraries(latency PRIVATE intf common m)

add_library(cmds OBJECT ${BASE_DIR}/src/utils/cmds/cmds.c
						${BASE_DIR}/src/utils/cmds/cmds.h
						${BASE_DIR}/src/utils/cmds/flush.c
						${BASE_DIR}/src/utils/cmds/flush.h
						${BASE_DIR}/src/utils/cmds/getthreshold.c
						${BASE_DIR}/src/utils/cmds/getthreshold.h
						${BASE_DIR}/src/utils/cmds/getval.c
						${BASE_DIR}/src/utils/cmds/getval.h
						${BASE_DIR}/src/utils/cmds/listval.c
						${BASE_DIR}/src/utils/cmds/listval.h
						${BASE_DIR}/src/utils/cmds/putnotif.c
						${BASE_DIR}/src/utils/cmds/putnotif.h
						${BASE_DIR}/src/utils/cmds/putval.c
						${BASE_DIR}/src/utils/cmds/putval.h
						${BASE_DIR}/src/utils/cmds/parse_option.c
						${BASE_DIR}/src/utils/cmds/parse_option.h)
target_link_libraries(cmds PRIVATE intf common metadata m)

add_library(lookup OBJECT 	${BASE_DIR}/src/utils/lookup/vl_lookup.c
							${BASE_DIR}/src/utils/lookup/vl_lookup.h)
target_link_libraries(lookup PRIVATE intf avltree)

add_library(mount OBJECT 	${BASE_DIR}/src/utils/mount/mount.c
							${BASE_DIR}/src/utils/mount/mount.h)
target_link_libraries(mount PRIVATE intf)

# plugin begin

# todo libcollectdclient
# todo oauth etc
# todo format_stackdriver

# todo aggregation
# todo amqp
# todo amqp1
# todo apache
# todo apcpus
# todo apple_sensors
# todo aquaero
# todo ascent
# todo barometer
# todo battery

# todo bind
# todo buddyinfo
# todo capabilities
# todo ceph
# todo cgroups
# todo chrony
# todo check_uptime
# todo connectivity
# todo conntrack
# todo contextswitch

# todo cpu
set(BUILD_PLUGIN_CPU true)
build_plugin(cpu ${BASE_DIR}/src/cpu.c)
# todo cpufreq
# todo cpusleep
# todo csv
set(BUILD_PLUGIN_CSV true)
build_plugin(csv ${BASE_DIR}/src/csv.c)
# todo curl
# todo curl_json
# todo curl_xml
# todo dbi
# todo dcpmm
# todo df

# todo disk
# todo dns
# todo dpdkevents
# todo dpdkstat
# todo dpdk_telemetry
# todo drbd
# todo email
# todo entropy
# todo exec
# todo ethstat

# todo fhcount
# todo filecount
# todo fscache
# todo gmond
# todo gps
# todo gpu_nvidia
# todo grpc
# todo hddtemp
# todo hugepages
# todo infiniband

# todo intel_pmu
# todo intel_rdt
# todo interface
set(BUILD_PLUGIN_INTERFACE true)
build_plugin(interface ${BASE_DIR}/src/interface.c)
target_link_libraries(interface PRIVATE ignorelist)
# todo ipc
# todo iptables
# todo ipmi
# todo ipstats
# todo ipvs
# todo irq
# todo java

# todo load
set(BUILD_PLUGIN_LOAD true)
build_plugin(load ${BASE_DIR}/src/load.c)
# todo logfile
set(BUILD_PLUGIN_LOGFILE true)
build_plugin(logfile ${BASE_DIR}/src/logfile.c)
# todo logparser
# todo log_logstash
# todo lpar
# todo lua
# todo madwifi
# todo match_empty_counter
# todo match_hashed
# todo match_regex

# todo match_timediff
# todo match_value
# todo mbmon
# todo mcelog
# todo md
# todo mdevents
# todo memcachec
# todo memcached
# todo memory
set(BUILD_PLUGIN_MEMORY true)
build_plugin(memory ${BASE_DIR}/src/memory.c)
# todo mic

# todo modbus
# todo mqtt
# todo mmc
# todo multimeter
# todo mysql
# todo netapp
# todo netlink
# todo network
set(BUILD_PLUGIN_NETWORK true)
build_plugin(network 	${BASE_DIR}/src/network.c
						${BASE_DIR}/src/network.h
						${BASE_DIR}/src/utils_fbhash.c
						${BASE_DIR}/src/utils_fbhash.h)
if (BUILD_WITH_LIBSOCKET)
	target_link_libraries(network PRIVATE socket)
endif(BUILD_WITH_LIBSOCKET)
if (BUILD_WITH_LIBGCRYPT)
	# todo
endif(BUILD_WITH_LIBGCRYPT)
# todo nfs
# todo nginx

# todo notify_desktop
# todo notify_email
# todo notify_nagios
# todo ntpd
# todo numa
# todo nut
# todo olsrd
# todo onewire
# todo openldap
# todo openvpn

# todo oracle
# todo ovs_events
# todo ovs_stats
# todo pcie_errors
# todo perl
# todo pf
# todo pinba
# todo ping
# todo postgresql
# todo powerdns

# todo python
# todo libtaskstats noinst_
# todo processes
# todo procevent
# todo protocols
# todo ras
# todo redfish
# todo redis
# todo routeros
# todo rrdcached
# todo rrdtool

# todo sensors
# todo serial
# todo sigrok
# todo slurm
# todo smart
# todo snmp
# todo snmp_agent
# todo statsd
# todo swap
# todo synproxy

# todo sysevent
# todo syslog
set(BUILD_PLUGIN_SYSLOG true)
build_plugin(syslog ${BASE_DIR}/src/syslog.c)
# todo table
# todo tail
# todo tail_csv
# todo tape
# todo target_notification
# todo target_replace
# todo target_scale
# todo target_set

# todo target_v5upgrade
# todo tcpconns
# todo teamspeak2
# todo ted
# todo thermal
# todo threshold
# todo tokyotyrant
# todo turbostat
# todo ubi
# todo unixsock

# todo uptime
set(BUILD_PLUGIN_UPTIME true)
build_plugin(uptime ${BASE_DIR}/src/uptime.c)
# todo users
# todo uuid
# todo varnish
# todo virt
# todo vmem
# todo vserver
# todo wireless
# todo write_graphite
# todo write_http

# todo write_influxdb_udp
# todo write_kafka
# todo write_log
# todo write_mongodb
# todo write_prometheus
# todo write_redis
# todo write_riemann
# todo write_sensu
# todo write_stackdriver
# todo write_syslog

# todo write_tsdb
# todo xencpu
# todo xmms
# todo zfs_arc
# todo zookeeper
# todo zone
# todo build java

# plugin end

find_package(BISON)
find_package(FLEX)

BISON_TARGET(OCONFIG_PARSER ${BASE_DIR}/src/liboconfig/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
FLEX_TARGET(OCONFIG_SCANNER ${BASE_DIR}/src/liboconfig/scanner.l  ${CMAKE_CURRENT_BINARY_DIR}/scanner.c)
ADD_FLEX_BISON_DEPENDENCY(OCONFIG_SCANNER OCONFIG_PARSER)
message("BISON_OCONFIG_PARSER_OUTPUTS:${BISON_OCONFIG_PARSER_OUTPUTS} FLEX_OCONFIG_SCANNER_OUTPUTS:${FLEX_OCONFIG_SCANNER_OUTPUTS} ${FLEX_LIBRARIES}")
add_library(oconfig OBJECT
    ${BASE_DIR}/src/liboconfig/oconfig.c 
    ${BISON_OCONFIG_PARSER_OUTPUTS}
    ${FLEX_OCONFIG_SCANNER_OUTPUTS}
 )
 target_link_libraries(oconfig PRIVATE ${FLEX_LIBRARIES} intf)

set(collectd_SOURCES
	${BASE_DIR}/src/daemon/cmd.h
	${BASE_DIR}/src/daemon/collectd.c
	${BASE_DIR}/src/daemon/collectd.h
	${BASE_DIR}/src/daemon/configfile.c
	${BASE_DIR}/src/daemon/configfile.h
	${BASE_DIR}/src/daemon/filter_chain.c
	${BASE_DIR}/src/daemon/filter_chain.h
	${BASE_DIR}/src/daemon/globals.c
	${BASE_DIR}/src/daemon/globals.h
	${BASE_DIR}/src/utils/metadata/meta_data.c
	${BASE_DIR}/src/utils/metadata/meta_data.h
	${BASE_DIR}/src/daemon/plugin.c
	${BASE_DIR}/src/daemon/plugin.h
	${BASE_DIR}/src/daemon/utils_cache.c
	${BASE_DIR}/src/daemon/utils_cache.h
	${BASE_DIR}/src/daemon/utils_complain.c
	${BASE_DIR}/src/daemon/utils_complain.h
	${BASE_DIR}/src/daemon/utils_random.c
	${BASE_DIR}/src/daemon/utils_random.h
	${BASE_DIR}/src/daemon/utils_subst.c
	${BASE_DIR}/src/daemon/utils_subst.h
	${BASE_DIR}/src/daemon/utils_time.c
	${BASE_DIR}/src/daemon/utils_time.h
	${BASE_DIR}/src/daemon/types_list.c
	${BASE_DIR}/src/daemon/types_list.h
	${BASE_DIR}/src/daemon/utils_threshold.c
	${BASE_DIR}/src/daemon/utils_threshold.h)

add_executable(collectd WIN32 MACOSX_BUNDLE)
target_link_libraries(collectd PRIVATE avltree common heap llist oconfig m dl COMMON_INTER intf)
target_sources(collectd PRIVATE ${collectd_SOURCES})
if (WIN32)
target_sources(collectd PRIVATE ${BASE_DIR}/src/daemon/cmd_windows.c)
target_link_options(collectd -ldl -Wl,--out-implib,libcollectd.a)
else(WIN32)
target_sources(collectd PRIVATE ${BASE_DIR}/src/daemon/cmd.c)
endif(WIN32)
target_link_options(collectd PRIVATE "-Wl,--export-dynamic") # must add this ldflag, otherwise will undefined reference
