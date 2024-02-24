#!/usr/bin/env bash

readonly APP_NAME="Pokemon"
readonly IOS_SDK="17.0"

xcodebuild -project ${APP_NAME}App/${APP_NAME}.xcodeproj \
           -scheme ${APP_NAME} \
           -configuration Release \
           -sdk iphonesimulator${IOS_SDK}
