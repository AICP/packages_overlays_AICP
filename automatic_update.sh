#!/bin/sh

# Undo local changes
git reset HEAD --hard
# Build updates
./generate_accents.sh
./generate_icon_shapes.sh
# Commit
git add -A
git commit -m "Automatic theme update"
