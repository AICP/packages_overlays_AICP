LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_RRO_THEME := AndroidBlackTheme
LOCAL_PRODUCT_MODULE := true
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
LOCAL_PACKAGE_NAME := AndroidBlackThemeOverlay
LOCAL_SDK_VERSION := current

include $(BUILD_RRO_PACKAGE)
