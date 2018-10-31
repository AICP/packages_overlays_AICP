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
overlay_package="com.aicp.overlay.defaultdark"
overlay_package_black="com.aicp.overlay.defaultblack"

fix_dd() {
    basename="$1"

    if [ -d "$my_path/$basename-System" ]; then

        # Don't overlay accent, we have extra overlays for that
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_material_light"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_material_dark"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_light"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_dark"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_700"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_50"
        rm "$my_path/$basename-System/res/values/type1a.xml"

    fi

    if [ -d "$my_path/$basename-Settings" ]; then

        # Remove unimportant styles that break compile
        remove_tag "$my_path/$basename-Settings/res/values/styles.xml" "style" "ThemeOverlay.SwitchBar.Settings"
        remove_tag "$my_path/$basename-Settings/res/values/styles.xml" "style" "Theme.ActionBar"
        remove_tag "$my_path/$basename-Settings/res/values/styles.xml" "style" "Theme.AlertDialog"

    fi

    if [ -d "$my_path/$basename-Calculator" ]; then

        # Remove unimportant styles that break compile
        remove_tag "$my_path/$basename-Calculator/res/values/type1a.xml" "style" "PadButtonStyle"

    fi

}

generate_overlay "$overlay_path" "$my_path/DefaultDark-System" "android" "$overlay_package" || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-SystemUI" "com.android.systemui" "$overlay_package" || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-Settings" "com.android.settings" "$overlay_package" || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-Calculator" "com.android.calculator2" "$overlay_package" || exit $?
fix_dd DefaultDark

generate_overlay "$overlay_path" "$my_path/DefaultBlack-System" "android" "$overlay_package_black" 1:b:More_black_backgrounds || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultBlack-SystemUI" "com.android.systemui" "$overlay_package_black" 1:a:Black_QS || exit $?
fix_dd DefaultBlack

override_package "$my_path/DefaultDark-SystemUI" "SysuiDarkThemeOverlay"

# Clean up theme variants
"$dd_path/generate_type3/clean.sh" > /dev/null
