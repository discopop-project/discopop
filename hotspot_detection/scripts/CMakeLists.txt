# copy scripts to build folder
message(STATUS "Copying scripts to: ${CMAKE_CURRENT_BINARY_DIR}")
configure_file(runHotspotDetection runHotspotDetection COPYONLY)
configure_file(CC_wrapper.sh CC_wrapper.sh COPYONLY)
configure_file(CXX_wrapper.sh CXX_wrapper.sh COPYONLY)
configure_file(CMAKE_wrapper.sh CMAKE_wrapper.sh COPYONLY)
configure_file(LINKER_wrapper.sh LINKER_wrapper.sh COPYONLY)

# create symlinks to files
set(DPHPD_LOCAL_BIN_DIR "$ENV{HOME}/.local/bin")
if(EXISTS ${DPHPD_LOCAL_BIN_DIR})
    message(STATUS "Creating symlink ${DPHPD_LOCAL_BIN_DIR}/discopop_hotspot_cc to ${CMAKE_CURRENT_BINARY_DIR}/CC_wrapper.sh")
    execute_process(COMMAND ln -sf ${CMAKE_CURRENT_BINARY_DIR}/CC_wrapper.sh ${DPHPD_LOCAL_BIN_DIR}/discopop_hotspot_cc)
    
    message(STATUS "Creating symlink ${DPHPD_LOCAL_BIN_DIR}/discopop_hotspot_cxx to ${CMAKE_CURRENT_BINARY_DIR}/CXX_wrapper.sh")
    execute_process(COMMAND ln -sf ${CMAKE_CURRENT_BINARY_DIR}/CXX_wrapper.sh ${DPHPD_LOCAL_BIN_DIR}/discopop_hotspot_cxx)
    
    message(STATUS "Creating symlink ${DPHPD_LOCAL_BIN_DIR}/discopop_hotspot_cmake to ${CMAKE_CURRENT_BINARY_DIR}/CMAKE_wrapper.sh")
    execute_process(COMMAND ln -sf ${CMAKE_CURRENT_BINARY_DIR}/CMAKE_wrapper.sh ${DPHPD_LOCAL_BIN_DIR}/discopop_hotspot_cmake)
else()
    message(WARNING "Creation of symlinks discopop_hotspot_cc to ${CMAKE_CURRENT_BINARY_DIR}/CC_wrapper.sh not possible. Please create it manually.")
    message(WARNING "Creation of symlinks discopop_hotspot_cxx to ${CMAKE_CURRENT_BINARY_DIR}/CXX_wrapper.sh not possible. Please create it manually.")
    message(WARNING "Creation of symlinks discopop_hotspot_cmake to ${CMAKE_CURRENT_BINARY_DIR}/CMAKE_wrapper.sh not possible. Please create it manually.")
endif()
