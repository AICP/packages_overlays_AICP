LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_RRO_THEME := Accent-WhiteBlack
LOCAL_CERTIFICATE := platform
LOCAL_SDK_VERSION := current
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
LOCAL_PACKAGE_NAME := Accent-WhiteBlack

include $(BUILD_RRO_SYSTEM_PACKAGE)
