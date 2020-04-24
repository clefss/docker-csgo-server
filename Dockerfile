FROM debian:buster-slim

LABEL maintainer="clefss"

ENV STEAM_HOME_DIR=/home/steam \
    STEAM_CMD_DIR=/home/steam/steamcmd \
    STEAM_APPS_DIR=/home/steam/steamapps \
    STEAM_APP_DIR=/home/steam/steamapps/csgo \
    STEAM_LOGS_DIR=/home/steam/steamapps/logs \
    STEAM_APP_ID=740

# install dependencies
RUN set -x && \
    buildDeps="curl tar wget" && \
    dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get upgrade -y -qq --no-install-recommends --no-install-suggests && \
    apt-get install -y -qq --no-install-recommends --no-install-suggests $buildDeps lib32stdc++6 lib32gcc1 ca-certificates dnsutils sudo

# create steam user
RUN useradd -m steam && \
    echo "steam ALL=(ALL)NOPASSWD: ALL" >> /etc/sudoers

# get steam cmd
RUN mkdir -p $STEAM_CMD_DIR $STEAM_APPS_DIR && \
    curl -sqL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C $STEAM_CMD_DIR -xvz

# insert files
COPY entrypoint.sh $STEAM_HOME_DIR/entrypoint.sh

# set permissions
RUN chown -R steam:steam $STEAM_HOME_DIR && \
    chmod +x $STEAM_HOME_DIR/entrypoint.sh

# clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
apt-get purge -y --auto-remove ${buildDeps} && \
apt-get autoremove -y && \
apt-get clean

# environments
ENV TZ=UTC \
    IP=0.0.0.0 \
    GSLT=0 \
    API_AUTHORIZATION_KEY=0 \
    WORKSHOP_COLLECTION_ID=2056673593 \
    WORKSHOP_START_MAP=125438255 \
    MAX_PLAYERS=11 \
    TICKRATE=128 \
    EXTRA_PARAMS="+sv_pure 0 +game_type 0 +game_mode 2 +sv_region 3 +mapgroup mg_active +map de_dust2 -secure -nobreakpad"

# last settings
USER steam

WORKDIR $STEAM_APPS_DIR

VOLUME $STEAM_APPS_DIR

EXPOSE 27015/tcp 27015/udp 27020/udp

ENTRYPOINT "$STEAM_HOME_DIR/entrypoint.sh"
