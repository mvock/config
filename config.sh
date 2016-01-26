#!/bin/bash
### zsh ###
if [ -f ~/.zshrc ];
then
   mv ~/.zshrc ~/.zshrc.bak
   echo "moved old .zshrc to .zshrc.bak"
fi

ln -s ~/.florres/.zshrc ~/.zshrc

if [ -d ~/.zsh ];
then
   mv ~/.zsh ~/.zsh.bak
   echo "moved folder .zsh to .zsh.bak"
fi

mkdir ~/.zsh
mkdir ~/.zsh/antigen

curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.zsh/antigen/antigen.zsh

### vim ###
if [ -f ~/.vimrc ];
then
   mv ~/.vimrc ~/.vimrc.bak
   echo "moved old .vimrc to .vimrc.bak"
fi

ln -s ~/.florres/.vimrc ~/.vimrc

if [ -d ~/.vimfiles ];
then
   mv ~/.vimfiles ~/.vimfiles.bak
   echo "moved folder .vimfiles to .vimfiles.bak"
fi

ln -s ~/.florres/vimfiles ~/.vimfiles

if [ -d ~/.florres/vimfiles/bundle/Vundle.vim ];
then
    cd ~/.florres/vimfiles/bundle/Vundle.vim 
    git pull -r
else
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.florres/vimfiles/bundle/Vundle.vim
fi

### gvim ###
if [ -f ~/.gvimrc ];
then
   mv ~/.gvimrc ~/.gvimrc.bak
   echo "moved old .gvimrc to .gvimrc.bak"
fi
ln -s ~/.florres/.gvimrc ~/.gvimrc
cat << EOF
************************************
** To finish installation execute **
** :PluginInstall                 **
** in vim                         **
************************************
EOF
