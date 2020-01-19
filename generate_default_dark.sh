#!/bin/bash

my_path="$(dirname "$0")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

dd_path="../../../external/DarkCroc-Android-theme"

if [ ! -d "$dd_path" ]; then
    echo "Cannot access $dd_path"
    exit 1
fi


# Prepare theme variants

"$dd_path/generate_type3/gen.sh" > /dev/null


# Generate themes

overlay_path="$dd_path/app/src/main/assets/overlays"
template_path="$my_path/default_dark_template"
overlay_package="com.aicp.overlay.defaultdark"
overlay_category="aicp.defaultdark"
product_packages_makefile="$my_path/product_packages_dark.mk"

# Clean previous makefile
rm -f "$product_packages_makefile"


# generate_overlay  wrapper
generate_dark() {
    target_dir="$2"
    target_package="$3"
    label_res="theming_better_dark_$(echo "$target_package" | sed 's/.*\.//')"
    generate_overlay --night "$label_res" "$overlay_category" "$@"
    for file in `find "$target_dir" -name \*.xml`; do
        sed -i 's|>sans-serif-medium<|>@*android:string/config_bodyFontFamilyMedium<|g' "$file"
        sed -i 's|>sans-serif<|>@*android:string/config_bodyFontFamily<|g' "$file"
    done
}


# ----- DarkCroc app import -----

#generate_dark "$overlay_path" "$my_path/DefaultDark-Calculator" "com.android.calculator2" \
#                     "$overlay_package" "ExactCalculator" "$product_packages_makefile" || exit $?

generate_dark "$overlay_path" "$my_path/DefaultDark-Contacts" "com.android.contacts" \
                     "$overlay_package" "Contacts" "$product_packages_makefile" || exit $?

generate_dark "$overlay_path" "$my_path/DefaultDark-DeskClock" "com.android.deskclock" \
                     "$overlay_package" "DeskClock" "$product_packages_makefile" || exit $?

#generate_dark "$overlay_path" "$my_path/DefaultDark-Dialer" "com.android.dialer" \
#                     "$overlay_package" "Dialer" "$product_packages_makefile" || exit $?

generate_dark "$overlay_path" "$my_path/DefaultDark-Messaging" "com.android.messaging" \
                     "$overlay_package" "messaging" "$product_packages_makefile" || exit $?

#generate_dark "$overlay_path" "$my_path/DefaultDark-Phone" "com.android.phone" \
#                     "$overlay_package" "TeleService" "$product_packages_makefile" || exit $?

#generate_dark "$overlay_path" "$my_path/DefaultDark-Telecom" "com.android.server.telecom" \
#                     "$overlay_package" "Telecom" "$product_packages_makefile" || exit $?


# ----- From own template -----

generate_dark "$template_path" "$my_path/DefaultDark-System" "android" \
                     "$overlay_package" "" "$product_packages_makefile" || exit $?

generate_dark "$template_path" "$my_path/DefaultDark-Dialer" "com.android.dialer" \
                     "$overlay_package" "Dialer" "$product_packages_makefile" || exit $?



# Clean up theme variants
"$dd_path/generate_type3/clean.sh" > /dev/null
