#!/usr/bin/env sh

set -euo pipefail

PLATFORM=$1

case $PLATFORM in
iOS) DESTINATION="platform=iOS Simulator,name=iPhone 11 Pro";;
macOS) DESTINATION="platform=macOS,arch=x86_64";;
esac

xcodebuild clean \
    -workspace Jot.xcworkspace \
    -scheme Jot-$PLATFORM

xcodebuild build \
    -workspace Jot.xcworkspace \
    -scheme Jot-$PLATFORM \
    -destination "$DESTINATION" \
    > build.log

sh Tools/Scripts/swiftlint.sh analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter emoji

rm build.log
