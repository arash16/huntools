FROM ubuntu:24.04

RUN apt-get -y update
RUN apt-get -y install \
  sudo zsh binutils cmake build-essential \
  python3-dev python3-pip python3-setuptools \
  ca-certificates curl wget xsel urlview vim vim-gtk3 tmux jq \
  net-tools wireguard-tools iproute2 iptables openvpn \
  procps bbe git file \
  zip unzip gzip bzip2 tar unrar \
  dnsutils inetutils-ping \
  && apt-get clean

# node/go/rust minio

RUN git config --global core.compression 9
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
  -p https://github.com/zsh-users/zsh-autosuggestions \
  -p https://github.com/zdharma-continuum/fast-syntax-highlighting \
  -p https://github.com/marlonrichert/zsh-autocomplete \
  -x

RUN curl https://i.jpillora.com/lsd-rs/lsd! | bash
RUN curl https://i.jpillora.com/sharkdp/bat! | bash
RUN curl https://i.jpillora.com/sharkdp/fd! | bash
RUN curl https://i.jpillora.com/noborus/ov! | bash
RUN curl https://i.jpillora.com/ajeetdsouza/zoxide! | bash
RUN curl https://i.jpillora.com/BurntSushi/ripgrep!?as=rg | bash
RUN curl https://i.jpillora.com/jpillora/chisel! | bash
RUN curl https://i.jpillora.com/mikefarah/yq! | bash
RUN curl -Lo /usr/local/bin/http https://packages.httpie.io/binaries/linux/http-latest \
  && ln -s /usr/local/bin/http /usr/local/bin/https \
  && chmod +x /usr/local/bin/http /usr/local/bin/https

RUN git clone --depth=1 "https://github.com/junegunn/fzf.git" /opt/fzf && /opt/fzf/install
RUN git clone --depth=1 "https://github.com/asdf-vm/asdf.git" /opt/asdf \
  && ln -s /opt/asdf/bin/asdf /usr/local/bin/asdf

COPY .zshrc /root/

ENTRYPOINT ["zsh"]
