#!/bin/zsh

here="$(dirname "$(readlink -f $0)")"
there="$HOME"

typeset -A files
files_vim=(.vimrc .vim .gvimrc)
files_zsh=(.zshrc)
files_x=(.xmobarrc .Xresources .xsession .xmonad)

function create() {
	files="files_$1"
	for file in ${(P)files}; do
		backup-and-link "$file";
	done

    install-$1
}

function install-zsh() {
    backup "$there/.zsh"
    mkdir -p ~/.zsh/antigen
    curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh > ~/.zsh/antigen/antigen.zsh
}

function install-vim() { }

function install-x() { }

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
create x
