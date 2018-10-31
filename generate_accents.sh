#!/bin/sh

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
    generate_overlay "$template" "$out_dir" "android" "$overlay_package.$name_lc" "$product_packages_makefile"
    color_file="$out_dir/res/values/colors.xml"
    sed -i "s|?color_lt|$color_lt|g" "$color_file"
    sed -i "s|?color_dk|$color_dk|g" "$color_file"
    sed -i "s|?color_700|$color_700|g" "$color_file"
    sed -i "s|?color_50|$color_50|g" "$color_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_accent "Amber" "#ffa000" "#ffab00" "#ffa000" "#fff8e1"
generate_accent "GreenLight" "#8bc34a" "#8bc34a" "#689f38" "#f1f8e9"
generate_accent "Lime" "#cddc39" "#cddc39" "#afb42b" "#f9fbe7"
