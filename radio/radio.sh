#!/bin/bash

PLAYLIST=${PLAYLIST:-'./playlist'}

if [[ ! -f $PLAYLIST ]]; then
  echo > $PLAYLIST
fi

STATION=$(awk NF $PLAYLIST | sort -R | head -n 1)

STATION="${1:-$STATION}"

mpg123 $STATION
