#!/bin/bash
#
# Re-create my workspace with selected software.
#
# Tested with elementary OS 6.1 Jólnir

set -e

palette1="#121212:#ff005f:#00af5f:#ffd787:#0087ff:#ff00ff:#00d4ff:#e4e4e4"
palette2="#1c1c1c:#ff005f:#00ad5f:#ffd787:#0087ff:#ff00ff:#00d4ff:#00875f"

gsettings set io.elementary.terminal.settings palette "$palette1:$palette2"
gsettings set io.elementary.terminal.settings foreground "#e4e4e4"
gsettings set io.elementary.terminal.settings background "#121212"
gsettings set io.elementary.terminal.settings cursor-color "#e4e4e4"
gsettings set io.elementary.terminal.settings cursor-shape "I-Beam"
gsettings set io.elementary.terminal.settings follow-last-tab "true"
gsettings set io.elementary.terminal.settings theme "custom"

sudo ./install.sh

echo "Restart your computer to finish workspace setup"
notify-send "Restart your computer to finish workspace setup"
