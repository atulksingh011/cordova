FROM jackavins/cordova:cordova-12

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
RUN sed -i 's/<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" \/>/<!--&-->/g' plugins/cordova-plugin-camera/plugin.xml
RUN cordova plugin add cordova-plugin-icrop
RUN mv plugins/cordova-plugin-icrop/www/icrop.js plugins/cordova-plugin-icrop/www/crop.js
RUN sed -i "s/compile 'com.github.yalantis:ucrop:2.2.1'/implementation 'com.github.yalantis:ucrop:2.2.6'/g" plugins/cordova-plugin-icrop/src/android/build.gradle
RUN sed -i '/import com.yalantis.ucrop.UCrop;/a\import com.yalantis.ucrop.UCropActivity;\nimport android.graphics.Color;' plugins/cordova-plugin-icrop/src/android/CropPlugin.java
RUN sed -i '/UCrop.of(this.inputUri, this.outputUri)/,/\.start(cordova.getActivity());/c\          UCrop.Options options = new UCrop.Options();\n          options.setAllowedGestures(UCropActivity.SCALE, UCropActivity.SCALE, UCropActivity.SCALE);\n          options.setStatusBarColor(Color.parseColor("#40aef8"));\n          options.setToolbarColor(Color.parseColor("#40aef8"));\n//          options.setActiveWidgetColor(color);\n//          options.setHideBottomControls(true);\n\n          cordova.setActivityResultCallback(this);\n          UCrop.of(this.inputUri, this.outputUri)\n                  .withOptions(options)\n                  .useSourceImageAspectRatio()\n                  .start(cordova.getActivity());' plugins/cordova-plugin-icrop/src/android/CropPlugin.java
