FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && apt-get update

RUN apt install -y locales apt-utils debconf-utils
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install steamcmd
RUN echo steamcmd steam/question select "I AGREE" | debconf-set-selections
RUN apt install -y steamcmd

# Install dependencies
RUN apt install -y \
                git \
                nano \
                netstat \
                iproute2 \
                mailutils \
                postfix \
                curl \
                wget \
                file \
                bzip2 \
                gzip \
                unzip \
                bsdmainutils \
                python \
                util-linux \
                binutils \
                bc \
                jq \
                tmux \
                lib32gcc1 \
                libstdc++6 \
                libstdc++6:i386 \
                apt-transport-https \
                ca-certificates \
                telnet \
                expect \
                libncurses5:i386 \
                libcurl4-gnutls-dev:i386 \
                libstdc++5:i386 \
                netcat \
                lib32stdc++6 \
                lib32tinfo5 \
                xz-utils \
                zlib1g:i386 \
                libldap-2.4-2:i386 \
                lib32z1 \
                default-jre \
                speex:i386 \
                libtbb2 \
                libxrandr2:i386 \
                libglu1-mesa:i386 \
                libxtst6:i386 \
                libusb-1.0-0:i386 \
                libopenal1:i386 \
                libpulse0:i386 \
                libdbus-glib-1-2:i386 \
                libnm-glib4:i386 \
                zlib1g \
                libssl1.0.0:i386 \
                libtcmalloc-minimal4:i386 \
                libsdl1.2debian \
                libnm-glib-dev:i386 \
                && apt-get clean \
                && rm -rf /var/lib/apt/lists/*

# Add the linuxgsm user
RUN useradd -ms /bin/bash linuxgsm

# Switch to the user linuxgsm
USER linuxgsm
WORKDIR /home/linuxgsm

# Clone LinuxGSM repository
RUN mkdir git
RUN git clone https://github.com/GameServerManagers/LinuxGSM.git git/LinuxGSM
RUN git clone https://github.com/phil535/LinuxGSM-Docker.git git/LinuxGSM-Docker

# Initialising volume
#RUN mkdir -p /home/linuxgsm/linuxgsm
#RUN chown -R linuxgsm:linuxgsm /home/linuxgsm/linuxgsm
VOLUME ["/home/linuxgsm/linuxgsm"]
VOLUME ["/home/linuxgsm/.steam"]

# Set default working directory
WORKDIR /home/linuxgsm/linuxgsm

# need use xterm for LinuxGSM
ENV TERM=xterm

## Docker Details
ENV PATH=$PATH:/home/linuxgsm/linuxgsm

ENTRYPOINT ["bash", "/home/linuxgsm/git/LinuxGSM-Docker/entrypoint.sh"]
