#!/bin/bash

## Copying prebuilt ipks to the packages folder inside imagebuilder
mv -v ${GITHUB_WORKSPACE}/ipks/* ${IMAGEBUILDER_HOME}/packages/


## Adding reference to our Custom repository inside Imagebuilder 
## Adding public key of the custom packages repository.
mv -v ${GITHUB_WORKSPACE}/keys/* ${IMAGEBUILDER_HOME}/keys/

## Adding reference to our Custom repository inside Imagebuilder 
cat >> "${GITHUB_WORKSPACE}/repositories.conf" <<END

## Custom Repository
src/gz custom_packages https://open-core-initiative.github.io/sturdynet-openwrt-packages/main/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/custom
END


## Adding reference to OpenWRT base repositories
cat >> "${GITHUB_WORKSPACE}/repositories.conf" <<END

## Target based OpenWRT repositories
src/gz openwrt_core https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/${OPENWRT_TARGET}/generic/packages
src/gz openwrt_kmods https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/${OPENWRT_TARGET}/generic/kmods/5.10.146-1-0f695d32a4ccbe0b9448c8f73fcd9338/

## Architecture based OpenWRT repositories
src/gz openwrt_base https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/base
src/gz openwrt_luci https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/luci
src/gz openwrt_packages https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/packages
src/gz openwrt_routing https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/routing
src/gz openwrt_telephony https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/packages/${OPENWRT_ARCH}/telephony
END

## Replacing imagebuilder repositories.conf with ours
cp -f ${GITHUB_WORKSPACE}/repositories.conf ${IMAGEBUILDER_HOME}/repositories.conf


## Build command to start image building process.
cd "${IMAGEBUILDER_HOME}"

for I in ${GITHUB_WORKSPACE}/files/*; do
	echo "NAME OF FOLDER: ${I##*/} & PATH OF FOLDER: ${I}" ||
	exit 1
done


# make -j${nproc} image \
# PROFILE='glinet_gl-ap1300' \
# PACKAGES='netifyd netify-fwa luci mwan3 luci-app-mwan3 rtty tcpdump bmon iftop netcat socat jq comgt usb-modeswitch rtty-mbedtls luci-app-statistics collectd-mod-unixsock collectd-mod-mqtt wifischedule luci-app-wifischedule l7stats flow_broker python3-ubus python3-uci curl uhttpd-mod-lua kmod-mii kmod-usb-net kmod-usb-wdm kmod-usb-net-qmi-wwan uqmi openwisp-config openwisp-monitoring netjson-monitoring openvpn-mbedtls luci-app-openvpn luci-proto-modemmanager' \
# FILES='${GITHUB_WORKSPACE}/files' \
# BIN_DIR='${GITHUB_WORKSPACE}/bin' || exit 1
