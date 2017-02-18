#!/bin/bash
# Deploy script to upload lua program to node.
# TODO: Remove unused files
# TODO: Create missing file from .lua.tmpl

# Upload .lua files to node
echo "Upload files to node"
nodemcu-uploader upload $(find . -type f | grep "\.lua$" | sed -e "s/^\.\///")

# Restart NodeMcu after deployment
echo "Finish deployment, restarting node..."
nodemcu-uploader node restart
