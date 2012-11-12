$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libaudcal_intermediates)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libaudcal_intermediates/export_includes)

LOCAL_PATH := $(call my-dir)

device-makefiles := \

include $(call all-named-subdir-makefiles,$(device-makefiles))
