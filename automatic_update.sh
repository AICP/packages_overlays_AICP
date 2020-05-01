#!/bin/sh

# Undo local changes
git reset HEAD --hard
# Build updates
./generate_accents.sh
./generate_background_themes.sh
./generate_corner_radius.sh
./generate_default_dark.sh
./generate_icon_shapes.sh
./generate_notification_styles.sh
./generate_qs_styles.sh
# Commit
git add -A
git commit -m "Automatic theme update"
