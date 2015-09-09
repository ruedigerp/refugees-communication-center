# Firefox over VNC
#
# VERSION               0.3

FROM refugees/@@FROM@@
MAINTAINER Rüdiger Pretzlaff

RUN mkdir ~/.vnc
# Setup a password
RUN x11vnc -storepasswd @@PASSWORD@@ ~/.vnc/passwd
