#!/bin/bash
CONNAME=mynet
SUBNET=223
nmcli con add con-name $CONNAME type ethernet
nmcli con modify $CONNAME connection.interface-name ens33
nmcli con modify $CONNAME ipv4.addresses 10.10.$SUBNET.2/24
nmcli con modify $CONNAME ipv4.method manual
nmcli con modify $CONNAME ipv4.dns 1.1.1.1
nmcli con up $CONNAME
nmcli c m ens32 connection.autoconnect no