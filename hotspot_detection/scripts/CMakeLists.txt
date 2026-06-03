install(PROGRAMS
    ${CMAKE_CURRENT_SOURCE_DIR}/CC_wrapper.sh
    ${CMAKE_CURRENT_SOURCE_DIR}/CXX_wrapper.sh
    ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE_wrapper.sh
    ${CMAKE_CURRENT_SOURCE_DIR}/LINKER_wrapper.sh
    ${CMAKE_CURRENT_SOURCE_DIR}/runHotspotDetection
    DESTINATION discopop-hotspot-detection.libs
)
