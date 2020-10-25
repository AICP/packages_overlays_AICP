#!/bin/bash

# Require clean git state
uncommitted=`git status --porcelain`
if [ ! -z "$uncommitted" ]; then
    echo "Uncommitted changes are present, please commit first!"
    exit 1
fi
# Build updates
./generate_accents.sh
./generate_background_themes.sh
./generate_corner_radius.sh
./generate_icon_shapes.sh
./generate_notification_styles.sh
./generate_qs_styles.sh
# Commit
git add -A
git commit -m "Automatic theme update"
