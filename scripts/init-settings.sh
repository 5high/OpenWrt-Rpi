#!/bin/bash
#=================================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'

# Disable IPV6 ula prefix
sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# enable ssh on WAN
uci set "dropbear.@dropbear[0].GatewayPorts=on"

# config udpxy
uci set "udpxy.@udpxy[0].mcsub_renew=300"
uci set "udpxy.@udpxy[0].buffer_size=2Mb"
uci set "udpxy.@udpxy[0].bind=0.0.0.0"
uci set "udpxy.@udpxy[0].source=0.0.0.0"
uci set "udpxy.@udpxy[0].disabled=0"

# enable turboacc
uci set turboacc.config=turboacc
uci set turboacc.config.sw_flow='1'
uci set turboacc.config.hw_flow='1'
uci set turboacc.config.sfe_flow='1'
uci set turboacc.config.fullcone_nat='1'
uci set turboacc.config.dns_caching='0'
uci set turboacc.config.bbr_cca='1'


if [ $(uname -m) = "aarch64" ]; then
# CPU Performance
uci set cpufreq.cpufreq.governor0='performance'
uci set cpufreq.cpufreq.governor4='performance'
fi

# Set hybird mode to lan
uci set dhcp.lan.dhcpv6=hybrid
uci set dhcp.lan.ndp=hybrid
uci set dhcp.lan.ra=hybrid
uci set dhcp.lan.ra_management=1
uci set dhcp.lan.ra_default=1

# enable igmp snooping on LAN
network.lan.igmp_snooping='1'

# Set hybird mode to wan6
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.interface=wan
uci set dhcp.wan6.ra=hybrid
uci set dhcp.wan6.dhcpv6=hybrid
uci set dhcp.wan6.ndp=hybrid
uci set dhcp.wan6.master=1
    
# Fix igmpproxy
uci set "igmpproxy.@phyint[0].altnet=0.0.0.0/0"

# Enable UPNP
uci set upnpd.config.enabled='1'

# Config Docker
#echo "{
#        "log-driver": "journald",
#        "storage-driver": "overlay2"
#       }" > /etc/docker/daemon.json
       
uci set dockerd.globals.registry_mirrors='https://hub-mirror.c.163.com'

# disable IPV6 DNS
uci set "dhcp.@dnsmasq[0].filter_aaaa=1"

# enable dhcp force
uci set dhcp.lan.force='1'

# Configure uHttpd
uci set uhttpd.main.redirect_https='1'
uci set uhttpd.main.rfc1918_filter='0'


# Enable MosDNS
uci set mosdns.mosdns.geo_auto_update='1'
uci set mosdns.mosdns.redirect='1'
uci set mosdns.mosdns.enabled='1'
uci set mosdns.mosdns.listen_port='5355'
uci set mosdns.mosdns.remote_dns1='208.67.222.222'
uci set mosdns.mosdns.remote_dns2='208.67.220.220'

# Check file system during boot
uci set "fstab.@global[0].check_fs=1"
uci commit

echo "*/10 * * * * docker exec hassio_audio rm -rf /usr/bin/bashio && docker exec hassio_audio killall bashio udevadm &" > /var/spool/cron/crontabs/root
sed -i 's/proxy=2/proxy=0/g' /usr/share/xupnpd/xupnpd.lua
echo "<a href=\"https://sumju.net\" target=\"_blank\">智能家居</a>" > /etc/bench.log
echo "echo \" <a href=\"https://sumju.net\" target=\"_blank\">智能家居</a>\" >> /etc/bench.log" >> /etc/coremark.sh
exit 0
