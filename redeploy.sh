#!/bin/bash

# somewhere in the JS code there's a hardcoded API reference
# this script replaces it with the value of the $ZEEGUU_API_URL env var
# the compiles
# and then changes the corresponding file back
# 
# expects also to be given the path to the zeeguu web app.py in $ZEEGUU_WEB_APP_PY 
# if given it touches that file which will trigger the reloading of the web

ESCAPE_SLASHES='s/\//\\\//g'

REMOVE_TRAILING_SLASH='s/\/$//g'

DEFAULT_ZEEGUU_API="https://zeeguu.unibe.ch/api"
DEFAULT_ZEEGUU_API_ESCAPED=$(echo $DEFAULT_ZEEGUU_API | sed $REMOVE_TRAILING_SLASH | sed $ESCAPE_SLASHES)
echo $DEFAULT_ZEEGUU_API_ESCAPED


if [ -z $ZEEGUU_API_URL ]; then
	echo "ZEEGUU_API_URL not set. working with $DEFAULT_ZEEGUU_API"
else

	
	echo "ZEEGUU_API_URL defined ($ZEEGUU_API_URL)"
	echo  "... chaging the API url accordingly in zeeguuRequests"
	
	ZEEGUU_API_URL_ESCAPED=$(echo $ZEEGUU_API_URL | sed $REMOVE_TRAILING_SLASH | sed $ESCAPE_SLASHES  )
	sed -i.bak "s/$DEFAULT_ZEEGUU_API_ESCAPED/$ZEEGUU_API_URL_ESCAPED/g" src/umr/static/scripts/app/zeeguuRequests.js

	echo "config line in zeeguuRequests.js"
	cat src/umr/static/scripts/app/zeeguuRequests.js | grep "const ZEEGUU_API_URL"

fi

echo "running webpack..."
webpack && (cd src; python setup.py develop) && touch $ZEEGUU_WEB_APP_PY

if [ -z $ZEEGUU_API_URL ]; then
	echo ""
else
	mv src/umr/static/scripts/app/zeeguuRequests.js.bak src/umr/static/scripts/app/zeeguuRequests.js
	rm -rf src/umr/static/scripts/app/zeeguuRequests.js.bak
	echo "... changed the API url back to $DEFAULT_ZEEGUU_API"

	echo "config line in zeeguuRequests.js"
	cat src/umr/static/scripts/app/zeeguuRequests.js | grep "const ZEEGUU_API_URL"

fi

if [ -z $ZEEGUU_WEB_APP_MAIN_FILE ]; then
	echo ""
else
	echo "Restarting the web app..."
	touch $ZEEGUU_WEB_APP_MAIN_FILE
fi