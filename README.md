# Workspace setup for elementary OS 6

![screenshot](./screenshot.jpg)

These scripts install different software, return tray icons, clean up in the launcher, configure vim as a simple frontend ide, and add visual settings for the bash and the standard terminal.

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
    - Ruby
    - R
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
    - OpenShot
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
git clone git@github.com:sfi0zy/workspace-setup.git
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

