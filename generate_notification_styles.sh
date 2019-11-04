#!/bin/sh

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

notif_dark_overlay_package="com.aicp.overlay.notif_dark"
notif_light_overlay_package="com.aicp.overlay.notif_light"
product_packages_makefile="$my_path/product_packages_notif_styles.mk"

function generate_notif_dark_style() {
    # generate_notif_dark_style <name> <background>
    name="$1"
    background="$2"
    background_dimmed="$3"
    shade="$4"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`

    out_dir="$my_path/NotifDark-SystemUI-$name"
    generate_overlay --night "theming_notif_dark_$name_lc" "aicp.notif_dark" "$my_path/notif_template" "$out_dir" "com.android.systemui" "$notif_dark_overlay_package.$name_lc" "SystemUI" "$product_packages_makefile"
    colors_file="$out_dir/res/values-night/colors.xml"
    sed -i "s|?background_dimmed|$background_dimmed|g" "$colors_file"
    sed -i "s|?shade|$shade|g" "$colors_file"
    sed -i "s|?background|$background|g" "$colors_file"

    out_dir="$my_path/NotifDark-System-$name"
    generate_overlay --night "theming_notif_dark_$name_lc" "aicp.notif_dark" "$my_path/notif_template" "$out_dir" "android" "$notif_dark_overlay_package.$name_lc" "" "$product_packages_makefile"
    colors_file="$out_dir/res/values-night/colors.xml"
    sed -i "s|?background|$background|g" "$colors_file"
}

function generate_notif_light_style() {
    # generate_notif_light_style <name> <background> <background_dimmed> <shade>
    name="$1"
    background="$2"
    background_dimmed="$3"
    shade="$4"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`

    out_dir="$my_path/NotifLight-SystemUI-$name"
    generate_overlay "theming_notif_light_$name_lc" "aicp.notif_light" "$my_path/notif_template" "$out_dir" "com.android.systemui" "$notif_dark_overlay_package.$name_lc" "SystemUI" "$product_packages_makefile"
    colors_file="$out_dir/res/values/colors.xml"
    sed -i "s|?background_dimmed|$background_dimmed|g" "$colors_file"
    sed -i "s|?shade|$shade|g" "$colors_file"
    sed -i "s|?background|$background|g" "$colors_file"

    out_dir="$my_path/NotifLight-System-$name"
    generate_overlay "theming_notif_light_$name_lc" "aicp.notif_light" "$my_path/notif_template" "$out_dir" "android" "$notif_light_overlay_package.$name_lc" "" "$product_packages_makefile"
    colors_file="$out_dir/res/values/colors.xml"
    sed -i "s|?background|$background|g" "$colors_file"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_notif_dark_style "Gray" "#ff303030" "#aa000000" "#212121"
generate_notif_dark_style "TransparentGray" "#80303030" "#80000000" "#00000000"
generate_notif_dark_style "TransparentBlack" "#80000000" "#60000000" "#00000000"
generate_notif_light_style "TransparentWhite" "#b3ffffff" "#80ffffff" "#00000000"
