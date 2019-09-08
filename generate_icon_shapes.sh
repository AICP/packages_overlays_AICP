#!/bin/sh

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

template="$my_path/icon_shape_template"
overlay_package="com.aicp.overlay.icon_shape"
product_packages_makefile="$my_path/product_packages_icon_shapes.mk"

function generate_icon_shape() {
    # Usage:
    # generate_accent <name> <shape> <dialogCornerRadius> <bottomDialogCornerRadius>
    name="$1"
    shape="$2"
    dialogCornerRadius="$3"
    bottomDialogCornerRadius="$4"
    out_dir="$my_path/IconShape-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_icon_shape_$name_lc" "android.theme.customization.adaptive_icon_shape" "$template" "$out_dir" "android" "$overlay_package.$name_lc" "" "$product_packages_makefile"
    config_file="$out_dir/res/values/config.xml"
    sed -i "s|?icon_mask|$shape|g" "$config_file"
    sed -i "s|?dialogCornerRadius|$dialogCornerRadius|g" "$config_file"
    sed -i "s|?bottomDialogCornerRadius|$bottomDialogCornerRadius|g" "$config_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_icon_shape "Hexagon" "M 50,0 L 6.699,25 L 6.699,75 L 50,100 L 93.301,75 L 93.301,25 Z" "0dp" "0dp"
