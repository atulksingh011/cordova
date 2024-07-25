#!/bin/bash

export NG_CLI_ANALYTICS=ci
cd ../frontend-old/
echo "pulling latest changes"
git pull
echo "starting angular build... for few minutes to finish"
npm run build:prod
echo "builing apk..."
cd ../cordova
echo "pulling latest changes"
./release.sh
