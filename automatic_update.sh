#!/bin/sh

# Undo local changes
git reset HEAD --hard
# Build updates
./generate_default_dark.sh
./generate_accents.sh
# Commit
git add -A
git commit -m "Automatic theme update"
