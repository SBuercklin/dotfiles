# Config File Backup
This repo is a collection of config files for various utilities that I would like to easily instantiate on various work machines. 

Config files are stored entirely within this repo, but a `setup-config.sh` script is provided to instantiate these configurations automatically. Instantiation symlinks the config files to `$HOME` and then adds/modifies the existing config files to import the new configs.

## .bashrc
* Sets default editors to Sublime and Vim

## .vimrc

## .tmux.conf
* Sets `<C-a>` to be the prefix
* `<C-a> \` and `<C-a> -` split panes
* `<C-{h,j,k,l}>` navigate between panes
