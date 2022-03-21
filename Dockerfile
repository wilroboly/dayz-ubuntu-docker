FROM        ubuntu:20.04

LABEL       author="William Roboly (robolo)" maintainer="wilco@nurf.com"
ENV         DEBIAN_FRONTEND noninteractive
ENV         USER container
ENV         HOME /home/container

# steam cmd and directory conf
ENV         SERVER_DIR ${HOME}/server
ENV         STEAM_CMD_USER anonymous
ENV         STEAM_CMD_PASSWORD=""

# Install Dependencies
RUN         dpkg --add-architecture i386 && \
            apt-get update && \
            apt-get upgrade -y && \
            apt-get install -y apt-utils && \
            apt-get install -y \
                tmux \
                nano \
                htop \
                curl \
                lib32gcc1 \
                lib32stdc++6 \
                libcap-dev \
                libcurl4 \
                libcurl4-openssl-dev \                
                psmisc \
                wget \
                rename \
            && \
            apt-get autoremove && \
            rm -rf /var/lib/apt/lists/*

RUN         useradd -m -d ${HOME} -s /bin/bash ${USER} && \
            mkdir -p ${SERVER_DIR}

EXPOSE      2302/udp
EXPOSE      2303/udp
EXPOSE      2304/udp
EXPOSE      2305/udp
# steam
EXPOSE      8766/udp
EXPOSE      27016/udp
# rcon (preferred)
EXPOSE      2310

USER        ${USER}
WORKDIR     ${HOME}

# reset cmd & define entrypoint
COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
