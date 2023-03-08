#!/bin/bash

###############################################################################
#
# Re-create my workspace with the selected software.
#
# Created for the elementary OS 7
#
###############################################################################


set -e


#######################################
# Set the visual setings for the terminal
# Arguments:
#   None
#######################################
set_terminal_visual_settings() {
    palette1="#121212:#ff005f:#00af5f:#ffd787:#0087ff:#ff00ff:#00d4ff:#e4e4e4"
    palette2="#1c1c1c:#ff005f:#00ad5f:#ffd787:#0087ff:#ff00ff:#00d4ff:#00875f"

    gsettings set io.elementary.terminal.settings palette "$palette1:$palette2"
    gsettings set io.elementary.terminal.settings foreground "#e4e4e4"
    gsettings set io.elementary.terminal.settings background "#121212"
    gsettings set io.elementary.terminal.settings cursor-color "#e4e4e4"
    gsettings set io.elementary.terminal.settings cursor-shape "I-Beam"
    gsettings set io.elementary.terminal.settings follow-last-tab "true"
    gsettings set io.elementary.terminal.settings theme "custom"
}


#######################################
# Run the installation
# Arguments:
#   None
#######################################
# shellcheck disable=2181
main() {
    sudo ./install.sh

    if [[ $? -ne 0 ]]; then
        echo "Something gone wrong. Check the log above."
        exit 1
    fi

    set_terminal_visual_settings

    echo "Restart your computer to finish workspace setup"
    notify-send "Restart your computer to finish workspace setup"
}


main
