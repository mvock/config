#!/bin/bash
### zsh ###
ln -s ~/.florres/.zshrc ~/.zshrc
mkdir ~/.zsh
mkdir ~/.zsh/antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.zsh/antigen/antigen.zsh

### vim ###
ln -s ~/.florres/.vimrc ~/.vimrc
ln -s ~/.florres/vimfiles ~/.vimfiles
git clone https://github.com/VundleVim/Vundle.vim.git ~/.florres/vimfiles/bundle/Vundle.vim

### gvim ###
ln -s ~/.florres/.gvimrc ~/.gvimrc
cat << EOF
************************************
** To finish installation execute **
** :PluginInstall                 **
** in vim                         **
************************************
