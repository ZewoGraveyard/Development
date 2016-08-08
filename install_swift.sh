#!/usr/bin/env bash

snapshot_host="https://zewo-swift-snapshots.s3.amazonaws.com"
snapshot="DEVELOPMENT-SNAPSHOT-2016-$1-a"

git clone --depth 1 https://github.com/kylef/swiftenv.git ~/.swiftenv
export SWIFTENV_ROOT="$HOME/.swiftenv"
export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"

if [ "$(uname)" == "Darwin" ]; then
    curl -fsSL $snapshot_host/swift-$snapshot-osx.tar | tar -x
    sudo mkdir -p /Library/Developer/Toolchains
    sudo mv Applications/Xcode.app/Contents/Developer/Toolchains/swift-$snapshot.xctoolchain /Library/Developer/Toolchains/swift-$snapshot.xctoolchain
    sudo ln -s /Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/llvm-profdata /Library/Developer/Toolchains/swift-$snapshot.xctoolchain/usr/bin/llvm-profdata
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    curl -fsSl $snapshot_host/swift-$snapshot-ubuntu14.04.tar | tar -x
    mkdir -p $SWIFTENV_ROOT/versions/$snapshot
    mv usr $SWIFTENV_ROOT/versions/$snapshot/usr
fi

swiftenv rehash
