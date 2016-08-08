#!/usr/bin/env bash

snapshot_host="https://zewo-swift-snapshots.s3.amazonaws.com"
snapshot=$(head -n 1 .swift-version)
swiftenv_was_just_installed=false

if [ ! -d "$HOME/.swiftenv" ]; then
    echo "Installing swiftenv..."
    echo ""

    git clone --depth 1 https://github.com/kylef/swiftenv.git ~/.swiftenv
    export SWIFTENV_ROOT="$HOME/.swiftenv"
    export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"

    echo ""

    swiftenv_was_just_installed=true
fi

echo "Installing snapshot..."
echo ""

if [ ! -d "/tmp/swift-snapshot-installation" ]; then
    mkdir /tmp/swift-snapshot-installation
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ ! -d "/Library/Developer/Toolchains/swift-$snapshot.xctoolchain" ]; then
        if [ ! -d "/tmp/swift-snapshot-installation/Applications" ]; then
            curl -fL $snapshot_host/swift-$snapshot-osx.tar | tar -x -C /tmp/swift-snapshot-installation
            echo ""
        fi

        echo "Your password is required to move the snapshot to /Library/Developer/Toolchains."

        if [ ! -d "/Library/Developer/Toolchains" ]; then
            sudo mkdir -p /Library/Developer/Toolchains
        fi

        sudo mv /tmp/swift-snapshot-installation/Applications/Xcode.app/Contents/Developer/Toolchains/swift-$snapshot.xctoolchain /Library/Developer/Toolchains/swift-$snapshot.xctoolchain

        if [ -d "/Applications/Xcode-beta.app" ]; then
            sudo ln -s /Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/llvm-profdata /Library/Developer/Toolchains/swift-$snapshot.xctoolchain/usr/bin/llvm-profdata
        fi

        echo ""
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ ! -d "/Library/Developer/Toolchains/swift-$snapshot.xctoolchain" ]; then
        if [ ! -d "/tmp/swift-snapshot-installation/usr" ]; then
            curl -fl $snapshot_host/swift-$snapshot-ubuntu14.04.tar | tar -x -C /tmp/swift-snapshot-installation
            echo ""
        fi

        mkdir -p $SWIFTENV_ROOT/versions/$snapshot
        mv /tmp/swift-snapshot-installation/usr $SWIFTENV_ROOT/versions/$snapshot/usr
    fi
fi

rm -rf /tmp/swift-snapshot-installation

swiftenv rehash


echo "Done installing the snapshot!"

if [ "$swiftenv_was_just_installed" = true ]; then
    echo ""
    echo "To finish installing swiftenv you need to configure your environment:"
    echo ""
    echo "echo 'export SWIFTENV_ROOT=\"\$HOME/.swiftenv\"' >> ~/.bash_profile"
    echo "echo 'export PATH=\"\$SWIFTENV_ROOT/bin:\$PATH\"' >> ~/.bash_profile"
    echo "echo 'eval \"\$(swiftenv init -)\"' >> ~/.bash_profile"
    echo ""
    echo "NOTE:"
    echo "On some platforms, you may need to modify ~/.bashrc instead of ~/.bash_profile."
    echo "If you use another shell instead of bash you probably know what to do. (:"
    echo ""
fi
