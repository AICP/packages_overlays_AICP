LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_RRO_THEME := DefaultDark-DeskClock
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := platform
LOCAL_SDK_VERSION := current
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
LOCAL_PACKAGE_NAME := DefaultDark-DeskClock
LOCAL_RESOURCE_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/APPS/DeskClock_intermediates/package.apk
LOCAL_AAPT_FLAGS := -I $(TARGET_OUT_INTERMEDIATES)/APPS/DeskClock_intermediates/package.apk

include $(BUILD_RRO_PACKAGE)
