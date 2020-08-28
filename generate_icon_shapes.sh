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
generate_icon_shape "Pebble" "MM55,0 C25,0 0,25 0,50 0,78 28,100 55,100 85,100 100,85 100,58 100,30 86,0 55,0 Z" "false"
generate_icon_shape "TaperedRect" "M20,0 80,0 100,20 100,80 80,100 20,100 0,80 0,20 20,0 Z" "false"
generate_icon_shape "Vessel" "M12.97,0 C8.41,0 4.14,2.55 2.21,6.68 -1.03,13.61 -0.71,21.78 3.16,28.46 4.89,31.46 4.89,35.2 3.16,38.2 -1.05,45.48 -1.05,54.52 3.16,61.8 4.89,64.8 4.89,68.54 3.16,71.54 -0.71,78.22 -1.03,86.39 2.21,93.32 4.14,97.45 8.41,100 12.97,100 21.38,100 78.62,100 87.03,100 91.59,100 95.85,97.45 97.79,93.32 101.02,86.39 100.71,78.22 96.84,71.54 95.1,68.54 95.1,64.8 96.84,61.8 101.05,54.52 101.05,45.48 96.84,38.2 95.1,35.2 95.1,31.46 96.84,28.46 100.71,21.78 101.02,13.61 97.79,6.68 95.85,2.55 91.59,0 87.03,0 78.62,0 21.38,0 12.97,0 Z" "false"
