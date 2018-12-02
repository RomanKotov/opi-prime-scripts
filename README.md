# Small scripts collection

## OPI CPU temperature measurement `./temperature.sh`

## Timestamped output of serial port `./timestamp.sh`
Depends on `ts`. It can be installed via `sudo apt install moretools`.
Dumps are printed to stdout and saved to './dump/' folder.
It also accepts keyboard input to send to device.
Example: `./timestamp.sh /dev/ttyUSB0 9600`.
