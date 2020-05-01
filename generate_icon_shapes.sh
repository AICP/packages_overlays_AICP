#!/bin/bash

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template="$my_path/icon_shape_template"
overlay_package="com.aicp.overlay.icon_shape"
product_packages_makefile="$my_path/product_packages_icon_shapes.mk"

function generate_icon_shape() {
    # Usage:
    # generate_accent <name> <shape> <useRoundIcon>
    name="$1"
    shape="$2"
    useRoundIcon="$3"
    out_dir="$my_path/IconShape-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_icon_shape_$name_lc" "android.theme.customization.adaptive_icon_shape" "$template" "$out_dir" "android" "$overlay_package.$name_lc" "" "$product_packages_makefile"
    config_file="$out_dir/res/values/config.xml"
    sed -i "s|?icon_mask|$shape|g" "$config_file"
    sed -i "s|?useRoundIcon|$useRoundIcon|g" "$config_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_icon_shape "Round" "M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0" "true"
generate_icon_shape "Squircle" "M50,0 C10,0 0,10 0,50 0,90 10,100 50,100 90,100 100,90 100,50 100,10 90,0 50,0 Z" "false"
generate_icon_shape "SlightlyRounded" "M50,0L92,0C96.42,0 100,4.58 100 8L100,92C100, 96.42 96.42 100 92 100L8 100C4.58, 100 0 96.42 0 92L0 8 C 0 4.42 4.42 0 8 0L50 0Z" "false"
generate_icon_shape "RoundedRect" "M50,0L88,0 C94.4,0 100,5.4 100 12 L100,88 C100,94.6 94.6 100 88 100 L12,100 C5.4,100 0,94.6 0,88 L0 12 C0 5.4 5.4 0 12 0 L50,0 Z" "false"
generate_icon_shape "Teardrop" "M50,0 C77.6,0 100,22.4 100,50 L100,88 C100,94.6 94.6,100 88,100 L50,100 C22.4 100 0 77.6 0 50C0 22.4 22.4 0 50 0 Z" "false"
generate_icon_shape "Square" "M50,0L100,0 100,100 0,100 0,0z" "false"
generate_icon_shape "Hexagon" "M 50,0 L 6.699,25 L 6.699,75 L 50,100 L 93.301,75 L 93.301,25 Z" "false"
