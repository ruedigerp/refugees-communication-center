# icedove over VNC
#
# VERSION               0.3

FROM refugees/base
MAINTAINER Rüdiger Pretzlaff

RUN apt-get update && apt-get upgrade -y && apt-get install -y icedove enigmail icedove-l10n-ar
# Autostart icedove (might not be the best way, but it does the trick)
RUN bash -c 'echo "icedove" >> /root/.bashrc'
RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
EXPOSE 5900
CMD    ["x11vnc", "-forever", "-usepw", "-create"]
