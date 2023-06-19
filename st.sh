#!/bin/bash

pkg update && pkg upgrade

pkg list-installed | grep -w "nodejs" || pkg install nodejs
pkg list-installed | grep -w "git" || pkg install git

if [ ! -d "SillyTavern" ]; then
    git clone -b dev https://github.com/SillyTavern/SillyTavern
    pushd SillyTavern
    npm install
    popd
    node SillyTavern/server.js
else
    cd SillyTavern
    git pull
    npm install
    node server.js
fi

