#!/bin/bash

cat /sys/devices/virtual/thermal/thermal_zone0/temp | awk '{print $1/1000}' | tr -d '\n' | xargs -0 printf "%.3f˚C\n"
