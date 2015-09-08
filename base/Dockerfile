# Firefox over VNC
#
# VERSION               0.3

FROM debian:jessie
MAINTAINER Rüdiger Pretzlaff

# Install vnc, xvfb in order to create a 'fake' display 
RUN apt-get update && apt-get upgrade -y && apt-get install -y x11vnc xvfb 
# Autostart firefox (might not be the best way, but it does the trick)
RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
