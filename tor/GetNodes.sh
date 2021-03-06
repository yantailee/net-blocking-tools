#!/bin/bash

ColorRed='\033[1;31m'
ColorGreen='\033[1;32m'
EndColor='\033[0m'

echo ""
echo -e "${ColorGreen}Getting TOR Nodes....${EndColor}"
echo ""
# Obtain WAN IP of the computer
WANIP=$(curl --silent ipinfo.io/ip)
# Create the NFTables sets
wget -q https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$WANIP -O -|sed '/^#/d' |while read IP
  do
    sed -i '/^define TORNodes.ipv4 = {/a '"$IP"',' /root/scripts/net-blocking-tools/tor/TORNodesIPv4.nftables
    sed -i '/^define TORNodes.ipv6 = {/a '"$IP"',' /root/scripts/net-blocking-tools/tor/TORNodesIPv6.nftables
  done

echo ""
echo -e "${ColorGreen}Creating TOR HAProxy sets....${EndColor}"
echo ""
cp /root/scripts/net-blocking-tools/tor/TORNodesIPv4.nftables /root/scripts/net-blocking-tools/tor/TORNodesIPv4.haproxy
cp /root/scripts/net-blocking-tools/tor/TORNodesIPv6.nftables /root/scripts/net-blocking-tools/tor/TORNodesIPv6.haproxy
find /root/scripts/net-blocking-tools/tor/ -name "*.haproxy" -exec sed -i '1d' {} \;
find /root/scripts/net-blocking-tools/tor/ -name "*.haproxy" -exec sed -i 's/.$//' {} \;

