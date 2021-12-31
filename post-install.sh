#!/bin/bash

# change the default settings for the terminal

gsettings set io.elementary.terminal.settings palette         "#121212:#ff005f:#00af5f:#ffd787:#0087ff:#ff005f:#0087ff:#e4e4e4:#1c1c1c:#ff005f:#00ad5f:#ffd787:#0087ff:#ff005f:#0087ff:#00875f"
gsettings set io.elementary.terminal.settings foreground      "#e4e4e4"
gsettings set io.elementary.terminal.settings background      "#121212"
gsettings set io.elementary.terminal.settings cursor-color    "#e4e4e4"
gsettings set io.elementary.terminal.settings cursor-shape    "I-Beam"
gsettings set io.elementary.terminal.settings follow-last-tab "true"

# add icons to tray

mkdir -p ~/.config/autostart
cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/
sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop

# add telegram (snap package) to the launcher

cp /var/lib/snapd/desktop/applications/telegram-desktop_telegram-desktop.desktop ~/.local/share/applications/
sed -i 's/telegram-desktop\/[0-9]\+\//telegram-desktop\/current\//g' ~/.local/share/applications/telegram-desktop_telegram-desktop.desktop

touch ~/.local/share/applications/mimeapps.list
echo '[Default Applications]' >> ~/.local/share/applications/mimeapps.list
echo 'x-scheme-handler/tg=telegram-desktop_telegram-desktop.desktop' >> ~/.local/share/applications/mimeapps.list

# configure vim as a simple frontend ide

mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/editorconfig/editorconfig-vim.git  ~/.vim/bundle/editorconfig-vim
git clone https://github.com/mattn/emmet-vim.git                ~/.vim/bundle/emmet-vim
git clone https://github.com/scrooloose/nerdtree.git            ~/.vim/bundle/nerdtree
git clone https://github.com/vim-syntastic/syntastic.git        ~/.vim/bundle/syntastic
git clone https://github.com/Yggdroot/indentLine.git            ~/.vim/bundle/indentLine
git clone https://github.com/terryma/vim-multiple-cursors.git   ~/.vim/bundle/vim-multiple-cursors
git clone https://github.com/vim-airline/vim-airline.git        ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes.git ~/.vim/bundle/vim-airline-themes
git clone https://github.com/pangloss/vim-javascript.git        ~/.vim/bundle/vim-javascript
git clone https://github.com/groenewege/vim-less.git            ~/.vim/bundle/vim-less
git clone https://github.com/digitaltoad/vim-pug.git            ~/.vim/bundle/vim-pug
git clone https://github.com/tpope/vim-liquid.git               ~/.vim/bundle/vim-liquid
git clone https://github.com/tikhomirov/vim-glsl.git            ~/.vim/bundle/vim-glsl

mkdir -p ~/.vim/colors
mkdir -p ~/.vim/colors/tmp
git clone git@github.com:sfi0zy/atlantic-dark.vim.git ~/.vim/colors/tmp
cp ~/.vim/colors/tmp/colors/atlantic-dark.vim ~/.vim/colors
rm -rf ~/.vim/colors/tmp/

cp ./dotfiles/vimrc ~/.vimrc

# replace bashrc

cp ~/.bashrc ~/.bashrc-original
rm ~/.bashrc
cp ./dotfiles/bashrc ~/.bashrc

source ~/.bashrc

printf "\n\n\nYOUR WORKSPACE IS READY. SET UP YOUR SSH KEYS AND RESTART THE COMPUTER.\n\n\n";

