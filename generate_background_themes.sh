#!/bin/bash

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template_dark="$my_path/bg_dark_template"
template_dark_legacy="$my_path/bg_dark_legacy_template"
template_light="$my_path/bg_light_template"
overlay_package_dark="com.aicp.overlay.bg_dark"
overlay_package_light="com.aicp.overlay.bg_light"
product_packages_makefile="$my_path/product_packages_background_themes.mk"

function generate_background_dark() {
    # Usage:
    # generate_accent <name> <background> <background_floating> <primary> <primary_dark> <secondary> [<template>]
    name="$1"
    background="$2"
    background_floating="$3"
    primary="$4"
    primary_dark="$5"
    secondary="$6"
    template="$7"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    out_dir="$my_path/BackgroundDark-$name"
    label_res="theming_bg_dark_$name_lc"
    category="aicp.bg_dark"
    if [ -z "$template" ]; then
        template="$template_dark"
    fi
    overlay_package="$overlay_package_dark"
    generate_background
}

function generate_background_light() {
    # Usage:
    # generate_accent <name> <background> <background_floating> <primary> <primary_dark> <secondary>
    name="$1"
    background="$2"
    background_floating="$3"
    primary="$4"
    primary_dark="$5"
    secondary="$6"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    out_dir="$my_path/BackgroundLight-$name"
    label_res="theming_bg_light_$name_lc"
    category="aicp.bg_light"
    template="$template_light"
    overlay_package="$overlay_package_light"
    generate_background
}

function generate_background() {
    generate_overlay "$label_res" "$category" "$template" "$out_dir" "android" "$overlay_package.$name_lc" "" "$product_packages_makefile"
    color_file="$out_dir/res/values/colors.xml"
    sed -i "s|?primary_dark|$primary_dark|g" "$color_file"
    sed -i "s|?primary|$primary|g" "$color_file"
    sed -i "s|?secondary|$secondary|g" "$color_file"
    sed -i "s|?background_floating|$background_floating|g" "$color_file"
    sed -i "s|?background|$background|g" "$color_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_background_dark "Gray" "#ff303030" "#ff424242" "#ff303030" "#ff303030" "#ff424242"
generate_background_dark "Black" "#ff000000" "#ff000000" "#ff000000" "#ff000000" "#ff424242"
generate_background_dark "Blue" "#ff000640" "#ff0b1152" "#ff000640" "#ff000640" "#ff0b1152"
generate_background_dark "Brown" "#ff3e2723" "#ff452d29" "#ff3e2723" "#ff3e2723" "#ff452d29"
generate_background_dark "Purple" "#ff2A0047" "#ff2d044a" "#ff2A0047" "#ff2A0047" "#ff2d044a"
generate_background_light "Pink" "#fff48ed0" "#ffffd4f0" "#fff48ed0" "#ffc272a5" "#fff48ed0"

generate_background_dark "GrayLegacy" "#ff303030" "#ff424242" "#ff212121" "#ff000000" "#ff424242" "$template_dark_legacy"
generate_overlay "theming_bg_dark_graylegacy" "aicp.bg_dark" "$template_dark_legacy" "$my_path/BackgroundDark-GrayLegacySettings" "com.android.settings" "$overlay_package_dark.graylegacy" "" "$product_packages_makefile"
generate_overlay "theming_bg_dark_graylegacy" "aicp.bg_dark" "$template_dark_legacy" "$my_path/BackgroundDark-GrayLegacySettingsIntelligence" "com.android.settings.intelligence" "$overlay_package_dark.graylegacy" "" "$product_packages_makefile"
