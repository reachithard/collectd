cmake_minimum_required(VERSION 3.12)

project(Monitor)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_STANDARD 99)

message(STATUS "Build type: ${CMAKE_BUILD_TYPE} version ${CMAKE_C_COMPILER} ${CMAKE_CXX_COMPILER}")

# TODO config.h
# TODO support the feature

# set BASE_DIR to the top dir
set(BASE_DIR ${CMAKE_SOURCE_DIR}/../)

# features
include(features/collectd_make_feature.cmake)
include(features/environment.cmake)

message("COMMON_LIBS:${COMMON_LIBS}")

# object end
ADD_LIBRARY(COMMON_INTER INTERFACE)
target_link_libraries(COMMON_INTER   INTERFACE
                                    pthead
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

add_library(common OBJECT ${BASE_DIR}/src/utils/common/common.c)
target_link_libraries(common PRIVATE COMMON_INTER)

add_library(heap OBJECT ${BASE_DIR}/src/utils/heap/heap.c)

add_library(ignorelist OBJECT ${BASE_DIR}/src/utils/ignorelist/ignorelist.c)

add_library(llist OBJECT ${BASE_DIR}/src/daemon/utils_llist.c)

add_library(metadata OBJECT ${BASE_DIR}/src/utils/metadata/meta_data.c)

add_library(plugin_mock OBJECT  ${BASE_DIR}/src/daemon/plugin_mock.c 
                                ${BASE_DIR}/src/daemon/utils_cache_mock.c
                                ${BASE_DIR}/src/daemon/utils_complain.c
                                ${BASE_DIR}/src/daemon/utils_complain.h
                                ${BASE_DIR}/src/daemon/utils_time.c
                                ${BASE_DIR}/src/daemon/utils_time.h)
target_link_libraries(plugin_mock PRIVATE common ignorelist COMMON_INTER)

add_library(format_influxdb OBJECT ${BASE_DIR}/src/utils/format_influxdb/format_influxdb.c)

add_library(format_graphite OBJECT ${BASE_DIR}/src/utils/format_graphite/format_graphite.c)

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
 target_link_libraries(oconfig PRIVATE ${FLEX_LIBRARIES})

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
target_link_libraries(collectd PRIVATE avltree comm heap llist oconfig m dl COMMON_INTER)
if (WIN32)
target_sources(collectd PRIVATE ${BASE_DIR}/src/daemon/cmd_windows.c)
target_link_options(collectd -ldl -Wl,--out-implib,libcollectd.a)
else(WIN32)
target_sources(collectd PRIVATE ${BASE_DIR}/src/daemon/cmd.c)
endif(WIN32)
