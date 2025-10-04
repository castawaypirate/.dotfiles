#!/bin/bash
# Graceful Hyprland exit script

# Close OBS gracefully first
if pgrep -x "obs" > /dev/null; then
    echo "Closing OBS..."
    pkill -TERM obs
    sleep 2
fi

# Close all other windows gracefully
echo "Closing all windows..."
HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
if [ -n "$HYPRCMDS" ]; then
    hyprctl --batch "$HYPRCMDS"
    sleep 1
fi

# Exit Hyprland
echo "Exiting Hyprland..."
hyprctl dispatch exit