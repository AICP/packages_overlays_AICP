#!/bin/bash

my_path="$(dirname "$0")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

dd_path="../../../external/DefaultDarkTheme-oms"

if [ ! -d "$dd_path" ]; then
    echo "Cannon access $dd_path"
    exit 1
fi


# Prepare theme variants

"$dd_path/generate_type3/gen.sh" > /dev/null


# Generate themes

overlay_path="$dd_path/app/src/main/assets/overlays"
overlay_package="com.aicp.overlay.defaultdark"
generate_overlay "$overlay_path" "$my_path/DefaultDark-System" "android" "$overlay_package" || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-SystemUI" "com.android.systemui" "$overlay_package" 2:android_8_darker || exit $?
generate_overlay "$overlay_path" "$my_path/DefaultDark-Settings" "com.android.settings" "$overlay_package" || exit $?


# Don't use holo_blue_accent
rm "$my_path/DefaultDark-System/res/values/type1c.xml"
find "$my_path/DefaultDark-System" -name "*.xml" -exec sed -i 's|@android:color/holo_blue_bright|@*android:color/accent_material_dark|g' '{}' \;
find "$my_path/DefaultDark-Settings" -name "*.xml" -exec sed -i 's|@android:color/holo_blue_bright|@*android:color/accent_material_dark|g' '{}' \;

# Remove unimportant styles that break compile
remove_tag "$my_path/DefaultDark-SystemUI/res/values/dup_gen_styles.xml" "style" "systemui_theme"
remove_tag "$my_path/DefaultDark-Settings/res/values/styles.xml" "style" "Theme.SubSettingsDialogWhenLarge"
remove_tag "$my_path/DefaultDark-Settings/res/values/styles.xml" "style" "ThemeOverlay.SwitchBar.Settings"
remove_tag "$my_path/DefaultDark-Settings/res/values/styles.xml" "style" "ThemeOverlay.SwitchBar.SubSettings"

# Don't overlay accent, we have extra overlays for that
remove_tag "$my_path/DefaultDark-System/res/values/colors.xml" "color" "accent_material_light"
remove_tag "$my_path/DefaultDark-System/res/values/colors.xml" "color" "accent_material_dark"
remove_tag "$my_path/DefaultDark-System/res/values/colors.xml" "color" "accent_device_default_light"
remove_tag "$my_path/DefaultDark-System/res/values/colors.xml" "color" "accent_device_default_dark"
remove_tag "$my_path/DefaultDark-System/res/values/colors.xml" "color" "accent_device_default_700"
remove_tag "$my_path/DefaultDark-System/res/values/colors.xml" "color" "accent_device_default_50"

# Clean up theme variants
"$dd_path/generate_type3/clean.sh" > /dev/null
