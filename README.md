# Small scripts collection

## OPI CPU temperature measurement `./temperature.sh`

## Timestamped output of serial port `./timestamp.sh`
Depends on `ts`. It can be installed via `sudo apt install moretools`.

Dumps are printed to stdout and saved to './dump/' folder.

It also accepts keyboard input to send to device.

Example: `./timestamp.sh /dev/ttyUSB0 9600`.

## Simple command line player `(cd player && ./player.sh)`

Depends on `mpg123`. It can be installed with `sudo apt install mpg123`.

Plays random mp3 file from `player/music` folder (available after first launch).
If file or directory is hidden (starts with dot, for example '.SomeFile.mp3' it will be omitted.

Real time status available at `player/status`.

Accepts [remote commands for `mpg123`](https://github.com/georgi/mpg123/blob/master/doc/README.remote) via `player/commands` FIFO. For example: `echo "PAUSE" > commands` or `echo "P" > commands`

General usage `./player.sh` or `./player.sh "./PATH_TO_FILE.mp3"`

## Simple command line playlist player

Depends on `mpg123`. It can be installed with `sudo apt install mpg123`.

Plays random mp3 file (or online radio URL) from `radio/playlist` file (available after first launch).

General usage `./radio.sh` or `./radio.sh "./PATH_TO_FILE.mp3"`
