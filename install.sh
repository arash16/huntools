#!/bin/bash -e
set -xe
cd /tmp
git config --global core.compression 9
export DEBIAN_FRONTEND=noninteractive

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

function gh_install() {
  gh_pull $1 $2
  cd $2
  if [ -s "requirements.txt" ]; then
      pip3 install -r requirements.txt --break-system-packages
  fi
  if [ -s "setup.py" ]; then
      pip3 install . --break-system-packages
  fi
  cd -
}

# =============================================================================

# curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
curl -fLS install-node.vercel.app/lts | bash -s -- --yes
curl -Lo go.tar.gz https://go.dev/dl/go1.22.2.linux-${CPU}.tar.gz
tar -C /usr/local -xzf go.tar.gz
export PATH=$PATH:/usr/local/go/bin
# =============================================================================

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

# =============================================================================

curl -Lo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y /tmp/chrome.deb

# =============================================================================

pip3 install bbrf sqlmap waymore wafw00f xnLinkFinder arjun commix urless
pip3 install git+https://github.com/Tuhinshubhra/CMSeeK.git

# gh_install Tuhinshubhra/CMSeeK /opt/CMSeeK
# pipx install git+https://github.com/s0md3v/Corsy.git
# pipx install git+https://github.com/r0075h3ll/Oralyzer.git
# pipx install git+https://github.com/Tuhinshubhra/CMSeeK.git
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

# =============================================================================



# =============================================================================

mkdir /list
cd /list
curl -Lo onelistforallmicro.txt https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallmicro.txt
# curl -Lo onelistforallshort.txt https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallshort.txt
# curl -Lo SecList.zip https://github.com/danielmiessler/SecLists/archive/master.zip \
#   && unzip SecList.zip \
#   && rm -f SecList.zip

cp -r ~/.oh-my-zsh /opt/omz
yq shell-completion zsh > /opt/omz/custom/plugins/zsh-autocomplete/Completions/_yq
dalfox completion zsh > /opt/omz/custom/plugins/zsh-autocomplete/Completions/_dalfox

rm -rf /root /tmp
mkdir -p /root/.local /tmp
chsh -s $(which zsh)
