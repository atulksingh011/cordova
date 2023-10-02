FROM beevelop/base

RUN apt-get update && \
    apt-get -y install openjdk-8-jdk-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    java -version

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# https://developer.android.com/studio/#downloads
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" \
    ANDROID_BUILD_TOOLS_VERSION=32.0.0 \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_SDK_ROOT="/opt/android"

ENV PATH $PATH:$ANDROID_SDK_ROOT/cmdline-tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

WORKDIR /opt

RUN apt-get -qq update && \
    apt-get -qq install -y wget curl maven ant gradle

# Installs Android SDK
RUN mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip

RUN mkdir /root/.android && touch /root/.android/repositories.cfg && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-25" "platforms;android-26" "platforms;android-27" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-28" "platforms;android-29" "platforms;android-30" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-31" "platforms;android-32" && \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "extras;android;m2repository" "extras;google;google_play_services" "extras;google;instantapps" "extras;google;m2repository" &&  \
    while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "add-ons;addon-google_apis-google-22" "add-ons;addon-google_apis-google-23" "add-ons;addon-google_apis-google-24" "skiaparser;1"

RUN chmod a+x -R $ANDROID_SDK_ROOT && \
    chown -R root:root $ANDROID_SDK_ROOT && \
    rm -rf /opt/android/licenses && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean && \
    mvn -v && gradle -v && java -version && ant -version

RUN apt-get update && apt-get install -y curl gnupg2 lsb-release && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    apt-key fingerprint 1655A0AB68576280 && \
    export VERSION=node_14.x && \
    export DISTRO="$(lsb_release -s -c)" && \
    echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    node -v && npm -v && \
    npm install -g yarn && \
    yarn -v && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CORDOVA_VERSION 11.0.0

WORKDIR "/tmp"

RUN npm i -g --unsafe-perm cordova@${CORDOVA_VERSION} && \
    cordova -v && \
    cd /tmp && \
    cordova create myApp com.myCompany.myApp myApp && \
    cd myApp && \
    cordova plugin add cordova-plugin-camera --save && \
    cordova platform add android --save && \
    cordova requirements android && \
    cordova build android --verbose && \
    rm -rf /tmp/myApp

RUN cordova telemetry off