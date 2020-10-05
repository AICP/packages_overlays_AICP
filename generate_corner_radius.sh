#!/bin/bash

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template="$my_path/corner_radius_template"
overlay_package="com.aicp.overlay.corner_radius"
product_packages_makefile="$my_path/product_packages_corner_radius.mk"

function generate_corner_radius() {
    # Usage:
    # generate_corner_radius <name> <dialogCornerRadius> <bottomDialogCornerRadius>
    name="$1"
    dialogCornerRadius="$2"
    bottomDialogCornerRadius="$3"
    buttonCornerRadius="$4"
    progressBarCornerRadius="$5"
    widgetOuterRadius="$6"
    widgetInnerRadius="$7"
    out_dir="$my_path/CornerRadius-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_corner_radius_$name_lc" "aicp.corner_radius" "$template" "$out_dir" "android" "$overlay_package.$name_lc" "" "$product_packages_makefile"
    config_file="$out_dir/res/values/config.xml"
    sed -i "s|?dialogCornerRadius|$dialogCornerRadius|g" "$config_file"
    sed -i "s|?bottomDialogCornerRadius|$bottomDialogCornerRadius|g" "$config_file"
    sed -i "s|?buttonCornerRadius|$buttonCornerRadius|g" "$config_file"
    sed -i "s|?progressBarCornerRadius|$progressBarCornerRadius|g" "$config_file"
    sed -i "s|?widgetOuterRadius|$widgetOuterRadius|g" "$config_file"
    sed -i "s|?widgetInnerRadius|$widgetInnerRadius|g" "$config_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_corner_radius "Square" "0dp" "0dp" "0dp" "0dp" "0dp" "0dp"
generate_corner_radius "Round_2_2" "2dp" "2dp" "4dp" "50dp" "2dp" "2dp"
generate_corner_radius "Round_4_8" "4dp" "8dp" "4dp" "100dp" "4dp" "2dp"
generate_corner_radius "Round_8_16" "8dp" "16dp" "8dp" "500dp" "8dp" "6dp"
generate_corner_radius "Pixel" "28dp" "16dp" "4dp" "1000dp" "28dp" "20dp"
