#!/usr/bin/env bash

MUSIC_DIR=${MUSIC_DIR:-'./music/'}

COMMANDS_FILE=${COMMANDS_FILE:-'./commands'}

STATUS_FILE=${STATUS_FILE:-'./status'}

RANDOM_MP3=`find $MUSIC_DIR -type f -ipath '*/*.mp3' | sort -R | sed -n '1p'`

FILENAME="${1:-$RANDOM_MP3}"

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

clear_status () {
  echo "$INITIAL_STATUS_FILE_DATA" > $STATUS_FILE
}

clear_status

if [[ ! -d $MUSIC_DIR ]]; then
  mkdir -p $MUSIC_DIR
fi

if [[ ! -p $COMMANDS_FILE ]]; then
  mkfifo $COMMANDS_FILE
fi

set_filename () {
  file_path=${1#$"$MUSIC_DIR"}
  printf "0a\nNOW_PLAYING '$file_path'\n.\nw\n" \
  | ed -s $STATUS_FILE
}

trap 'rm $COMMANDS_FILE; clear_status; set_filename "n/a"; kill -- -$$' EXIT

(
  set_filename $FILENAME
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
  | sed -u -n -E "$SED_SCRIPT" \
  | ed -s $STATUS_FILE
) &

PLAYER_PID=$!

echo "LOAD $FILENAME" >> $COMMANDS_FILE

wait $PLAYER_PID
