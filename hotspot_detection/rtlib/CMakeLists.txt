# Runtime library sources and build flags.
set(HotspotDetection_SOURCES
        rtlib.c
)

add_library(HotspotDetection_RT STATIC
        ${HotspotDetection_SOURCES})
install(TARGETS HotspotDetection_RT ARCHIVE DESTINATION lib)
