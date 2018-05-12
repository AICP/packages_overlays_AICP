LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_RRO_THEME := DefaultDark-SystemUI
LOCAL_CERTIFICATE := platform
LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
LOCAL_PACKAGE_NAME := DefaultDark-SystemUI
LOCAL_OVERRIDES_PACKAGES := SysuiDarkThemeOverlay \
                            LineageDarkTheme

include $(BUILD_RRO_SYSTEM_PACKAGE)
