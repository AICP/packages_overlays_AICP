#!/bin/bash

my_path="$(dirname "$0")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

dd_path="../../../external/DefaultDarkTheme-oms"

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
        # Don't use holo_blue_accent
        rm "$my_path/$basename-System/res/values/type1c.xml"
        find "$my_path/$basename-System" -name "*.xml" -exec sed -i 's|@android:color/holo_blue_bright|@*android:color/accent_material_dark|g' '{}' \;

        # Don't overlay accent, we have extra overlays for that
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_material_light"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_material_dark"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_light"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_dark"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_700"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_50"

        # Let's be less aggressive making everything dark to avoid readability issues
        remove_tag "$my_path/$basename-System/res/values/styles.xml" "style" "Theme.DeviceDefault.*?Light.?"
        remove_tag "$my_path/$basename-System/res/values/styles.xml" "style" "Widget.DeviceDefault.*?Light.?"

        # Let's not theme PackageInstaller - people can install full theme if they want it
        rm "$my_path/$basename-System/res/drawable"**/perm*

        # Clean up other unneeded resources
        rm "$my_path/$basename-System/res/drawable"**/tab_*
    fi

    if [ -d "$my_path/$basename-SystemUI" ]; then
        # Remove unimportant styles that break compile
        remove_tag "$my_path/$basename-SystemUI/res/values/dup_gen_styles.xml" "style" "systemui_theme"

        # Let's be less aggressive making everything dark to avoid readability issues
        remove_tag "$my_path/$basename-SystemUI/res/values/colors.xml" "color" "notification_guts_.*?"
        rm "$my_path/$basename-SystemUI/res/color/notification_guts"*
    fi

    if [ -d "$my_path/$basename-Settings" ]; then
        # Don't use holo_blue_accent
        find "$my_path/$basename-Settings" -name "*.xml" -exec sed -i 's|@android:color/holo_blue_bright|@*android:color/accent_material_dark|g' '{}' \;

        # Remove unimportant styles that break compile
        remove_tag "$my_path/$basename-Settings/res/values/styles.xml" "style" "Theme.SubSettingsDialogWhenLarge"
        remove_tag "$my_path/$basename-Settings/res/values/styles.xml" "style" "ThemeOverlay.SwitchBar.Settings"
        remove_tag "$my_path/$basename-Settings/res/values/styles.xml" "style" "ThemeOverlay.SwitchBar.SubSettings"

        # Let's be less aggressive making everything dark to avoid readability issues
        remove_tag "$my_path/$basename-Settings/res/values/colors.xml" "color" "bluetooth_dialog_text_color"

        # Clean up other unneeded resources
        rm "$my_path/$basename-Settings/res/drawable"**/ic_*
        rm "$my_path/$basename-Settings/res/drawable/aicp_logo_bg.png"
        rm "$my_path/$basename-Settings/res/drawable"**/nfc_payment_empty_state.png
    fi

    if [ -d "$my_path/$basename-Calculator" ]; then
        # Remove unimportant styles that break compile
        remove_tag "$my_path/$basename-Calculator/res/values/type1a.xml" "style" "PadButtonStyle"
    fi

}

generate_overlay "$overlay_path" "$my_path/DefaultDark-System" "android" "$overlay_package" || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-SystemUI" "com.android.systemui" "$overlay_package" 2:android_8_darker || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-Settings" "com.android.settings" "$overlay_package" || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-Calculator" "com.android.calculator2" "$overlay_package" || exit $?
fix_dd DefaultDark

generate_overlay "$overlay_path" "$my_path/DefaultBlack-System" "android" "$overlay_package_black" 1:b:more_black || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultBlack-SystemUI" "com.android.systemui" "$overlay_package_black" 2:android_8_black || exit $?
fix_dd DefaultBlack

# Clean up theme variants
"$dd_path/generate_type3/clean.sh" > /dev/null
