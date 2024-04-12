#!/bin/bash -e
set -xe
cd /tmp
git config --global core.compression 9

function cu_install() {
  curl https://i.jpillora.com/$1 | bash
}

CPU=$(uname -m)
[[ "$CPU" == "x86_64" ]] && CPU=amd64
[[ "$CPU" == "aarch64" ]] && CPU=arm64

function gh_deb() {
  echo; echo "##### $1 #####"
  curl -s https://api.github.com/repos/$1/releases/latest \
  | grep -m1 "browser_download_url${2:-".*${CPU}.*deb"}" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -O /tmp/pkg.deb -i -
  sudo dpkg -i /tmp/pkg.deb
  rm /tmp/pkg.deb
}

function gh_pull() {
  echo; echo "##### $1 #####"
  if [[ ! -d "$2" ]]; then
    git clone --depth=1 "https://github.com/$1.git" $2
  fi
}

# =============================================================================

curl -fLS install-node.vercel.app/lts | bash -s -- --yes
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
curl -Lo go.tar.gz https://go.dev/dl/go1.22.2.linux-${CPU}.tar.gz
tar -C /usr/local -xzf go.tar.gz
export PATH=$PATH:/usr/local/go/bin

# =============================================================================

cu_install lsd-rs/lsd!
cu_install sharkdp/bat!
cu_install sharkdp/fd!
cu_install noborus/ov!
cu_install mikefarah/yq!
cu_install jpillora/chisel!
cu_install ajeetdsouza/zoxide!
cu_install BurntSushi/ripgrep!?as=rg
gh_pull junegunn/fzf /opt/fzf && /opt/fzf/install
gh_deb httpie/cli '.*deb'

# =============================================================================
export PIPX_HOME=/usr/local/share/pipx
export PIPX_BIN_DIR=/usr/local/bin
export PIPX_MAN_DIR=/usr/local/share/man
pipx install bbrf
pipx install sqlmap
pipx install waymore
go install -v github.com/minio/mc@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/denandz/sourcemapper@latest
gh_pull sqlmapproject/sqlmap /opt/sqlmap
cu_install owasp-amass/amass!
cu_install epi052/feroxbuster!

mkdir /list
cd /list
curl -Lo onelistforallmicro.txt https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallmicro.txt
curl -Lo onelistforallshort.txt https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallshort.txt
curl -Lo SecList.zip https://github.com/danielmiessler/SecLists/archive/master.zip \
  && unzip SecList.zip \
  && rm -f SecList.zip

rm -rf /tmp/*
