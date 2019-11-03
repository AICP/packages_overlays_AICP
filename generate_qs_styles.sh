#!/bin/sh

my_path="$(dirname "$(realpath "$0")")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

plain_template="$my_path/plain_qs_template"
fg_overlay_package="com.aicp.overlay.qs_fg"
product_packages_makefile="$my_path/product_packages_qs_styles.mk"

function generate_qs_fg_style() {
    # generate_qs_fg_style <name> <template>
    name="$1"
    template="$2"
    out_dir="$my_path/QsIconsFg-$name"
    name_lc=`echo "$name" | tr '[:upper:]' '[:lower:]'`
    generate_overlay "theming_qs_fg_$name_lc" "aicp.qs_fg" "$template" "$out_dir" "com.android.systemui" "$fg_overlay_package.$name_lc" "" "$product_packages_makefile"
}

# Clean previous makefile
rm -f "$product_packages_makefile"

generate_qs_fg_style "Plain" "$my_path/qs_fg_plain_template"
