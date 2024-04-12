FROM ubuntu:24.04

RUN apt-get -y update
RUN apt-get -y install \
  sudo zsh binutils cmake build-essential libpcap-dev \
  python3-dev python3-pip python3-setuptools \
  ca-certificates curl wget xsel urlview vim vim-gtk3 tmux jq \
  net-tools wireguard-tools iproute2 iptables openvpn nmap \
  procps bbe git file \
  zip unzip gzip bzip2 tar unrar \
  dnsutils inetutils-ping \
  && apt-get clean

# minio

RUN git config --global core.compression 9
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
  -p https://github.com/zsh-users/zsh-autosuggestions \
  -p https://github.com/zdharma-continuum/fast-syntax-highlighting \
  -p https://github.com/marlonrichert/zsh-autocomplete \
  -x

COPY install.sh /tmp/install.sh
RUN /tmp/install.sh

COPY .zshrc /root/

ENTRYPOINT ["zsh"]
