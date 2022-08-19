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

svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/luci-app-aliyundrive-fuse

popd

# Add Mosdns
mkdir -p files/usr/share/v2ray/
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -O files/usr/share/v2ray/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -O files/usr/share/v2ray/geosite.dat
pushd package
svn co https://github.com/QiuSimons/openwrt-mos/trunk/luci-app-mosdns
sed -i 's/\+mosdns-neo/\+mosdns/g' luci-app-mosdns/Makefile
#sed -i 's/\"208.67.222.222\"/\"tls\:\/\/208.67.222.222\"/g' luci-app-mosdns/luasrc/model/cbi/mosdns/basic.lua
#sed -i 's/\"208.67.220.220\"/\"tls\:\/\/208.67.220.220\"/g' luci-app-mosdns/luasrc/model/cbi/mosdns/basic.lua
sed -i '/\-\ \_prefer_ipv4/d' luci-app-mosdns/root/etc/mosdns/def_config_orig.yaml
sed -i 's/https\:\/\/gh.404delivr.workers.dev\/https\:\/\/github.com\/QiuSimons\/openwrt-mos\/raw\/master\/dat\//https\:\/\/github.com\/Loyalsoldier\/v2ray-rules-dat\/releases\/latest\/download\//g' luci-app-mosdns/root/etc/mosdns/library.sh
sed -i 's/https\:\/\/github.com\/Loyalsoldier\/v2ray-rules-dat\/releases\/latest\/download\//https\:\/\/github.com\/Loyalsoldier\/v2ray-rules-dat\/releases\/latest\/download\//g' luci-app-mosdns/root/etc/mosdns/library.sh
sed -i 's/119.29.29.29/tcp\:\/\/223.5.5.5/g'  luci-app-mosdns/root/etc/mosdns/library.sh
sed -i 's/101.226.4.6/tcp\:\/\/223.6.6.6/g'  luci-app-mosdns/root/etc/mosdns/library.sh

wget https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt -O /tmp/apple-cn.txt
wget https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/google-cn.txt -O /tmp/google-cn.txt

echo 'netcts.cdn-apple.com 127.0.0.1' >> luci-app-mosdns/root/etc/mosdns/rule/hosts.txt
echo 'render.alipay.com' >> luci-app-mosdns/root/etc/mosdns/rule/whitelist.txt

for i in `cat /tmp/apple-cn.txt`
do
  echo $i >> luci-app-mosdns/root/etc/mosdns/rule/whitelist.txt
done

for i in `cat /tmp/google-cn.txt`
do
  echo $i >> luci-app-mosdns/root/etc/mosdns/rule/whitelist.txt
done

popd

# Add AdGuardHome
pushd package
git clone https://github.com/rufengsuixing/luci-app-adguardhome
#https://github.com/rufengsuixing/AdGuardHome
popd

# Add xupnpd IPTV Source
mkdir -p  files/usr/share/xupnpd/playlists
wget https://raw.githubusercontent.com/qwerttvv/Beijing-IPTV/master/IPTV-Unicom-Multicast.m3u -O files/usr/share/xupnpd/playlists/北京IPTV.m3u
#wget https://raw.githubusercontent.com/5high/OpenWrt-Rpi/main/scripts/%E4%B9%90%E5%B1%B1IPTV.m3u -O files/usr/share/xupnpd/playlists/乐山IPTV.m3u

# Add information
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:Telegram %></td><td><a href="https://sumju.net"><%:智能家居博客%></a></td></tr>' package/lean/autocore/files/arm/index.htm
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:Telegram %></td><td><a href="https://sumju.net"><%:智能家居博客%></a></td></tr>' package/lean/autocore/files/x86/index.htm
