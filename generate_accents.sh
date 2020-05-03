#!/bin/bash

my_path="$(dirname "$0")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template="$my_path/accent_template"
overlay_package="com.aicp.overlay.accent"
product_packages_makefile="$my_path/product_packages_accent.mk"

function generate_accent() {
    # Usage:
    # generate_accent <name> <color_for_light_themes> <color_for_dark_themes> <color_700> <color_50>
    name="$1"
    color_lt="$2"
    color_dk="$3"
    color_700="$4"
    color_50="$5"
    out_dir="$my_path/Accent-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_accent_$name_lc" "aicp.accent" "$template" "$out_dir" "android" "$overlay_package.$name_lc" "" "$product_packages_makefile"
    color_file="$out_dir/res/values/colors.xml"
    sed -i "s|?color_lt|$color_lt|g" "$color_file"
    sed -i "s|?color_dk|$color_dk|g" "$color_file"
    sed -i "s|?color_700|$color_700|g" "$color_file"
    sed -i "s|?color_50|$color_50|g" "$color_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_accent "Amber" "#ffa000" "#ffab00" "#ffa000" "#fff8e1"
generate_accent "BlueLight" "#03a9f4" "#03a9f4" "#0288d1" "#e1f5fe"
generate_accent "Carnation" "#fb83b2" "#ffa6c9" "#ffa6c9" "#fb83b2"
generate_accent "Cyan" "#00bcd4" "#00bcd4" "#0097a7" "#e0f7fa"
generate_accent "Denim" "#1560BD" "#1560BD" "#1560BD" "#1560BD"
generate_accent "Gold" "#CFB53B" "#CFB53B" "#CFB53B" "#CFB53B"
generate_accent "GreenLight" "#8bc34a" "#8bc34a" "#689f38" "#f1f8e9"
generate_accent "Grey" "#808080" "#808080" "#808080" "#808080"
generate_accent "Indigo" "#536DFE" "#536DFE" "#536DFE" "#536DFE"
generate_accent "Lava" "#B20120" "#EB0028" "#EB0028" "#B20120"
generate_accent "Lime" "#cddc39" "#cddc39" "#afb42b" "#f9fbe7"
generate_accent "Orange" "#ff9800" "#ff9800" "#f57c00" "#f57c00"
generate_accent "Oxygen" "#53ADEF" "#53ADEF" "#53ADEF" "#53ADEF"
generate_accent "Pink" "#e91e63" "#f48fb1" "#c2185b" "#fce4ec"
generate_accent "Pixel" "#4285f4" "#3367d6" "#fbc02d" "#136ac3"
generate_accent "Purple" "#673ab7" "#673ab7" "#512da8" "#ede7f6"
generate_accent "Red" "#ff0000" "#ff0000" "#d32f2f" "#ffebee"
generate_accent "Teal" "#008577" "#80cbc4" "#00796b" "#e0f2f1"
generate_accent "Turquoise" "#00C1C1" "#00FFFF" "#00FFFF" "#00C1C1"
generate_accent "WhiteBlack" "#000000" "#ffffff" "#fafafa" "#616161"
generate_accent "Yellow" "#fdd835" "#ffeb3b" "#fbc02d" "#fffde7"
