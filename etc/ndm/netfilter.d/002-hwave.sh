#!/bin/sh

#logger -p notice -t "$(basename "$0")" "Activate '${table}' routing tables"
#logger -p notice -t "$(basename "$0")" "Activate '${type}' routing types"

[ "$table" != "mangle" ] && [ "$table" != "nat" ] && exit 0

# $type is `iptables` or `ip6tables`
# $table is `nat` or `mangle`
/opt/etc/init.d/S96hysteria firewall_"$type"_"$table"
