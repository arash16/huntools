FROM ubuntu:24.04

RUN apt-get -y update
RUN apt-get -y install \
  sudo apt-transport-https \
  zsh binutils gcc cmake build-essential bsdmainutils \
  libpcap-dev libssl-dev libffi-dev libxml2-dev libxml2-utils libxslt1-dev zlib1g-dev libdata-hexdump-perl \
  python3 python3-dev python3-pip python3-virtualenv python3-setuptools pipx \
  ca-certificates curl wget xsel urlview vim vim-gtk3 tmux jq \
  net-tools wireguard-tools iproute2 iptables openvpn nmap \
  dnsutils inetutils-ping whois \
  procps bbe git file \
  zip unzip gzip bzip2 tar unrar \
  ruby pv lynx xvfb medusa chromium-browser chromium \
  && apt-get clean

RUN git config --global core.compression 9 \
  && sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/zdharma-continuum/fast-syntax-highlighting \
    -p https://github.com/marlonrichert/zsh-autocomplete \
    -x

COPY install.sh /tmp/install.sh
RUN /tmp/install.sh

COPY configs /opt/configs
ENTRYPOINT ["/opt/configs/entry.sh"]
