# Firefox over VNC
#
# VERSION               0.3

FROM refugees/base
MAINTAINER Rüdiger Pretzlaff

# Install vnc, xvfb in order to create a 'fake' display and firefox
# RUN apt-get update && apt-get install -y x11vnc xvfb firefox vim
RUN apt-get update && apt-get upgrade -y && apt-get install -y iceweasel 
# Autostart firefox (might not be the best way, but it does the trick)
RUN bash -c 'echo "iceweasel" >> /root/.bashrc'
RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
EXPOSE 5900
CMD    ["x11vnc", "-forever", "-usepw", "-create"]
