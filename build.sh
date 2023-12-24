#!/bin/bash

./pre-build.sh
docker run --name cordova-build -v "$(pwd)/app/config.xml:/tmp/app/config.xml" -v "$(pwd)/www:/tmp/app/www" -v "$(pwd)/app/PlayStore:/tmp/app/PlayStore" -v "$(pwd)/app/build.json:/tmp/app/build.json" -v "$(pwd)/app/config.xml:/tmp/app/config.xml" jackavins/cordova:mypin bash -c "rm -rf platforms && cordova platform add android && cordova build android"
docker cp cordova-build:/tmp/app/platforms/android/app/build/outputs/apk/debug/app-debug.apk tmp
docker container stop cordova-build
docker container rm cordova-build
./post-build.sh
