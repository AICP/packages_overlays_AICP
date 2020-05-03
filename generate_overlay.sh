#!/bin/bash

my_path="$(dirname "$(realpath "$0")")"

function remove_tag() {
    # Usage:
    # remove_tag <file> <tag> <name>
    file="$1"
    tag_name="$2"
    name="$3"
    cat "$file" | tr '\n' '\r' | perl -pe "s|<$tag_name name=\"$name\".*?</$tag_name>||g" | tr '\r' '\n' > "$file.tmp"
    mv "$file.tmp" "$file"
}

function generate_overlay() {
    # Usage:
    # generate_overlay [--night] <label_res> <category> <source_dir> <target_dir> <target_package> <overlay_package> <dependency_package> <append_to_makefile> [variants...]
    # variants can be
    #   1:a:<name>
    #   1:b:<name>
    #   1:c:<name>
    #   2:<name>    NOTE: overwriting style/color resources in values* only works when defined in the same file (name-wise)
    #   3:<name>
    # NOTE:
    # Referencing private resources not supported, needs manual intervention

    if [ "$1" = "--night" ]; then
        night=1
        shift
    else
        night=0
    fi

    label_res="$1"
    shift

    category="$1"
    shift

    source_dir="$1"
    if [ ! -d "$source_dir" ]; then
        echo "Invalid source overlays dir!"
        exit 1
    fi

    target_dir="$2"
    if [ -z "$target_dir" ]; then
        echo "Invalid target dir!"
        exit 1
    fi
    name="$(basename "$target_dir")"
    if [ -z "$name" ]; then
        echo "Invalid name!"
        exit 1
    fi

    target_package="$3"
    if [ -z "$target_package" ]; then
        echo "Missing target package!"
        exit 1
    fi

    overlay_package_name="$4"
    if [ -z "$overlay_package_name" ]; then
        echo "Missing overlay package name!"
        exit 1
    fi

    # This one actually can be empty, when we only compile against framework
    dependency_package="$5"

    append_to_makefile="$6"
    if [ -z "$append_to_makefile" ]; then
        echo "Missing makefile to append product package to!"
        exit 1
    fi

    source_overlay="$source_dir/$target_package"
    if [ ! -d "$source_overlay" ]; then
        echo "No overlay found for package $target_package!"
        exit 1
    fi

    variants="${@:7}"


    # --- Target direcory ---
    rm -rf "$target_dir"
    mkdir "$target_dir"


    # --- Makefile ---
    makefile="$target_dir/Android.mk"

    if [ ! -z "$dependency_package" ]; then
        dependency_res='$(TARGET_OUT_INTERMEDIATES)/APPS/'"$dependency_package"'_intermediates/package.apk'
    else
        dependency_res=
    fi

    echo 'LOCAL_PATH:= $(call my-dir)' > $makefile
    echo 'include $(CLEAR_VARS)' >> $makefile
    echo '' >> $makefile
    echo "LOCAL_RRO_THEME := $name" >> $makefile
    echo 'LOCAL_PRODUCT_MODULE := true' >> $makefile
    echo 'LOCAL_CERTIFICATE := platform' >> $makefile
    echo 'LOCAL_SDK_VERSION := current' >> $makefile
    echo 'LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res' >> $makefile
    echo "LOCAL_PACKAGE_NAME := $name" >> $makefile
    if [ ! -z "$dependency_res" ]; then
        echo "LOCAL_RESOURCE_DEPENDENCIES := $dependency_res" >> $makefile
        echo "LOCAL_AAPT_FLAGS := -I $dependency_res" >> $makefile
    fi
    echo '' >> $makefile
    echo 'include $(BUILD_RRO_PACKAGE)' >> $makefile


    # --- Manifest ---

    manifest="$target_dir/AndroidManifest.xml"

    echo '<manifest xmlns:android="http://schemas.android.com/apk/res/android"' > $manifest
    echo "package=\"$overlay_package_name.$target_package\"" >> $manifest
    echo '    android:versionCode="1"' >> $manifest
    echo '    android:versionName="1.0">' >> $manifest
    echo >> $manifest
    echo '    <overlay' >> $manifest
    echo "        android:targetPackage=\"$target_package\"" >> $manifest
    echo "        android:category=\"$category\"" >> $manifest
    echo '        android:priority="1" />' >> $manifest
    echo >> $manifest
    echo '    <application' >> $manifest
    echo "        android:label=\"@string/$label_res\"" >> $manifest
    echo '        android:hasCode="false" />' >> $manifest
    echo >> $manifest
    echo '</manifest>' >> $manifest


    # --- Product packages Makefile ---
    if [ ! -f "$append_to_makefile" ]; then
        echo "PRODUCT_PACKAGES += \\" > "$append_to_makefile"
    fi
    echo "    $name \\" >> "$append_to_makefile"


    # --- Resources ---

    res_dir="$target_dir/res"
    source_res_dir="$source_overlay/res"
    # Type3 variant
    for variant in $variants; do
        if [ "${variant:0:2}" = "3:" ]; then
            source_res_dir="$source_overlay/type3_${variant:2}"
            if [ ! -d "$source_res_dir" ]; then
                echo "Type 3 variant not found at $source_res_dir"
                exit 1
            fi
            break
        fi
    done
    cp -r "$source_res_dir" "$res_dir"

    # Move resources to -night counterparts if requested (for dark themes)
    if [ "$night" = "1" ]; then
        for f in "$target_dir/res"/*; do
            if [[ "$f" =~ -night ]]; then
                echo "$f is already night resource"
            else
                # error: invalid configuration 'xxhdpi-night'.
                bf="$(basename "$f")"
                df="$(dirname "$f")"
                if [[ "$bf" =~ "-" ]]; then
                    mv $f $df/`echo "$bf" | sed 's/\(.*\)\(-.*\)/\1-night\2/'`
                else
                    mv $f $f-night
                fi
            fi
        done
    fi
    # Common string resources
    mkdir -p "$res_dir/values/"
    cp "$my_path/common-resources/res/values/"* "$res_dir/values/"
    cp -r "$my_path/common-resources/res/values-"* "$res_dir"


    # --- Variants type 1+2 ---
    for variant in $variants; do
        if [ "${variant:0:2}" = "1:" ]; then
            # Type 1 variant
            variant_type="type1${variant:2:1}"
            target_file="$source_overlay/$variant_type"_"${variant:4}.xml"
            if [ ! -f "$target_file" ]; then
                echo "$target_file: target file not found"
                exit 1
            fi
            original_file="$(find "$res_dir" -name "$variant_type.xml")"
            if [ ! -f "$original_file" ]; then
                echo "$original_file: original file not found"
                exit 1
            fi
            cp -f "$target_file" "$original_file"
        elif [ "${variant:0:2}" = "2:" ]; then
            # Type 2 variant
            target_dir="$source_overlay/type2_${variant:2}"
            if [ ! -d "$target_dir" ]; then
                echo "$target_dir: target dir not found"
                exit 1
            fi
            for d1 in "$target_dir"/*; do
                if [ -d "$d1" ]; then
                    f1="$(basename "$d1")"
                    mkdir -p "$res_dir/$f1"
                    for d2 in "$d1"/*; do
                        f2="$(basename "$d2")"
                        if [ -f "$d2" ]; then
                            target_file="$res_dir/$f1/$f2"
                            if [ -f "$target_file" ] && [ "${f1:0:7}" = "values" ]; then
                                grep "<color" "$d2" | while read -r line; do
                                    name="$(echo "$line" | sed 's|.*name=\"||' | sed 's|\".*||')"
                                    remove_tag "$target_file" "color" "$name"
                                done
                                grep "<style" "$d2" | while read -r line; do
                                    name="$(echo "$line" | sed 's|.*name=\"||' | sed 's|\".*||')"
                                    remove_tag "$target_file" "style" "$name"
                                done
                                cp "$d2" "$res_dir/$f1/dup_gen_$f2"
                            else
                                cp -f "$d2" "$target_file"
                            fi
                        fi
                    done
                fi
            done
        fi
    done
}

function override_package() {
    # Add package override to overlay makefile
    # Usage:
    # overwrite_package <overlay dir> <overrides package>
    overlay="$1"
    package="$2"
    cat "$overlay/Android.mk" | tr '\n' '\r' | sed 's/\(\r\r.*\r\r\)/\1LOCAL_OVERRIDES_PACKAGES := '"$package"'\r\r/'  | tr '\r' '\n' > "$overlay/Android2.mk"
    mv "$overlay/Android2.mk" "$overlay/Android.mk"
}

if [ ! -z "$1" ]; then
    # Direct script usage
    generate_overlay $@
fi
