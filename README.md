
[![GitHub](https://img.shields.io/github/license/clefss/docker-csgo-server.svg)](https://tldrlegal.com/license/mit-license#summary) [![GitHub  release](https://img.shields.io/github/release/clefss/docker-csgo-server.svg)](https://github.com/clefss/docker-csgo-server/releases) [![Docker  Cloud Build Status](https://img.shields.io/docker/cloud/build/clefss/csgo-server.svg)](https://hub.docker.com/r/clefss/csgo-server/builds) [![Docker image size](https://images.microbadger.com/badges/image/clefss/csgo-server.svg)](https://microbadger.com/images/clefss/csgo-server "Size")

![logo](https://upload.wikimedia.org/wikipedia/en/thumb/1/1b/CS-GO_Logo.svg/1920px-CS-GO_Logo.svg.png)

# Supported tags
- [`1.0`, `1`, `latest` (_Dockerfile_)](https://github.com/clefss/docker-csgo-server/blob/v1.0/Dockerfile)

# Docker compose - Example
    csgo-server:
      container_name: csgo-server
      image: clefss/csgo-server
      restart: "unless-stopped"
      volumes:
        - $(pwd)/steam:/home/steam/steamapps
      ports:
        - 27015:27015/tcp
        - 27015:27015/udp
        - 27020:27020/udp
      environment:
        GSLT: XXXXXXXXXXXXXXX
        API_AUTHORIZATION_KEY: XXXXXXXXXXXXXX
      ulimits:
        nproc: 65535
        nofile:
          soft: 32000
          hard: 40000

# Configuration
## Volumes
The configuration files will be stored in `/home/steam/steamapps` persistently.

## Ports
CONNECT: 27015<br />
GOTV: 27020

## Environments Variables

### `TZ`
Server Time Zone.<br />
Example: `TZ: Europe/Lisbon`<br />
Default: `UTC`

### `IP`
Your WAN IP address.<br />
Example: `IP: 192.168.1.100`<br />
Default: `0.0.0.0`

### `GSLT`
Game Server Login Token. http://steamcommunity.com/dev/managegameservers<br />
Anonymous connection will be deprecated in the near future. Therefore it is highly recommended to generate a Game Server Login Token.<br />
Example: `GSLT: XXXXXXXXXXXXXX`

### `API_AUTHORIZATION_KEY`
Steam Web API Key. http://steamcommunity.com/dev/apikey<br />
To download maps from the workshop, your server needs access to the steam web api.<br />
Example: `API_AUTHORIZATION_KEY: XXXXXXXXXXXXXX`

### `WORKSHOP_COLLECTION_ID`
A collection id from the Maps Workshop. The API_AUTHORIZATION_KEY is required.<br />
https://steamcommunity.com/sharedfiles/filedetails/?id=2056673593<br />
Example: `WORKSHOP_COLLECTION_ID: 2056673593`<br />
Default: `2056673593`

### `WORKSHOP_START_MAP`
A map id in the selected collection (WORKSHOP_COLLECTION_ID). The API_AUTHORIZATION_KEY is required.<br />
https://steamcommunity.com/sharedfiles/filedetails/?id=125438255<br />
Example: `WORKSHOP_START_MAP: 125438255`<br />
Default: `125438255`

### `MAX_PLAYERS`
Maximum players that can connect.<br />
Example: `MAX_PLAYERS: 15`<br />
Default: `11`

### `TICKRATE`
The tickrate that your server will operate at.<br />
Example: `TICKRATE: 64`<br />
Default: `128`

### `EXTRA_PARAMS`
Custom command line extra parameters.<br />
Example: `EXTRA_PARAMS: "+sv_pure 0 +game_type 0 +game_mode 2"`<br />
Default: `+sv_pure 0 +game_type 0 +game_mode 1 +sv_region 3 +mapgroup mg_active +map de_dust2 -secure -nobreakpad`
