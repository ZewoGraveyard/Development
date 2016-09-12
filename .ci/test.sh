#!/usr/bin/env bash

swift build
swift build -c release
swift test

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    set -o
    swift package generate-xcodeproj
    xcodebuild -project Flux.xcodeproj -scheme Flux -sdk macosx10.12 -destination arch=x86_64 -configuration Debug -enableCodeCoverage YES test | xcpretty
fi
