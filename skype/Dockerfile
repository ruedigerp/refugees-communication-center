# Firefox over VNC
#
# VERSION               0.3

FROM refugees/base
MAINTAINER Rüdiger Pretzlaff

RUN bash -c 'echo "skype" >> /root/.bashrc'
RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

RUN bash -c 'dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6:i386 libqt4-dbus:i386 libqt4-network:i386 libqt4-xml:i386 libqtcore4:i386 libqtgui4:i386 libqtwebkit4:i386 libstdc++6:i386 libx11-6:i386 libxext6:i386 libxss1:i386 libxv1:i386 libssl1.0.0:i386 libpulse0:i386 libasound2-plugins:i386'
ADD http://www.skype.com/go/getskype-linux-deb /tmp/skype-install.deb
RUN bash -c 'dpkg -i /tmp/skype-install.deb'

EXPOSE 5900
CMD    ["x11vnc", "-forever", "-usepw", "-create"]
