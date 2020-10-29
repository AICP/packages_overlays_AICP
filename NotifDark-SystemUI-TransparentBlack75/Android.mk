LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_RRO_THEME := NotifDark-SystemUI-TransparentBlack75
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := platform
LOCAL_SDK_VERSION := current
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
LOCAL_PACKAGE_NAME := NotifDark-SystemUI-TransparentBlack75

include $(BUILD_RRO_PACKAGE)
