FROM jackavins/cordova:cordova-11

WORKDIR /tmp/app

COPY /app .

RUN pwd

RUN cordova plugin add cordova-plugin-contacts
RUN cordova plugin add cordova-plugin-app-version
RUN cordova plugin add cordova-plugin-network-information
RUN cordova plugin add cordova-plugin-cache-clear
RUN cordova plugin add cordova-plugin-device
RUN cordova plugin add cordova-plugin-file-opener2-e36
RUN find plugins/ -type f -exec sed -i 's/android.support.v4.content.FileProvider/androidx.core.content.FileProvider/g' {} +
RUN cordova plugin add cordova-plugin-file
RUN cordova plugin add cordova-plugin-camera
RUN cordova plugin add cordova-plugin-icrop
RUN mv plugins/cordova-plugin-icrop/www/icrop.js plugins/cordova-plugin-icrop/www/crop.js
RUN sed -i "s/compile 'com.github.yalantis:ucrop:2.2.1'/implementation 'com.github.yalantis:ucrop:2.2.6'/g" plugins/cordova-plugin-icrop/src/android/CropPlugin.java


