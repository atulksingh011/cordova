#!/bin/bash

# Step 1
cordova plugin add cordova-plugin-contacts

# Step 2
cordova plugin add cordova-plugin-app-version

# Step 3
cordova plugin add cordova-plugin-network-information

# Step 4
cordova plugin add cordova-plugin-cache-clear

# Step 5
cordova plugin add cordova-plugin-device

# Step 6
cordova plugin add cordova-plugin-file-opener2-e36

# Step 7
find plugins/ -type f -exec sed -i 's/android.support.v4.content.FileProvider/androidx.core.content.FileProvider/g' {} +

# Step 8
cordova plugin add cordova-plugin-file

# Step 9
cordova plugin add cordova-plugin-camera

# Step 10
cordova plugin add cordova-plugin-icrop

# Step 11
mv plugins/cordova-plugin-icrop/www/icrop.js plugins/cordova-plugin-icrop/www/crop.js

# Step 12
sed -i "s/compile 'com.github.yalantis:ucrop:2.2.1'/implementation 'com.github.yalantis:ucrop:2.2.6'/g" plugins/cordova-plugin-icrop/src/android/CropPlugin.java
