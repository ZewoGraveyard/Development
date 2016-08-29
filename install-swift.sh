#!/usr/bin/env bash

snapshot_host="https://zewo-swift-snapshots.s3.amazonaws.com"

if [ ! -z "$1" ]; then
    snapshot=$1
else
    if [ -f ".swift-version" ]; then
        snapshot=$(head -n 1 .swift-version)
    else
        echo "No snapshot version supplied."
        exit 1
    fi
fi

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

swiftenv install $snapshot

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
