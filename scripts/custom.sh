#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Add date version
export DATE_VERSION=$(date -d "$(rdate -n -4 -p pool.ntp.org)" +'%Y-%m-%d')
sed -i "s/%C/%C (${DATE_VERSION})/g" package/base-files/files/etc/openwrt_release

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Rename hostname to OpenWrt
pushd package/base-files/files/bin
sed -i 's/ImmortalWrt/OpenWrt/g' config_generate
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Add luci-aliyundrive-webdav
pushd package
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
popd

# Add Mosdns
pushd package
svn co https://github.com/QiuSimons/openwrt-mos/trunk/luci-app-mosdns
svn co https://github.com/QiuSimons/openwrt-mos/trunk/mosdns
sed -i '/apple-cn/d' luci-app-mosdns/root/etc/mosdns/def_config.yaml
sed -i 's/119.29.29.29/202.106.196.115/g'  luci-app-mosdns/root/etc/mosdns/library.sh
sed -i 's/101.226.4.6/202.106.0.20/g'  luci-app-mosdns/root/etc/mosdns/library.sh
popd

# Add AdGuardHome
pushd package
git clone https://github.com/TioaChan/luci-app-adguardhome
#https://github.com/rufengsuixing/AdGuardHome
popd

# Add xupnpd IPTV Source
mkdir -p  files/usr/share/xupnpd/playlists
wget https://raw.githubusercontent.com/qwerttvv/Beijing-IPTV/master/IPTV-Unicom-Multicast.m3u -O files/usr/share/xupnpd/playlists/BJCNC.m3u

# Add information
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:Telegram %></td><td><a href="https://sumju.net"><%:智能家居博客%></a></td></tr>' package/lean/autocore/files/arm/index.htm
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:Telegram %></td><td><a href="https://sumju.net"><%:智能家居博客%></a></td></tr>' package/lean/autocore/files/x86/index.htm
