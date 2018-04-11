#!/bin/sh
#####################################################
# crashlytics publish script
# © 2018 Socket Mobile, inc.
#
# This script publish the archive to Crashlytics only
# if it happens on the master branch
#####################################################

# if there is no parameter then assume
# the root dir is the current folder
# where this script is located
if [ -z "$1"	]

then

	set $1 "$PWD/"

fi

echo publish IPA file on Crashlytics
# branch="$(git branch | head -n 1)"
# branch="$(git symbolic-ref HEAD 2>/dev/null)"
branch=`git rev-parse --short HEAD`
master=`git rev-parse --short master`
echo "hash current branch: " $branch
echo "hash for master: " $master

if [ "$branch" == "$master" ]
then
	if [ -f ../env-vars.sh ]
	then
		source ../env-vars.sh
		LastCommitEmail=`git show --format="%aE" | head -n 1`
		echo "send a notification to " $LastCommitEmail
		echo "for this file " $1StockCount/SockCount.ipa
		# $1../Pods/Crashlytics/submit $CrashlyticsApiKey $CrashlyticsSecret -ipaPath $1StockCount/StockCount.ipa -emails $LastCommitEmail -notifications YES
	else
		echo "there is no env-vars.sh"
else
	echo "not on master branch so nothing gets published through Crashlytics"
fi
