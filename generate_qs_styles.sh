#!/bin/bash

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

fg_overlay_package="com.aicp.overlay.qs_fg"
bg_dark_overlay_package="com.aicp.overlay.qs_bg_dark"
bg_light_overlay_package="com.aicp.overlay.qs_bg_light"
product_packages_makefile="$my_path/product_packages_qs_styles.mk"

function generate_qs_fg_style() {
    # generate_qs_fg_style <name> <template>
    name="$1"
    template="$2"
    out_dir="$my_path/QsIconsFg-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_qs_fg_$name_lc" "aicp.qs_fg" "$template" "$out_dir" "com.android.systemui" "$fg_overlay_package.$name_lc" "" "$product_packages_makefile"
}

function generate_qs_bg_dark_style() {
    # generate_qs_bg_dark_style <name> <background_floating> <panel_background>
    name="$1"
    background_floating="$2"
    panel_background="$3"
    out_dir="$my_path/QsBgDark-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay --night "theming_qs_bg_dark_$name_lc" "aicp.qs_bg_dark" "$my_path/qs_bg_template" "$out_dir" "com.android.systemui" "$bg_dark_overlay_package.$name_lc" "SystemUI" "$product_packages_makefile"
    style_file="$out_dir/res/values-night/styles.xml"
    sed -i "s|?background_floating|$background_floating|g" "$style_file"
    sed -i "s|?panel_background|$panel_background|g" "$style_file"
}

function generate_qs_bg_light_style() {
    # generate_qs_bg_light_style <name> <background_floating> <panel_background>
    name="$1"
    background_floating="$2"
    panel_background="$3"
    out_dir="$my_path/QsBgLight-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_qs_bg_light_$name_lc" "aicp.qs_bg_light" "$my_path/qs_bg_template" "$out_dir" "com.android.systemui" "$bg_light_overlay_package.$name_lc" "SystemUI" "$product_packages_makefile"
    style_file="$out_dir/res/values/styles.xml"
    sed -i "s|?background_floating|$background_floating|g" "$style_file"
    sed -i "s|?panel_background|$panel_background|g" "$style_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_qs_fg_style "Plain" "$my_path/qs_fg_plain_template"
generate_qs_bg_dark_style "Gray" "#ff303030" "#ff424242"
generate_qs_bg_dark_style "TransparentBlack50" "#80000000" "#80303030"
generate_qs_bg_dark_style "TransparentBlack75" "#b3000000" "#b3303030"
generate_qs_bg_dark_style "TransparentGray50" "#80303030" "#80424242"
generate_qs_bg_dark_style "TransparentGray75" "#b3303030" "#b3424242"
generate_qs_bg_dark_style "FollowSystem" "@*android:color/background_device_default_dark" "@*android:color/background_floating_device_default_dark"
generate_qs_bg_light_style "TransparentWhite" "#b3ffffff" "#b3eeeeee"
generate_qs_bg_light_style "FollowSystem" "@*android:color/background_device_default_light" "@*android:color/background_floating_device_default_light"
