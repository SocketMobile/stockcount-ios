#!/bin/sh
#
#${SOURCE_ROOT}/Crashlytics.framework/submit <API_KEY> <BUILD_SECRET> \
# -emails $(lastcommitEmail) \
# -notesPath ~/Notes/ReleaseNotes.txt \
# -groupAliases GroupAlias,GroupAlias2 \
# -notifications YES

lastcommitEmail = git show --format="%aE"

${SOURCE_ROOT}/Crashlytics.framework/submit <API_KEY> <BUILD_SECRET> \
-emails $(lastcommitEmail) \
-notifications YES
