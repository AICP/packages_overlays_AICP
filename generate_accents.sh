#!/bin/bash

my_path="$(dirname "$0")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template_light="$my_path/accent_template_light"
overlay_package_light="com.aicp.overlay.lightaccent"
template_dark="$my_path/accent_template_dark"
overlay_package_dark="com.aicp.overlay.darkaccent"
product_packages_makefile="$my_path/product_packages_accent.mk"

function generate_accent_light() {
    # Usage:
    # generate_accent <name> <color_for_light_themes>
    name="$1"
    color_lt="$2"
    out_dir="$my_path/AccentLight-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_accent_$name_lc" "aicp.accent.light" "$template_light" "$out_dir" "android" "$overlay_package_light.$name_lc" "" "$product_packages_makefile"
    color_file="$out_dir/res/values/colors.xml"
    sed -i "s|?color_lt|$color_lt|g" "$color_file"
}

function generate_accent_dark() {
    # Usage:
    # generate_accent <name> <color_for_dark_themes>
    name="$1"
    color_dk="$2"
    out_dir="$my_path/AccentDark-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_accent_$name_lc" "aicp.accent.dark" "$template_dark" "$out_dir" "android" "$overlay_package_dark.$name_lc" "" "$product_packages_makefile"
    color_file="$out_dir/res/values/colors.xml"
    sed -i "s|?color_dk|$color_dk|g" "$color_file"
}

function generate_accent() {
    # Usage:
    # generate_accent <name> <color_for_light_themes> <color_for_dark_themes>
    name="$1"
    color_lt="$2"
    color_dk="$3"
    generate_accent_light "$1" "$color_lt"
    generate_accent_dark "$1" "$color_dk"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_accent "Amber" "#ffa000" "#ffab00"
generate_accent "BlueLight" "#03a9f4" "#03a9f4"
generate_accent "Carnation" "#fb83b2" "#ffa6c9"
generate_accent "Cyan" "#00bcd4" "#00bcd4"
generate_accent "Denim" "#1560BD" "#1560BD"
generate_accent "EtherealBlue" "#7E8ACD" "#7E8ACD"
generate_accent "EtherealGreen" "#7DB694" "#7DB694"
generate_accent "EtherealPink" "#D37A7A" "#D37A7A"
generate_accent "Gold" "#CFB53B" "#CFB53B"
generate_accent "GreenLight" "#8bc34a" "#8bc34a"
generate_accent "Grey" "#808080" "#808080"
generate_accent "Hope" "#5fc72d" "#59ff3a"
generate_accent "Indigo" "#536DFE" "#536DFE"
generate_accent "Lava" "#B20120" "#EB0028"
generate_accent "Lime" "#cddc39" "#cddc39"
generate_accent "Orange" "#ff9800" "#ff9800"
generate_accent "Oxygen" "#53ADEF" "#53ADEF"
generate_accent "Pink" "#e91e63" "#f48fb1"
generate_accent "Pixel" "#4285f4" "#3367d6"
generate_accent "Purple" "#673ab7" "#673ab7"
generate_accent "Red" "#ff0000" "#ff0000"
generate_accent "Teal" "#008577" "#80cbc4"
generate_accent "Turquoise" "#00C1C1" "#00FFFF"
generate_accent "Yellow" "#fdd835" "#ffeb3b"

generate_accent_light "Black" "#202020"
generate_accent_dark "White" "#D7DEE6"
