#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

############################################
#
# Importing my .bashrc: .bashrc-sam
#
############################################

SOURCE_BASHRC="\. \$HOME/.bashrc-sam"
DIR_BASHRC="$HOME/.bashrc"

# Symlink the .bashrc-sam file into the $HOME dir
if [ ! -f $HOME/.bashrc-sam ]; then
    echo "symlinking .bashrc-sam into $HOME"
    ln -s $SCRIPT_DIR/.bashrc-sam $HOME/
fi

# If we haven't added the source command to the .bashrc, add it
if ! grep -q "$SOURCE_BASHRC" "$DIR_BASHRC"; then
    echo "Adding source command for .bashrc-sam"

    # Thic cat command needs tabs to indent, but vim is set to use spaces.
    # So I'm just going to use spaces and lose the alignment
    cat >> $HOME/.bashrc<< EOF
if [ -f \$HOME/.bashrc-sam ]; then
    . \$HOME/.bashrc-sam
fi
EOF
fi

echo "Sourcing .bashrc"
. $HOME/.bashrc

############################################
#
# Importing my .vimrc: .vimrc-sam
#
############################################

LOAD_VIMRC="so $HOME/.vimrc-sam"
DIR_VIMRC="$HOME/.vimrc"

# If it's a clean install with no .vimrc, make one
if [ ! -f $HOME/.vimrc ]; then
    touch $HOME/.vimrc
fi

# Symlink the .vimrc-sam file into the $HOME dir
if [ ! -f $HOME/.vimrc-sam ]; then
    echo "symlinking .vimrc-sam into $HOME"
    ln -s $SCRIPT_DIR/.vimrc-sam $HOME/
fi

# If we haven't added the so command to the .vimrc, add it
if ! grep -q "$LOAD_VIMRC" "$DIR_VIMRC"; then
    echo "Adding so command for .vimrc-sam"
    echo $LOAD_VIMRC >> $HOME/.vimrc
fi

############################################
#
# Importing my .tmux.conf: .tmux.conf-sam
#
############################################

SOURCE_TMUX="source $HOME/.tmux.conf-sam"
DIR_TMUX="$HOME/.tmux.conf"

# If it's a clean install with no .vimrc, make one
if [ ! -f $HOME/.tmux.conf ]; then
    touch $HOME/.tmux.conf
fi

# Symlink the .tmux.conf-sam file into the $HOME dir
if [ ! -f $HOME/.tmux.conf-sam ]; then
    echo "symlinking .tmux.conf-sam into $HOME"
    ln -s $SCRIPT_DIR/.tmux.conf-sam $HOME/
fi

# If we haven't added the so command to the .tmux.conf, add it
if ! grep -q "$SOURCE_TMUX" "$DIR_TMUX"; then
    echo "Adding source command for .tmux.conf-sam"
    echo "source $HOME/.tmux.conf-sam" >> $HOME/.tmux.conf
fi

