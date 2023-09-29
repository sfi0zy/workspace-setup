# Workspace setup for elementary OS 7

These scripts install different software, clean up in the launcher, configure the vim as a simple frontend ide, and add visual settings for the terminal.

![](./screenshot.jpg)


## Install

Before you start:

### WARNINGS

1. These scripts can install a lot of packages, texlive-full included, so you will need around 25G to install everything. It's not a problem for modern SSD, but remember about that if you want to install this configuration on some old laptop. You'll be able to choose the programs to install.

2. **BACKUP YOUR DATA**. These scripts were designed for usage inside the fresh system without any modifications of it. They don't have protections from your thoughtless actions.

3. You'll need some time and a stable internet connection.

### How to use it

It'll be a good idea to update everything in advance. The fresh system can have hundreds of outdated packages and this process will probably take some time. If you want to play with this setup in a virtual machine, you may also want to take a snapshot of its state after that.

```sh
sudo apt update
sudo apt upgrade
```

Then download this repository as an archive, extract it and start the process.

```sh
cd /tmp
wget https://github.com/sfi0zy/workspace-setup/archive/refs/heads/elementary-os-7.zip
unzip elementary-os-7.zip
cd workspace-setup-elementary-os-7
./main.sh
```

You'll be asked for a password (for sudo).

Then minimal gui will show some additional information.

This software will be prepared to install:

- Google Chrome
- Git, Gitk
- NodeJS, NPM, n, some global npm packages (server one-liners)
- VIM (configured as a frontend IDE) + ShellCheck
- software-properties-common, curl, snapd, preload, inotify-tools, build-essential

The additional packages, required by different software will be also installed without any additional questions.

Then minimal gui will help you to select the additional software from the list:

- Web:
    - Mozilla Firefox
    - Microsoft Edge (dev)
    - Skype
    - Telegram
    - Discord
- Development:
    - Visual Studio Code
    - Ruby
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
    - openssh-server

Installation will take some time. Then restart your computer, add SSH keys if needed, log in into your web accounts and you're ready.


## Useful links

**elementary OS website:**

https://elementary.io/

**First time Git setup:**

https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup

**How to generate SSH keys and add them to GitHub account:**

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent


## License

MIT License

Copyright (c) 2023 Ivan Bogachev sfi0zy@gmail.com
