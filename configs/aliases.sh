function install_chrome() {
  # it's huge for image, install only when needed
  curl -Lo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  apt install /tmp/chrome.deb
  rm /tmp/chrome.deb
}

export BAT_PAGER=
alias cat=bat

alias p=python3

alias l=lsd
alias la='lsd -laA'
alias ll='lsd -l'
alias lt='lsd --tree'
alias lst='lsd -l --tree --total-size'

alias wgup='wg-quick up wg0'
alias wgdown='wg-quick down wg0'
