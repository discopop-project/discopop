# copy scripts to build folder
message(STATUS "Copying scripts to: ${CMAKE_CURRENT_BINARY_DIR}")
configure_file(runHotspotDetection runHotspotDetection COPYONLY)
configure_file(detection.py detection.py COPYONLY)
configure_file(CC_wrapper.sh CC_wrapper.sh COPYONLY)
