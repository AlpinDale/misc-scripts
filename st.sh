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
    pushd SillyTavern
    git pull
    npm install
    popd
    node SillyTavern/server.js
fi

