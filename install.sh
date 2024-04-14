#!/bin/bash -e
set -xe
cd /tmp

# ============================= Install base apts =============================
export DEBIAN_FRONTEND=noninteractive
(echo y;echo y) | unminimize
apt-get -y update
apt-get -y install \
    sudo apt-transport-https ca-certificates \
    zsh binutils gcc cmake build-essential bsdmainutils \
    libpcap-dev libssl-dev libffi-dev libxml2-dev libxml2-utils libxslt1-dev zlib1g-dev libdata-hexdump-perl \
    python3 python3-dev python3-pip python3-virtualenv python3-setuptools \
    net-tools wireguard-tools iproute2 iptables openvpn nmap \
    curl wget xsel urlview vim vim-gtk3 tmux jq \
    zip unzip gzip bzip2 tar unrar \
    dnsutils inetutils-ping whois \
    procps bbe git file \
    ruby pv lynx medusa

sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/zdharma-continuum/fast-syntax-highlighting \
    -p https://github.com/marlonrichert/zsh-autocomplete \
    -x
# =============================================================================

# ============================== Base functions ===============================
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

# ============================= Install go & node =============================
# curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
curl -fLS install-node.vercel.app/lts | bash -s -- --yes
npm -g install yarn

curl -Lo go.tar.gz https://go.dev/dl/go1.22.2.linux-${CPU}.tar.gz
tar -C /usr/local -xzf go.tar.gz
export PATH=$PATH:/usr/local/go/bin
# =============================================================================

# ============================ Install bash tools =============================
mkdir -p /wgcf
curl -fsSL git.io/wgcf.sh | bash

cu_install mikefarah/yq!
cu_install jpillora/chisel!
gh_deb lsd-rs/lsd
gh_deb sharkdp/bat
gh_deb sharkdp/fd
gh_deb noborus/ov
gh_deb ajeetdsouza/zoxide
gh_deb BurntSushi/ripgrep
if [[ "$CPU" == "amd64" ]]; then
  gh_deb httpie/cli '.*deb'
fi

gh_pull junegunn/fzf /opt/fzf && /opt/fzf/install

yarn global add zx pm2 nodemon ngrok http-server torrent \
  tldr fkill vtop pipeable-js iponmap pageres-cli speed-test
# =============================================================================

# ============================ Install Downloaders ============================
cd /tmp
curl -s https://api.github.com/repos/aria2/aria2/releases/latest \
  | grep -m1 "browser_download_url.*tar\\.gz" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -O aria2.tar.gz -i -
tar -xvf aria2.tar.gz
cd $(ls -d aria2-*)
./configure
make install

cd /tmp
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
# =============================================================================

# =========================== Install Google Chrome ===========================
# curl -Lo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# apt install -y /tmp/chrome.deb
# =============================================================================

# =========================== Install Hunter Tools ============================
pip3 install bbrf sqlmap waymore wafw00f xnLinkFinder arjun commix urless xonsh[full]

gh_pull blechschmidt/massdns /tmp/massdns
cd /tmp/massdns
make && make install
cd /tmp

export GOBIN=/usr/local/bin/
go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
HOME=/usr/local pdtm -install-all -duc -bp $GOBIN

go install -v github.com/minio/mc@latest
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/tomnomnom/qsreplace@latest
go install -v github.com/tomnomnom/unfurl@latest
go install -v github.com/tomnomnom/gron@latest
go install -v github.com/tomnomnom/httprobe@latest
go install -v github.com/tomnomnom/meg@latest
go install -v github.com/denandz/sourcemapper@latest
go install -v github.com/s0md3v/smap/cmd/smap@latest
go install -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest
go install -v github.com/d3mondev/puredns/v2@latest # dns with wildcards
go install -v github.com/hahwul/dalfox/v2@latest
go install -v github.com/lc/subjs@latest
go install -v github.com/Josue87/gotator@latest
go install -v github.com/Hackmanit/Web-Cache-Vulnerability-Scanner@latest
go install -v github.com/lobuhi/byp4xx@latest
go install -v github.com/hakluke/hakip2host@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/sa7mon/s3scanner@latest
go install -v github.com/detectify/page-fetch@latest
cu_install epi052/feroxbuster!
cu_install dwisiswant0/ppfuzz!
cu_install owasp-amass/amass!
cu_install trufflesecurity/trufflehog! # repo search for tokens


function ghpy_install() {
  gh_pull $1 $2
  cd $2
  if [ -s "requirements.txt" ]; then
      pip3 install -r requirements.txt
  fi
  if [ -s "setup.py" ]; then
      pip3 install .
  fi
  echo 3: $3
  if [[ ! -z "$3" ]]; then
    echo 3: $3
    NAME=$(echo "$1" | sed -E 's#.*/##' | awk '{print tolower($0)}')
    cat > /usr/local/bin/$NAME <<EOF
#!/usr/bin/env sh
python3 $2/$3 \$@
EOF
    chmod +x /usr/local/bin/$NAME
  fi
  cd -
}
ghpy_install s0md3v/Corsy /opt/Corsy corsy.py # cors issues finder
ghpy_install Tuhinshubhra/CMSeeK /opt/CMSeeK cmseek.py # all cms analysis
ghpy_install r0075h3ll/Oralyzer /opt/Oralyzer oralyzer.py # open-redirect finder
ghpy_install landgrey/pydictor /opt/pydictor pydictor.py # pass-wordlist generator
ghpy_install cramppet/regulator /opt/regulator main.py # pattern domains

# =============================================================================

# ============================== Pull WordLists ===============================
mkdir /list
cd /list
curl -Lo onelistforallmicro.txt https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallmicro.txt
# curl -Lo onelistforallshort.txt https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallshort.txt
# curl -Lo SecList.zip https://github.com/danielmiessler/SecLists/archive/master.zip \
#   && unzip SecList.zip \
#   && rm -f SecList.zip
# =============================================================================

# ============================= Config & Cleanup ==============================
cp -r ~/.oh-my-zsh /opt/omz
yq shell-completion zsh > /opt/omz/custom/plugins/zsh-autocomplete/Completions/_yq
dalfox completion zsh > /opt/omz/custom/plugins/zsh-autocomplete/Completions/_dalfox

go clean -x -cache -modcache
yarn cache clean
pip3 cache purge
apt autoremove
apt autoclean
apt purge
apt clean
rm -rf \
  /root /tmp \
  /usr/local/.cache \
  /usr/local/share/.cache \
  /usr/local/go/pkg/mod \
  /usr/lib/firmware
mkdir -p /root/.local /tmp
chsh -s $(which zsh)
