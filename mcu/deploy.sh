#!/bin/bash
# Deploy script to upload lua program to node.
# TODO: Remove unused files
# TODO: Create missing file from .lua.tmpl

#listfile_node() {
#  nodemcu-uploader file list 2>&1 | grep "\.lua" |\
#    sed -e "s/$(printf '\t')[0-9][0-9]*//g" | while read line; do
#      echo $line
#  done
#}

listfile_local() {
  find . -type f | grep "\.lua$" | sed -e "s/^\.\///"
}

# Remove unused files if necessary
#diff=$(comm -23 <(listfile_node | sort) <(listfile_local | sort))
#if [[ $diff ]]; then
#  echo "Removing unused files..."
#  nodemcu-uploader file remove $(diff)
#fi

# Upload .lua files to node
echo "Uploading files to node..."
nodemcu-uploader upload $(listfile_local)

# Restart NodeMcu after deployment
echo "Finish deployment, restarting node..."
nodemcu-uploader node restart
