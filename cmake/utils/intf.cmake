ADD_LIBRARY(intf INTERFACE)
TARGET_INCLUDE_DIRECTORIES(intf INTERFACE 
								${BASE_DIR}
                                ${BASE_DIR}/src
								${BASE_DIR}/src/daemon
                                ${BASE_DIR}/src/libcollectdclient
                                ${BASE_DIR}/src/libcollectdclient/collectd
								${BASE_DIR}/src/liboconfig
								${BASE_DIR}/src/utils)

TARGET_COMPILE_OPTIONS(intf INTERFACE 
						-Wall
						$<$<CONFIG:RELEASE>:-O3>
						$<$<CONFIG:DEBUG>:-O0 -g>
)

TARGET_COMPILE_DEFINITIONS(intf INTERFACE 
    -DHAVE_CONFIG_H
)

TARGET_LINK_OPTIONS(intf INTERFACE 
)

TARGET_LINK_DIRECTORIES(intf INTERFACE 
)

TARGET_LINK_LIBRARIES(intf INTERFACE)