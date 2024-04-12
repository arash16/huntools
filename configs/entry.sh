#!/bin/bash -e

[[ ! -f ~/.zshrc ]] && cp /opt/configs/.zshrc ~/

/opt/configs/wgcf-init.sh

[[ -f ~/.init.sh ]] && ~/.init.sh

###########################################################

if [[ ! -z "$1" ]]; then
  # usage for normal docker run
  exec $@
else
  # usage to execute inside k8s/compose
  echo Ready to be attached to
  sleep infinity
fi
