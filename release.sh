#!/bin/bash

./pre-build.sh
docker run --name cordova-release -v "$(pwd)/app/config.xml:/tmp/app/config.xml" -v "$(pwd)/www:/tmp/app/www" -v "$(pwd)/app/PlayStore:/tmp/app/PlayStore" -v "$(pwd)/app/build.json:/tmp/app/build.json" jackavins/cordova:mypin bash -c "rm -rf platforms && cordova platform add android && cordova build --release android"
docker cp cordova-release:/tmp/app/platforms/android/app/build/outputs/bundle/release/app-release.aab tmp
docker container stop cordova-release
docker container rm cordova-release
./post-build.sh