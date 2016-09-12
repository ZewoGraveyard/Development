#!/usr/bin/env bash

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    bash <(curl -s https://codecov.io/bash)
fi
