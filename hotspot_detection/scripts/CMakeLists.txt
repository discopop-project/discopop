# copy scripts to build folder
message(STATUS "Copying scripts to: ${CMAKE_CURRENT_BINARY_DIR}")
configure_file(runHotspotDetection runHotspotDetection COPYONLY)