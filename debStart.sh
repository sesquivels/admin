#!/bin/bash

function debStart() {
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim mc zsh cifs-utils nfs-common
    ohmyzsh
    zerotier
}

function zerotier(){
   curl -s https://install.zerotier.com | sudo bash
   sudo zerotier-cli info
   sudo zerotier-cli join e4da7455b28c8c49
}

function ohmyzsh(){
    git clone https://github.com/sesquivels/dotfiles
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cd dotfiles
    mv zshrcPatience ~/.zshrc
}

#=============================
#---------Main Program--------
#=============================
#este llama a todos
debStart
