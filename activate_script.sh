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

function generate_activated_script() {
    sudo chmod u+x $source
    sudo ln $source /usr/local/bin/$new_name

    local SCRIPT_FILE="$destination/$new_name"
    echo $SCRIPT_FILE
    if [ -f $SCRIPT_FILE ]; then
        echo "Script activated and symlink has been created at $SCRIPT_FILE"
    else
        echo "Failed to activate script!"
        exit 1
    fi
}

function activate_script() {
    local SCRIPT_FILE="$destination/$new_name"
    if [ -f "$SCRIPT_FILE" ]; then
        echo $SCRIPT_FILE
        echo "Script with the same name already exists."

        echo -n -e "\nDo you want to replace it? [y/N] "
        read confirm_replace

        case $confirm_replace in
            [yY] ) echo yes;
                sudo rm $SCRIPT_FILE;
                if [ $? -eq 0 ]; then
                    generate_activated_script; 
                fi
                ;;
            * ) get_new_name;
                activate_script;
                ;;
        esac
    else
        generate_activated_script
    fi
}

get_new_name

if [ -z "$new_name" ]; then
    new_name=$source_name
fi

activate_script

