#!/bin/bash
# Deploy script to upload lua program to NodeMcu.
# TODO: Remove unused files
# TODO: Use single connection to upload all files

# Upload .lua files to Mcu
LUA_FILES=`ls -A | grep "\.lua$"`
for lua_file in $LUA_FILES; do
  nodemcu-uploader upload $lua_file
done

# Restart NodeMcu after deployment
nodemcu-uploader file do deploy.lua
