# Workspace setup for elementary OS 6

![screenshot](./screenshot.jpg)

These scripts install different software, return tray icons, clean up in the launcher, configure vim as a simple frontend ide, and add visual settings for the bash and the standard terminal.

## WARNINGS

1. These scripts will install a lot of packages, texlive-full included, so you will need some space for all of them. If you have an empty modern SSD for 128GB, you will not notice that, but don't try to run these scripts on the old 16GB HDD or in a virtual machine with a small virtual drive.

2. **BACKUP YOUR DATA**. These scripts were designed for usage inside the fresh system without any modifications of it. They don't have protections from your thoughtless actions.

## List or the software

- Web:
    - Google Chrome
    - Mozilla Firefox
    - Skype
    - Slack
    - Telegram
- Development:
    - Git, Gitk
    - VIM (configured as a frontend IDE)
    - NodeJS + NPM + n + some global packages (server one-liners)
    - R + Tidyverse
    - Ruby
    - Docker
    - VirtualBox
- Writing tools:
    - LibreOffice
    - Gummi + full LaTeX
- Tools for creators:
    - Darktable
    - GIMP
    - Inkscape
    - SimpleScan
    - OBS
    - Blender
    - MuseScore
    - Audacity
- Games:
    - Steam
- Others:
    - Transmission
    - VLC
- System:
    - software-properties-common, curl, snapd, preload
    - some additional packages, required by different software

## Install

```sh
cd /tmp
git clone https://github.com/sfi0zy/workspace-setup.git
# or download the archived repository and extract it
cd workspace-setup
chmod +x ./install.sh
chmod +x ./post-install.sh

# this will install software
sudo ./install.sh

# this will download files to home directory, no sudo here!
./post-install.sh
```

After install and post-install scripts add SSH keys, log in into your accounts, and restart the computer.

## Useful links

https://elementary.io/

https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## License

MIT License

Copyright (c) 2022 Ivan Bogachev sfi0zy@gmail.com

