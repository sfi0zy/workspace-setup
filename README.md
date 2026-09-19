# Workspace setup for elementary OS 7

These scripts install various software, clean up in the launcher, configure vim as a frontend IDE, and add some visual settings for terminal.

## Install

Before you start:

### WARNINGS

1. These scripts can install a lot of packages, so you'll need around 20-25G to install everything.

2. **BACKUP YOUR DATA**.

3. You'll need some time and a stable internet connection.

### How to use it

Download this repository as an archive, extract it and start the process.

```sh
cd /tmp
wget https://github.com/sfi0zy/workspace-setup/archive/refs/heads/elementary-os-7.zip
unzip elementary-os-7.zip
cd workspace-setup-elementary-os-7
./main.sh
```

You'll be asked for a password (for sudo). Then minimal GUI will help you select software to install.

Some software will be installed by default:

- Google Chrome
- git, gitk
- node.js, npm, n, http-server
- vim (configured as a frontend IDE) + shellcheck
- software-properties-common, curl, snapd, preload, inotify-tools, build-essential

You'll be able to choose additional software from the list:

- Web:
    - Mozilla Firefox
- Writing tools:
    - LibreOffice
    - Gummi + LaTeX
- Tools for creators:
    - Darktable
    - GIMP
    - Inkscape
    - SimpleScan
    - OBS
    - Blender
    - MuseScore
    - Audacity
- Others:
    - draw.io
    - Transmission
    - VLC

Installation takes some time. Then you'll need to restart your computer.


## Useful links

**elementary OS website:**

https://elementary.io/

**First time Git setup:**

https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup

**How to generate SSH keys and add them to GitHub account:**

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent


## Troubleshooting

**CoC breaks Vim**

We have a slightly outdated version of vim here. CoC upgrades will cause problems at some moment. The easiest way to solve this is by getting back in time. We will lose some of the fancy modern features, but vim will be much more stable:

```sh
cd ~/.vim/bundle/coc.nvim
git checkout master
git checkout -b v0.0.82 7a50d4d
npm i
npm run build
```

## License

MIT License

Copyright (c) 2025 Ivan Bogachev sfi0zy@gmail.com
