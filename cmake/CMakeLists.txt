cmake_minimum_required(VERSION 3.12)

project(Monitor)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_STANDARD 99)

message(STATUS "Build type: ${CMAKE_BUILD_TYPE} version ${CMAKE_C_COMPILER} ${CMAKE_CXX_COMPILER}")
message(STATUS "$<$<CONFIG:WIN32>:"hello">$<$<CONFIG:Linux>:"world">")

# TODO config.h
# TODO support the feature

# set BASE_DIR to the top dir
set(BASE_DIR ${CMAKE_SOURCE_DIR}/../)

# features
include(features/collectd_make_feature.cmake)
include(features/environment.cmake)

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
if (WIN32)
target_sources(collectd PRIVATE ${BASE_DIR}/src/daemon/cmd_windows.c)
target_link_options(collectd -ldl -Wl,--out-implib,libcollectd.a)
else(WIN32)
target_sources(collectd PRIVATE ${BASE_DIR}/src/daemon/cmd.c)
endif(WIN32)

# if BUILD_FEATURE_DAEMON
# collectd_CPPFLAGS += -DPIDFILE='"${localstatedir}/run/${PACKAGE_NAME}.pid"'
# endif

# # The daemon needs to call sg_init, so we need to link it against libstatgrab,
# # too. -octo
# if BUILD_WITH_LIBSTATGRAB
# collectd_CFLAGS += $(BUILD_WITH_LIBSTATGRAB_CFLAGS)
# collectd_LDADD += $(BUILD_WITH_LIBSTATGRAB_LDFLAGS)
# endif

add_executable(collectdmon ${BASE_DIR}/src/collectdmon.c)


