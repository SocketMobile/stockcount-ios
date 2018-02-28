#!/bin/sh
#

# if there is no parameter then assume
# the root dir is the current folder
# where this script is located
if [ -z "$1"	]

then

	set $1 "$PWD/"

fi


echo publish Capture NuGet for Windows
# branch="$(git branch | head -n 1)"
# branch="$(git symbolic-ref HEAD 2>/dev/null)"
branch=`git rev-parse --short HEAD`
master=`git rev-parse --short master`
echo "hash current branch: " $branch
echo "hash for master: " $master
# if "%BRANCH%"=="* (HEAD detached at %MASTER%)" (
#   echo push Capture NuGet for Windows
#   nuget push "%buildscripts%\SocketMobile.Capture.*.nupkg" -s http://nwkgit1.socketcomm.com/nuget/ 577FB113A50342CCBCB67A5A90264923
# )
#${SOURCE_ROOT}/Crashlytics.framework/submit  <API_KEY> \
# <BUILD_SECRET> \
# -emails $(lastcommitEmail) \
# -notesPath ~/Notes/ReleaseNotes.txt \
# -groupAliases GroupAlias,GroupAlias2 \
# -notifications YES

if [ "$branch" == "$master" ]
then
LastCommitEmail=`git show --format="%aE" | head -n 1`
echo "send a notification to " $LastCommitEmail
echo "for this file " $1StockCount/SockCount.ipa
# $1../Pods/Crashlytics/submit $CrashlyticsApiKey $CrashlyticsSecret -ipaPath $1StockCount/StockCount.ipa -emails $LastCommitEmail -notifications YES
else
	echo "not on master branch so nothing gets published through Crashlytics"
fi
