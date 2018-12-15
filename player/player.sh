#!/usr/bin/env bash

INITIAL_STATUS_FILE_DATA=$(cat <<END
P 0
F 0 0 0 0
S 0 0 0 0 0 0 0 0 0 0 0 0 0
END
)

SED_SCRIPT=$(cat <<END
/^@[FPS]/ {
  s/^@//
  s/^([[:alpha:]]*)(.*)/%s\/^\1.*$\/\1\2\/g\nw/
  p
}
/^@I/ {
  s/^@//
  s/(.*)/\$a\n\1\n.\nw/
  p
}
END
)

STATUS_FILE=${STATUS_FILE:-'./status'}

clear_status () {
  echo "$INITIAL_STATUS_FILE_DATA" > $STATUS_FILE
}

clear_status

MUSIC_DIR=${MUSIC_DIR:-'./music'}

if [[ ! -d $MUSIC_DIR ]]; then
  mkdir -p $MUSIC_DIR
fi

RANDOM_MP3=`find $MUSIC_DIR -type f -path '*/*.mp3' | sort -R | sed -n '1p'`

FILENAME="${1:-$RANDOM_MP3}"

COMMANDS_FILE=${COMMANDS_FILE:-'./commands'}

if [[ ! -p $COMMANDS_FILE ]]; then
  mkfifo $COMMANDS_FILE
fi

trap 'rm $COMMANDS_FILE; clear_status; kill -- -$$' EXIT

(
  tail -f $COMMANDS_FILE \
  | mpg123 -R -remote-err &> >(
    while read line; do
      echo $line
      if [[ "$line" == '@P 0' ]]; then
        echo "Playback finished"
        kill -- $$
      fi
    done
  ) \
  | tee /dev/tty \
  | sed -u -n -E "$SED_SCRIPT"\
  | ed -s $STATUS_FILE
) &

PLAYER_PID=$!

echo "load $FILENAME" >> $COMMANDS_FILE

wait $PLAYER_PID
