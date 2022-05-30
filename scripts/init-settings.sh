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

# config udpxy
uci set udpxy.@udpxy[0].mcsub_renew='300'
uci set udpxy.@udpxy[0].buffer_size='2Mb'
uci set udpxy.@udpxy[0].bind='0.0.0.0'
uci set udpxy.@udpxy[0].source='0.0.0.0'
uci set udpxy.@udpxy[0].disabled='0'

# enable turboacc
uci set turboacc.config=turboacc
uci set turboacc.config.sw_flow='1'
uci set turboacc.config.hw_flow='1'
uci set turboacc.config.sfe_flow='1'
uci set turboacc.config.fullcone_nat='1'
uci set turboacc.config.dns_caching='1'
uci set turboacc.config.bbr_cca='1'

# CPU Performance
uci set cpufreq.cpufreq.governor0='performance'
uci set cpufreq.cpufreq.governor4='performance'

# Fix igmpproxy
uci set igmpproxy.@phyint[0].altnet='0.0.0.0/0'

# Enable UPNP
uci set upnpd.config.enabled='1'

# Config Docker
dockerd.globals.registry_mirrors='https://hub-mirror.c.163.com'

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit

exit 0
