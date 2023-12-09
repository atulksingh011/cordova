# create volume if using android studio
docker volume create --name android_sdk --opt type=none --opt device=/Users/atulsingh/Library/Android/sdk --opt o=bind

# RUN
    1) npm run exec
    2) cd app && rm -rf platforms && cordova platform add android && cordova build --release android

# Path
    Release Bundle (.aab): platforms/android/app/build/outputs/bundle/release/app-release.aab 
    Debug (.apk): platforms/android/app/build/outputs/apk/debug/app-debug.apk

1) cordova plugin add cordova-plugin-contacts
2) cordova plugin add cordova-plugin-app-version
3) cordova plugin add cordova-plugin-network-information 
4) cordova plugin add cordova-plugin-cache-clear
5) cordova plugin add cordova-plugin-device
6) cordova plugin add cordova-plugin-file-opener2-e36 
7) Replace "android.support.v4.content.FileProvider" with "androidx.core.content.FileProvider"
8) cordova plugin add cordova-plugin-file
9) cordova plugin add cordova-plugin-camera
10) cordova plugin add cordova-plugin-icrop
11) rename plugins/cordova-plugin-icrop/www/icrop.js => plugins/cordova-plugin-icrop/www/crop.js
12) update gradle dependency and add few line in cropPlugin.java as defined in below section
13) cordova plugin add cordova-plugin-x-socialsharing

# [fix] for icrop in plugins/cordova-plugin-icrop/src/android/build.gradle update 

dependencies {
    compile 'com.github.yalantis:ucrop:2.2.1'
}

to

dependencies {
    implementation 'com.github.yalantis:ucrop:2.2.6'
}
when fresh install this plugin will give you error to fix it just rename www/icorp.js to crop.js


# add below line in cropPlugin.java
import com.yalantis.ucrop.UCropActivity;
import android.graphics.Color;

UCrop.Options options = new UCrop.Options();
          options.setAllowedGestures(UCropActivity.SCALE, UCropActivity.SCALE, UCropActivity.SCALE);
          options.setStatusBarColor(Color.parseColor("#40aef8"));
          options.setToolbarColor(Color.parseColor("#40aef8"));
//          options.setActiveWidgetColor(color);
//          options.setHideBottomControls(true);

          cordova.setActivityResultCallback(this);
          UCrop.of(this.inputUri, this.outputUri)
                  .withOptions(options)
                  .useSourceImageAspectRatio()
                  .start(cordova.getActivity());

# comment below line from plugins/cordova-plugin-camera/plugin.xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />