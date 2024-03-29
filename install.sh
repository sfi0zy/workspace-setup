#!/bin/bash

###############################################################################
#
# This is the installation script. It shows the UI, updates the packages,
# installs the packages from the list and replaces the configuration files.
#
# See also: ./main.sh
#
# Created for the elementary OS 7
#
###############################################################################


set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo" >&2
    exit 1
fi

readonly USER_HOME="/home/${SUDO_USER}"


#######################################
# Check for the available space
# Arguments:
#   None
# Outputs:
#   Error message if fails, to stderr
# Returns:
#   0, if space is available, 1 if not
#######################################
is_space_available() {
    local space_available
    local space_required

    space_available=$(df --output=avail -B 1 . | tail -n 1)
    space_required=$(numfmt --from=iec 25G)

    if (( space_required > space_available )); then
        echo "You need at least 25G of free space to run this." >&2
        return 1
    fi

    return 0
}


#######################################
# Show UI: the welcome message
# Arguments:
#   None
#######################################
say_welcome() {
    whiptail \
        --title "Welcome to workspace setup!" \
        --msgbox \
        "This script will re-create my workspace.\n\n"`
        `"You'll need a stable internet connection to download the software.\n\n"`
        `"Press OK to continue." \
        40 100 3>&1 1>&2 2>&3
}


#######################################
# Show UI: yes/no option about the data backup
# Arguments:
#   None
#######################################
make_sure_backup_is_created() {
    whiptail \
        --title "Are you sure?" \
        --yesno "Did you make the backup of your data?\n" \
        40 100 3>&1 1>&2 2>&3
}


#######################################
# Show UI: the message about the required software
# Arguments:
#   None
#######################################
say_about_required_software() {
    whiptail \
        --title "What to expect?" \
        --msgbox \
        "The following packages will be installed:\n\n"`
        `"Google Chrome\n"`
        `"node.js, n, npm, http-server, ngrok\n"`
        `"vim, shellcheck, some plugins to make it a frontend IDE\n"`
        `"git, gitk\n"`
        `"snapd, curl, build-essential, preload, software-properties-common, inotify-tools\n\n"`
        `"Also:\n"`
        `".bashrc will be replaced (cool prompt + some alias and settings).\n"`
        `"Some 'wtf is this?' icons will be hidden from launcher.\n"`
        `"Visual settings for the terminal will be changed.\n\n"`
        `"You'll be able to select the additional software in the next step." \
        40 100 3>&1 1>&2 2>&3
}


#######################################
# Show UI: the checkboxes for the additional software
# Arguments:
#   None
# Outputs:
#   Writes software list to stdout, names, separated with spaces
#######################################
request_additional_software_list() {
    local additional_software_list

    additional_software_list=$(whiptail \
        --title "What else do you want to install?" \
        --checklist "Use the space to select multiple items." \
        40 100 27 \
        "firefox" "Firefox browser" OFF \
        "edge" "Microsoft Edge (dev)" OFF \
        "skype" "Skype" OFF \
        "telegram" "Telegram" ON \
        "discord" "Discord" OFF \
        "ruby" "Ruby language (ruby-full + ruby-bundler)" ON \
        "vscode" "Visual Studio Code" OFF \
        "docker" "Docker" OFF \
        "libreoffice" "Full LibreOffice" ON \
        "tex" "TeX Live (full) + Gummy" OFF \
        "darktable" "Darktable" ON \
        "gimp" "GIMP" ON \
        "krita" "Krita" OFF \
        "inkscape" "Inkscape" ON \
        "simple-scan" "Simple Scan" OFF \
        "obs" "OBS" OFF \
        "blender" "Blender" OFF \
        "musescore" "Musescore" OFF \
        "audacity" "Audacity" OFF \
        "steam" "Steam" OFF \
        "transmission" "Transmission" ON \
        "vlc" "VLC" ON \
        "openssh-server" "SSH server" OFF \
        --separate-output \
        3>&1 1>&2 2>&3)

    echo "${additional_software_list}"
}


#######################################
# Update everything
# Arguments:
#   None
#######################################
update_everything() {
    sudo apt-get update
    sudo apt-get -y upgrade
}


#######################################
# Install system utils
# Arguments:
#   None
#######################################
install_system_utils() {
    sudo apt-get install -y software-properties-common
    sudo apt-get install -y curl
    sudo apt-get install -y preload
    sudo apt-get install -y snapd
    sudo apt-get install -y inotify-tools
    sudo apt-get install -y build-essential
}


#######################################
# Install git
# Arguments:
#   None
#######################################
install_git() {
    sudo apt-get install -y git
    sudo apt-get install -y gitk
}


#######################################
# Install Google Chrome
# Arguments:
#   None
#######################################
install_google_chrome() {
    local url="https://dl.google.com/linux/direct"
    local package="google-chrome-stable_current_amd64.deb"

    wget -q "${url}/${package}"
    sudo apt-get install -y "./${package}"
}


#######################################
# Install Mozilla Firefox
# Arguments:
#   None
#######################################
install_firefox() {
    sudo apt-get install -y firefox
}


#######################################
# Install Microsoft Edge
# Arguments:
#   None
#######################################
install_edge() {
    local repo="https://packages.microsoft.com/repos/edge"
    local key_url="https://packages.microsoft.com/keys/microsoft.asc"
    local key="microsoft.gpg"
    local kpath="/usr/share/keyrings"
    local info="deb [arch=amd64 signed-by=${kpath}/${key}] ${repo} stable main"
    local sources_list_file="/etc/apt/sources.list.d/microsoft-edge-dev.list"

    curl -s $key_url | gpg --dearmor > $key
    sudo install -o root -g root -m 644 $key $kpath
    sudo sh -c "echo \"${info}\" > ${sources_list_file}"
    sudo apt-get update
    sudo apt-get install -y microsoft-edge-dev
}


#######################################
# Install Skype
# Arguments:
#   None
#######################################
install_skype() {
    local url="https://go.skype.com"
    local package="skypeforlinux-64.deb"

    wget -q "${url}/${package}"
    sudo apt-get install -y "./${package}"
}


#######################################
# Install Telegram Desktop
# Globals:
#   SUDO_USER
#   USER_HOME
# Arguments:
#   None
#######################################
install_telegram() {
    local desktop_file="telegram-desktop_telegram-desktop.desktop"
    local applications=".local/share/applications"

    # There is a telegram-desktop package in the official repository,
    # but is's almost always outdated and sometimes it works in strange ways.
    # Snap package is much more stable.
    sudo snap install telegram-desktop

    # We change the desktop files to keep the icon in the dock
    # after the automatic updates
    sudo -u "${SUDO_USER}" \
        cp "/var/lib/snapd/desktop/applications/${desktop_file}" \
            "${USER_HOME}/${applications}/"
    sudo -u "${SUDO_USER}" \
        sed -i 's/telegram-desktop\/[0-9]\+\//telegram-desktop\/current\//g' \
            "${USER_HOME}/${applications}/${desktop_file}"
    sudo -u "${SUDO_USER}" touch "${USER_HOME}/${applications}/mimeapps.list"

    echo "[Default Applications]" \
        | sudo -u "${SUDO_USER}" \
            tee -a "${USER_HOME}/${applications}/mimeapps.list"

    echo "x-scheme-handler/tg=${desktop_file}" \
        | sudo -u "${SUDO_USER}" \
            tee -a "${USER_HOME}/${applications}/mimeapps.list"
}


#######################################
# Install Discord
# Arguments:
#   None
#######################################
install_discord() {
    # It doesn't have a direct link to the *.deb
    local url="https://discord.com/api/download?platform=linux&format=deb"
    local package="discord.deb"

    wget -q -O "./$package" "${url}"
    sudo apt-get install -y "./$package"
}


#######################################
# Install VIM with frontend tools
# Globals:
#   SUDO_USER
#   USER_HOME
# Arguments:
#   None
#######################################
install_vim() {
    local from="https://github.com"
    local to="${USER_HOME}/.vim/bundle"
    local raw_from="https://raw.githubusercontent.com"
    local colors_dir="${USER_HOME}/.vim/colors"
    local theme="atlantic-dark"

    sudo apt-get install -y vim
    sudo apt-get install -y shellcheck

    sudo -u "${SUDO_USER}" rm -rf "${USER_HOME}/.vim/autoload/"
    sudo -u "${SUDO_USER}" mkdir -p "${USER_HOME}/.vim/autoload"
    sudo -u "${SUDO_USER}" rm -rf "${USER_HOME}/.vim/bundle/"
    sudo -u "${SUDO_USER}" mkdir -p "${USER_HOME}/.vim/bundle"
    sudo -u "${SUDO_USER}" \
        curl -LSso "${USER_HOME}/.vim/autoload/pathogen.vim" \
            https://tpo.pe/pathogen.vim

    sudo -u "${SUDO_USER}" git clone \
        "${from}/editorconfig/editorconfig-vim.git" \
        "${to}/editorconfig-vim"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/mattn/emmet-vim.git" \
        "${to}/emmet-vim"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/scrooloose/nerdtree.git" \
        "${to}/nerdtree"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/Yggdroot/indentLine.git" \
        "${to}/indentLine"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/terryma/vim-multiple-cursors.git" \
        "${to}/vim-multiple-cursors"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/vim-airline/vim-airline.git" \
        "${to}/vim-airline"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/vim-airline/vim-airline-themes.git" \
        "${to}/vim-airline-themes"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/pangloss/vim-javascript.git" \
        "${to}/vim-javascript"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/groenewege/vim-less.git" \
        "${to}/vim-less"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/digitaltoad/vim-pug.git" \
        "${to}/vim-pug"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/tpope/vim-liquid.git" \
        "${to}/vim-liquid"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/tikhomirov/vim-glsl.git" \
        "${to}/vim-glsl"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/dense-analysis/ale.git" \
        "${to}/ale"
    sudo -u "${SUDO_USER}" git clone \
        "${from}/APZelos/blamer.nvim.git" \
        "${to}/blamer.nvim"
    sudo -u "${SUDO_USER}" git clone -b release \
        "${from}/neoclide/coc.nvim.git" \
        "${to}/coc.nvim"

    sudo -u "${SUDO_USER}" rm -rf "${colors_dir}"
    sudo -u "${SUDO_USER}" mkdir -p "${colors_dir}"
    sudo -u "${SUDO_USER}" wget -q \
        "${raw_from}/sfi0zy/${theme}.vim/master/colors/${theme}.vim" \
        -P "${colors_dir}"

    sudo -u "${SUDO_USER}" cp ./dotfiles/vimrc "${USER_HOME}/.vimrc"
    sudo -u "${SUDO_USER}" cp ./dotfiles/coc-settings.json \
        "${USER_HOME}/.vim/coc-settings.json"
}


#######################################
# Install Node.js with tools
# Arguments:
#   None
#######################################
install_node() {
    sudo apt-get install -y nodejs npm
    sudo npm install -g n
    sudo n latest

    # http-server and ngrok are used in .bashrc to create the server
    # one-liners called serve-this-directory and share-this-directory.
    sudo npm i -g http-server
    sudo npm i -g ngrok
}


#######################################
# Install Ruby
# Arguments:
#   None
#######################################
install_ruby() {
    sudo apt-get install -y ruby-full
    sudo apt-get install -y ruby-bundler
}


#######################################
# Install Visual Studio Code
# Arguments:
#   None
#######################################
install_vscode() {
    sudo snap install --classic code
}


#######################################
# Install Docker
# Arguments:
#   None
#######################################
install_docker() {
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}


#######################################
# Install LibreOffice
# Arguments:
#   None
#######################################
install_libreoffice() {
    sudo apt-get install -y libreoffice
    sudo sed -i 's/^NoDisplay=false/NoDisplay=true/' \
        /usr/share/applications/libreoffice-startcenter.desktop
}


#######################################
# Install TeX
# Arguments:
#   None
#######################################
install_tex() {
    # We install texlive-full to get the ability to open every *.tex document
    # and it will be compiled. We don't need to think. It just works.
    sudo apt-get install -y texlive-full
    sudo apt-get install -y gummi
}


#######################################
# Install Darktable
# Arguments:
#   None
#######################################
install_darktable() {
    # The darktable version in the standard repository is really outdated.
    # We install the latest possible version for the ubuntu 22.04.
    local url="http://download.opensuse.org/repositories"
    local repo_url="${url}/graphics:/darktable/xUbuntu_22.04"

    echo "deb ${repo_url}/ /" \
        | sudo tee /etc/apt/sources.list.d/graphics:darktable.list
    curl -fsSL "${repo_url}/Release.key" \
        | gpg --dearmor \
        | sudo tee /etc/apt/trusted.gpg.d/graphics_darktable.gpg > /dev/null
    sudo apt-get update
    sudo apt-get install -y darktable
}


#######################################
# Install Gimp
# Arguments:
#   None
#######################################
install_gimp() {
    sudo apt-get install -y gimp
}


#######################################
# Install Krita
# Arguments:
#   None
#######################################
install_krita() {
    sudo apt-get install -y krita
}


#######################################
# Install Inkscape
# Arguments:
#   None
#######################################
install_inkscape() {
    # Inkscape package in the ubuntu repository is very outdated.
    # It's always better to have the newest one.
    sudo add-apt-repository -y ppa:inkscape.dev/stable
    sudo apt-get install -y inkscape
}


#######################################
# Install Simple Scan
# Arguments:
#   None
#######################################
install_simple_scan() {
    sudo apt-get install -y simple-scan
}


#######################################
# Install OBS
# Arguments:
#   None
#######################################
install_obs() {
    sudo apt-get install -y ffmpeg v4l2loopback-dkms
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt-get update
    sudo apt-get install -y obs-studio
}


#######################################
# Install Blender
# Arguments:
#   None
#######################################
install_blender() {
    sudo apt-get install -y blender
}


#######################################
# Install Musescore
# Arguments:
#   None
#######################################
install_musescore() {
    sudo add-apt-repository -y ppa:mscore-ubuntu/mscore3-stable
    sudo apt-get update
    sudo apt-get install -y musescore3
}


#######################################
# Install Audacity
# Arguments:
#   None
#######################################
install_audacity() {
    sudo apt-get install -y audacity
}


#######################################
# Install Steam + required i386 architecture
# Arguments:
#   None
#######################################
install_steam() {
    # Steam requires another architecture. So we are going to multiverse.
    yes | sudo dpkg --add-architecture i386
    sudo add-apt-repository -y multiverse
    sudo apt-get update
    sudo apt-get install -y steam
}


#######################################
# Install Transmission
# Arguments:
#   None
#######################################
install_transmission() {
    sudo apt-get install -y transmission
}


#######################################
# Install VLC
# Arguments:
#   None
#######################################
install_vlc() {
  sudo apt-get install -y vlc
}


#######################################
# Install SSH server
# Arguments:
#   None
#######################################
install_ssh_server() {
  sudo apt-get install -y openssh-server
}

#######################################
# Install software based on the software list
# Arguments:
#   Software list, names, separated with spaces
#######################################
install_software() {
    local software_list=("$@")
    local software

    for software in "${software_list[@]}"; do
        case "${software}" in
            "system-utils") install_system_utils ;;
            "git") install_git ;;
            "google-chrome") install_google_chrome ;;
            "firefox") install_firefox ;;
            "edge") install_edge ;;
            "skype") install_skype ;;
            "telegram") install_telegram ;;
            "discord") install_discord ;;
            "vim") install_vim ;;
            "node") install_node ;;
            "ruby") install_ruby ;;
            "vscode") install_vscode ;;
            "docker") install_docker ;;
            "libreoffice") install_libreoffice ;;
            "tex") install_tex ;;
            "darktable") install_darktable ;;
            "gimp") install_gimp ;;
            "krita") install_krita ;;
            "inkscape") install_inkscape ;;
            "simple-scan") install_simple_scan ;;
            "obs") install_obs ;;
            "blender") install_blender ;;
            "musescore") install_musescore ;;
            "audacity") install_audacity ;;
            "steam") install_steam ;;
            "transmission") install_transmission ;;
            "vlc") install_vlc ;;
            "openssh-server") install_ssh_server ;;
        esac
    done
}


#######################################
# Remove unnecessary items from launcher
# Arguments:
#   None
#######################################
clean_launcher() {
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/debian-xterm.desktop
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/debian-uxterm.desktop
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/display-im6.q16.desktop
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/org.pwmt.zathura.desktop
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/xpdf.desktop
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/vprerex.desktop
    echo 'NoDisplay=true' \
        | sudo tee -a /usr/share/applications/org.fcitx.Fcitx5.desktop
}


#######################################
# Replace .bashrc for user
# Globals:
#   SUDO_USER
#   USER_HOME
# Arguments:
#   None
#######################################
replace_bashrc() {
    sudo -u "${SUDO_USER}" cp "${USER_HOME}/.bashrc" \
        "${USER_HOME}/.bashrc-original"
    sudo -u "${SUDO_USER}" rm "${USER_HOME}/.bashrc"
    sudo -u "${SUDO_USER}" cp ./dotfiles/bashrc "${USER_HOME}/.bashrc"
}


#######################################
# Start the installation
# Arguments:
#   None
#######################################
main() {
    local space_check_result
    local required_list
    local additional_list
    local all_software_list

    space_check_result=$(is_space_available)

    if [[ "${space_check_result}" -ne "0" ]]; then
        return 1
    fi

    say_welcome
    make_sure_backup_is_created
    say_about_required_software

    required_list="system-utils git node vim google-chrome"
    additional_list=$(request_additional_software_list)
    all_software_list="${required_list} ${additional_list}"

    update_everything
    # shellcheck disable=2086
    install_software $all_software_list

    clean_launcher
    replace_bashrc
}


main
