FROM ubuntu:22.04

ENV TZ=Asia/Tehran

COPY install.sh /tmp/install.sh
RUN /tmp/install.sh

COPY configs /opt/configs
ENTRYPOINT ["/opt/configs/entry.sh"]
