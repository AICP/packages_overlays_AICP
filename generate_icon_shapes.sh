#!/bin/sh

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template="$my_path/icon_shape_template"
overlay_package="com.aicp.overlay.icon_shape"
product_packages_makefile="$my_path/product_packages_icon_shapes.mk"

function generate_icon_shape() {
    # Usage:
    # generate_accent <name> <shape> <dialogCornerRadius> <bottomDialogCornerRadius> <useRoundIcon>
    name="$1"
    shape="$2"
    dialogCornerRadius="$3"
    bottomDialogCornerRadius="$4"
    useRoundIcon="$5"
    out_dir="$my_path/IconShape-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_icon_shape_$name_lc" "android.theme.customization.adaptive_icon_shape" "$template" "$out_dir" "android" "$overlay_package.$name_lc" "" "$product_packages_makefile"
    config_file="$out_dir/res/values/config.xml"
    sed -i "s|?icon_mask|$shape|g" "$config_file"
    sed -i "s|?dialogCornerRadius|$dialogCornerRadius|g" "$config_file"
    sed -i "s|?bottomDialogCornerRadius|$bottomDialogCornerRadius|g" "$config_file"
    sed -i "s|?useRoundIcon|$useRoundIcon|g" "$config_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_icon_shape "SlightlyRounded" "M50,0L92,0C96.42,0 100,4.58 100 8L100,92C100, 96.42 96.42 100 92 100L8 100C4.58, 100 0 96.42 0 92L0 8 C 0 4.42 4.42 0 8 0L50 0Z" "2dp" "2dp" "false"
generate_icon_shape "Square" "M50,0L100,0 100,100 0,100 0,0z" "0dp" "0dp" "false"
generate_icon_shape "Hexagon" "M 50,0 L 6.699,25 L 6.699,75 L 50,100 L 93.301,75 L 93.301,25 Z" "0dp" "0dp" "false"
generate_icon_shape "Round" "M50 0A50 50,0,1,1,50 100A50 50,0,1,1,50 0" "4dp" "8dp" "true"
