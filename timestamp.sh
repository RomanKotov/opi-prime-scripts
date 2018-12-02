#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Usage:"
    echo "  $0 <serial-port> [ <speed> [ <stty-options> ... ] ]"
    echo "  Example: $0 /dev/ttyUSB0 9600"
    exit 0
fi

# Exit when any command fails
set -e

# Kill background processes and restore terminal when this shell exits
trap 'set +e; kill "$DUMP_PID"' EXIT

OUTPUT_DIR='./dump/'
DUMP_FILENAME="${OUTPUT_DIR}dump-$(date +'%Y-%m-%d_%H:%M:%S').csv"
mkdir -p $OUTPUT_DIR
touch $DUMP_FILENAME
tail -f $DUMP_FILENAME & DUMP_PID=$!

# Pass keyboard input to serial device
tee >(
  trap 'kill "$READER_PID"' EXIT

  # Remove serial port from parameter list, so only stty settings remain
  SERIAL_PORT="$1"; shift

  stty -F "$SERIAL_PORT" raw -echo "$@"
  cat "$SERIAL_PORT" | sed -u "s/^/\t/" | ts '%Y-%m-%d %H:%M:%.s' >> $DUMP_FILENAME & READER_PID=$!
  tee /dev/null > "$SERIAL_PORT"
) > /dev/null

