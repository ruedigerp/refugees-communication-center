# pidgin over VNC
#
# VERSION               0.3

FROM refugees/base
MAINTAINER Rüdiger Pretzlaff

RUN apt-get update && apt-get upgrade -y && apt-get install -y pidgin pidgin-openpgp pidgin-otr pidgin-twitter
# Autostart icedove (might not be the best way, but it does the trick)
RUN bash -c 'echo "pidgin" >> /root/.bashrc'
RUN echo "ps fauxww | grep Xvfb | awk {'print \$2'} | xargs kill -9 " >> /root/.bashrc
RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
EXPOSE 5900
CMD    ["x11vnc", "-forever", "-usepw", "-create"]
