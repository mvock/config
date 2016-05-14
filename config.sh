#!/bin/zsh

here="$(dirname "$(readlink -f $0)")"
there="$HOME"

function create() {
    install-$1
}

function install-zsh() {
    backup-and-link ".zshrc"
    backup "$there/.zsh"

    mkdir -p ~/.zsh/antigen
    curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.zsh/antigen/antigen.zsh
}

function install-vim() {
    backup-and-link ".vimrc"
    backup-and-link ".vim"
    git clone https://github.com/VundleVim/Vundle.vim.git "$there/.vim/bundle/Vundle.vim"
    backup-and-link ".gvimrc"

    vim -c ":PluginInstall"
}

function backup-and-link() {
    link="$there/$1"
    backup $link

    target="$here/$1"

    ln -s "$target" "$link"
}

function backup() {
    old="$1"
    backup="${old}~"

    echo -n "Checking whether $old needs to be backed up... "
    if [ -e $old ]; then
        mv $old $backup
        echo "Yes, moved old $old to $backup"
    else
        echo "No."
    fi
}

create zsh
create vim

#### gvim ###
#if [ -f ~/.gvimrc ];
#then
#   mv ~/.gvimrc ~/.gvimrc.bak
#   echo "moved old .gvimrc to .gvimrc.bak"
#fi
#ln -s ~/.florres/.gvimrc ~/.gvimrc
#cat << EOF
#************************************
#** To finish installation execute **
#** :PluginInstall                 **
#** in vim                         **
#************************************
#EOF
