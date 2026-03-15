#!/bin/bash

BACKUP_FILE="gnome-settings.dconf"

# The specific dconf paths you want to keep (no brackets, no leading slashes)
TARGET_PATHS="
  org/gnome/desktop/wm/keybindings
  org/gnome/desktop/wm/preferences
  org/gnome/desktop/interface
  org/gnome/settings-daemon/plugins/media-keys
  org/gnome/shell/extensions
"

echo "# GNOME Custom Overrides (Absolute Paths)" > "$BACKUP_FILE"

# Dump the root database and filter it using awk
dconf dump / | awk -v prefixes="$TARGET_PATHS" '
BEGIN {
    # Split our target paths into an array
    split(prefixes, p, " ")
    print_block = 0
}
/^\[.*\]$/ {
    # We hit a new [path] header. Remove the brackets to read the raw path.
    path = substr($0, 2, length($0) - 2)
    print_block = 0
    
    # Check if this path starts with any of our target paths
    for (i in p) {
        if (index(path, p[i]) == 1) {
            print_block = 1
            break
        }
    }
}
# If print_block is active, print the current line
print_block { print }
' >> "$BACKUP_FILE"

echo "Success! Clean, absolute paths saved to $BACKUP_FILE"
