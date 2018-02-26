#!/usr/bin/env bash -l
#
#  Build script to Archive the StockCount application for iOS
#
# this scripts signs the StockCount app and exports it as
# StockCount.ipa
#
# © 2018 Socket Mobile, Inc.

iosTarget="iphoneos"

# if there is no parameter then assume
# the root dir is the current folder
# where this script is located
if [ -z "$1"	]

then

	set $1 "$PWD/"

fi

echo "buildscripts:" $1


security -v unlock-keychain -p $KEYCHAIN_PASSWORD $HOME/Library/Keychains/login.keychain

xcodebuild -workspace "$1../StockCount.xcworkspace" -scheme StockCount -sdk $iosTarget archive -archivePath "$1../StockCount.xcarchive"

xcodebuild -exportArchive -archivePath "$1../StockCount.xcarchive" -exportPath StockCount -exportOptionsPlist "$1exportOptions.plist"
