#!/bin/bash

export NG_CLI_ANALYTICS=ci
cd ../frontend-old/

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm use

# Check if a commit hash is passed as an argument
if [ -n "$1" ]; then
  echo "Checking out commit: $1"
  git checkout "$1"
else
  echo "No commit hash provided. Using the current branch."
fi

# Get current branch and commit information
branch_name=$(git rev-parse --abbrev-ref HEAD)
commit_id=$(git rev-parse HEAD)

echo "Building branch: $branch_name"
echo "Commit ID: $commit_id"

echo "Pulling latest changes..."
git pull

echo "Starting Angular build... Please wait a few minutes."
npm run build:prod

# After build, switch back to the main branch
git checkout main

echo "Switching back to main branch."
echo "Building APK..."
cd ../cordova
./build.sh
