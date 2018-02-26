#!/usr/bin/env bash -l
#
#  Build script to build the StockCount application for iOS
# ©2018  Socket Mobile, Inc.

#iosTarget="iphoneos10.2"
iosTarget="iphoneos"

# if there is no parameter then assume
# the root dir is the current folder
# where this script is located
if [ -z "$1"	]

then

	set $1 "$PWD/"

fi

echo "buildscripts dir:" $1

security -v unlock-keychain -p $KEYCHAIN_PASSWORD $HOME/Library/Keychains/login.keychain
pod install --project-directory="$1.."
xcodebuild -workspace "$1../StockCount.xcworkspace" -configuration Release -scheme StockCount -sdk $iosTarget clean build
