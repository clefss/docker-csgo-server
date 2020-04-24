#!/bin/bash

LOG_FILE="$STEAM_LOGS_DIR/update_$(date +%Y%m%d).log"

# set timezone
echo "setting timezone to $TZ..."
sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ | sudo tee /etc/timezone > /dev/null

# fix permissions
echo "fixing permissions..."
sudo chown -R steam:steam $STEAM_HOME_DIR

# create log directory
if [ ! -d "$STEAM_LOGS_DIR" ]
then
    echo "logs directory does not exist, creating..."
    mkdir -p $STEAM_LOGS_DIR
fi

# create game directory
if [ ! -d "$STEAM_APP_DIR" ]
then
    echo "game directory does not exist, creating..."
    mkdir -p $STEAM_APP_DIR
fi

# create cs go update file
if [ ! -f "$STEAM_APP_DIR/csgo_update.txt" ]
then
    echo "cs go update file does not exist, creating..."
    { \
        echo "@ShutdownOnFailedCommand 1"; \
        echo "@NoPromptForPassword 1"; \
        echo "login anonymous"; \
        echo "force_install_dir $STEAM_APP_DIR"; \
        echo "app_update $STEAM_APP_ID"; \
        echo "quit"; \
    } > $STEAM_APP_DIR/csgo_update.txt
fi

# update steamcmd
echo "Update SteamCMD ..."
$STEAM_CMD_DIR/steamcmd.sh +login anonymous +force_install_dir $STEAM_APP_DIR +app_update $STEAM_APP_ID validate +quit | sudo tee $LOG_FILE

echo "clear download cache..."
rm -rf $STEAM_APP_DIR/steamapps/downloading/*

# generate misc args
GENERATED_ARGS="-game csgo -console -autoupdate -steam_dir $STEAM_CMD_DIR -steamcmd_script $STEAM_APP_DIR/csgo_update.txt -usercon -tickrate $TICKRATE -port 27015 +tv_port 27020 -maxplayers_override $MAX_PLAYERS +net_public_adr $IP"

if [ ! -z "$API_AUTHORIZATION_KEY" ]
then
    GENERATED_ARGS="$GENERATED_ARGS -authkey $API_AUTHORIZATION_KEY"
fi
if [ ! -z "$WORKSHOP_COLLECTION_ID" ] && [ ! -z "$API_AUTHORIZATION_KEY" ]
then
    GENERATED_ARGS="$GENERATED_ARGS +host_workshop_collection $WORKSHOP_COLLECTION_ID"
fi
if [ ! -z "$WORKSHOP_START_MAP" ] && [ ! -z "$API_AUTHORIZATION_KEY" ]
then
    GENERATED_ARGS="$GENERATED_ARGS +workshop_start_map $WORKSHOP_START_MAP"
fi
if [ ! -z "$GSLT" ]
then
    GENERATED_ARGS="$GENERATED_ARGS +sv_setsteamaccount $GSLT"
fi

# start game
echo "starting server..."
$STEAM_APP_DIR/srcds_run $GENERATED_ARGS $EXTRA_PARAMS
