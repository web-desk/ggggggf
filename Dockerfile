FROM ubuntu:20.10

# ------------------------------------------------------------
# Set environment variables
# ------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------
# Set the sources
# ------------------------------------------------------------

RUN echo 'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-security main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-updates main restricted universe multiverse\n'\
'deb http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-backports main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-security main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-updates main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-proposed main restricted universe multiverse\n'\
'deb-src http://ubuntu.mirror.rain.co.za/ubuntu/ groovy-backports main restricted universe multiverse\n'\
'' > /etc/apt/sources.list

RUN apt-get upgrade 
RUN set -ex; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        dbus-x11 \
        nautilus \
        gedit \
        expect \
        sudo \
        vim \
	python3-pip \
	mysql-server \
	docker \
	vlc \
        bash \
        net-tools \
        novnc \
        xfce4 \
	socat \
        x11vnc \
	xvfb \
        supervisor \
        curl \
        git \
	pulseaudio \
        wget \
        g++ \
	unzip \
        virtualbox \
        sudo \
        ssh \
	ffmpeg \
	chromium-browser \
	firefox \
        terminator \
        htop \
        gnupg2 \
	locales \
	xfonts-intl-chinese \
	fonts-wqy-microhei \  
	ibus-pinyin \
	ibus \
	ibus-clutter \
	ibus-gtk \
	ibus-gtk3 \
	ibus-qt4 \
	openssh-server \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
RUN dpkg-reconfigure locales

RUN sudo apt-get update && sudo apt-get install -y obs-studio

COPY . /app
RUN chmod +x /app/conf.d/websockify.sh
RUN chmod +x /app/run.sh
RUN chmod +x /app/expect_vnc.sh
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
RUN echo "deb http://deb.anydesk.com/ all main"  >> /etc/apt/sources.list
RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub -P /app
RUN wget --no-check-certificate -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY -O /app/anydesk.key
RUN apt-key add /app/anydesk.key
RUN apt-key add /app/linux_signing_key.pub
RUN set -ex; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        google-chrome-stable \
	anydesk


ENV UNAME pacat

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes pulseaudio-utils

# VISIT US REXXAR.iR
RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

RUN echo xfce4-session >~/.xsession
RUN echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" 

CMD ["/app/run.sh"]
