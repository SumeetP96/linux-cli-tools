#!/bin/bash

# Gives user execuatble permission to given script
# Create symlink to /usr/local/bin for global execution

if [ $# -ne 1 ]; then
    echo "Please provide a source file!"
    exit 1
fi

source="$1"
destination=/usr/local/bin
source_name=${source%%.*}
new_name=""

function get_new_name() {
    echo -n "Enter a new script name (default = $source_name): "
    read new_name
}

function activate_script() {
    FILE="$destination/$new_name"

    if [ -f "$FILE" ]; then
        echo $FILE
        echo "File with the same name already exists. Please choose a different name."
        get_new_name
        activate_script
    else
        sudo chmod u+x $source
        sudo ln $source /usr/local/bin/$new_name
        if [ -f $FILE ]; then
            echo "Script activated and symlink has been created at $FILE"
        else
            echo "Failed to activate script!"
            exit 1
        fi
    fi
}

get_new_name

if [ -z "$new_name" ]; then
    new_name=$source_name
fi

activate_script

