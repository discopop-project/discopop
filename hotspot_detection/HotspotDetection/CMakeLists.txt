add_llvm_library(LLVMHotspotDetection MODULE
        HotspotDetection.cpp
)

install(TARGETS LLVMHotspotDetection LIBRARY DESTINATION discopop-hotspot-detection.libs)