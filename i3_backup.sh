#!/bin/bash

# Backup i3 window manager configs

NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

i3_dir=/home/$USER/.config/i3
backup_dir=/home/$USER/Personal/configs/i3wm-config
backup_date=$(date "+%d-%m-%Y")

echo -e "\n${BLUE}> ${YELLOW}Migrating source config to ${BLUE}${backup_dir}${NC}"
rsync --delete --quiet -r -P $i3_dir/* $backup_dir/
echo -e "${BLUE}> ${YELLOW}Migration complete. ${NC}\n"

echo -e "${BLUE}> ${YELLOW}Updating target repository...${NC}"
git -C $backup_dir/ pull

echo -e "\n${BLUE}> ${YELLOW}exec: git status${NC}"
git -C $backup_dir/ status
status=$(git -C $backup_dir/ status)
if [[ "$status" == *"nothing to commit"* ]]; then
    echo -e "\n${BLUE}Everything up to date.${NC}\n"
    exit 0
fi

echo -e "\n${BLUE}> ${YELLOW}exec: git add .${NC}"
git -C $backup_dir/ add .

echo -e "\n${BLUE}> ${YELLOW}exec: git status${NC}"
git -C $backup_dir/ status

echo -n -e "${BLUE}:: ${NC}Do you want to commit the given changes? [y/N] "
read confirm

case $confirm in
    [yY] ) echo yes;
        echo -n -e "\n${BLUE}:: ${NC}Commit message (optional) : ";
        read commit_message;

        if [ ! -z commit_message ]; then
            commit_message="autobackup ${backup_date}";
        fi

        echo -e "\n${BLUE}> ${YELLOW}exec: git commit -m \"${commit_message}\"${NC}"
        git -C $backup_dir/ commit -m "${commit_message}";
        
        if [ $? -eq 0 ]; then
            echo -e "\n${BLUE}> ${YELLOW}exec: git push${NC}";
            git -C $backup_dir/ push;
            echo -e "\n${BLUE}Backup successful.${NC}\n";
        else
            echo -e "\nBackup failed!\n";
            exit 1;
        fi
        ;;
    * ) echo -e "\n${YELLOW}Backup cancelled!${NC}\n"; 
        exit 1;
        ;;
esac

