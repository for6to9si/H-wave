#!/bin/sh

logger -p notice -t "$(basename "$0")" "Activate routing hysteria tables"

[ "${1}" != "start" ] && exit 0
[ "$interface" != "$(route | grep '^default' | grep -o '[^ ]*$')" ] && exit 0

logger -p notice -t "$(basename "$0")" "runnig"

/opt/etc/init.d/S96hysteria fast_restart