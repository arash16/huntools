#!/bin/bash -e

cd
CONFIGS=/opt/configs

function gh_pull() {
  echo; echo "##### $1 #####"
  if [[ ! -d "$2" ]]; then
    git clone --depth=1 "https://github.com/$1.git" $2
  fi
}

########## No auto-checks ##########
pdtm -duc

############ Config zsh ############
if [[ ! -f "$HOME/.zshrc" ]]; then
  cp $CONFIGS/.zshrc $HOME/
fi

############ Config lsd ############
if [[ ! -f "$HOME/.config/lsd/config.yaml" ]]; then
  mkdir -p $HOME/.config/lsd/
  cp -f $CONFIGS/lsd-config.yaml $HOME/.config/lsd/config.yaml
fi

########## Configure vim ##########
if [[ ! -f "$HOME/.vimrc" ]]; then
  gh_pull "VundleVim/Vundle.vim" "$HOME/.vim/bundle/Vundle.vim"
  cp -f $CONFIGS/.vimrc $HOME/
  vim +PluginInstall +qall
fi

######### Configure tmux ##########
if [[ ! -f "$HOME/.tmux" ]]; then
  gh_pull "gpakosz/.tmux" "$HOME/.tmux"
  gh_pull "tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
  ln -s -f .tmux/.tmux.conf
  cp -f $CONFIGS/.tmux.conf.local $HOME/
  tmux start-server
  tmux new-session -d
  sleep 1
  $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
  tmux kill-server
fi

######### Configure wgcf ##########
$CONFIGS/wgcf-init.sh

######## Any user config ##########
[[ -f $HOME/.init.sh ]] && $HOME/.init.sh

###########################################################

if [[ ! -z "$1" ]]; then
  # usage for normal docker run
  exec $@
else
  # usage to execute inside k8s/compose
  echo Ready to be attached to
  sleep infinity
fi
