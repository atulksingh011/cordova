#!/bin/bash

export NG_CLI_ANALYTICS=ci
cd ../frontend-old/

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm use

echo "pulling latest changes"
git pull
echo "starting angular build... for few minutes to finish"
npm run build:prod
echo "builing apk..."
cd ../cordova
echo "pulling latest changes"
./release.sh
