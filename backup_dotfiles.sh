#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

backup_dir=/home/$USER/Personal/configs/dotfiles

backup_date=$(date "+%d-%m-%Y")

neovim_config_dir=/home/$USER/.config/nvim
i3wm_config_dir=/home/$USER/.config/i3
kitty_config_dir=/home/$USER/.config/kitty

echo -e "\n neovim"
echo -e "\n${BLUE}> ${YELLOW}Migrating source config to ${BLUE}${backup_dir}/nvim${NC}"
mkdir -p $backup_dir/nvim
cp -r $neovim_config_dir/* $backup_dir/nvim/
echo -e "${BLUE}> ${YELLOW}Migration complete. ${NC}\n"

echo -e "\n i3wm"
echo -e "\n${BLUE}> ${YELLOW}Migrating source config to ${BLUE}${backup_dir}/i3${NC}"
mkdir -p $backup_dir/i3
cp -r $i3wm_config_dir/* $backup_dir/i3/
echo -e "${BLUE}> ${YELLOW}Migration complete. ${NC}\n"

echo -e "\n kitty"
echo -e "\n${BLUE}> ${YELLOW}Migrating source config to ${BLUE}${backup_dir}/kitty${NC}"
mkdir -p $backup_dir/kitty
cp -r $kitty_config_dir/* $backup_dir/kitty/
echo -e "${BLUE}> ${YELLOW}Migration complete. ${NC}\n"

echo -e "\n zsh"
echo -e "\n${BLUE}> ${YELLOW}Migrating source config to ${BLUE}${backup_dir}/zsh${NC}"
mkdir -p $backup_dir/zsh
cp -r ~/.zshrc $backup_dir/zsh/
echo -e "${BLUE}> ${YELLOW}Migration complete. ${NC}\n"

echo -e "\n tmux"
echo -e "\n${BLUE}> ${YELLOW}Migrating source config to ${BLUE}${backup_dir}/tmux${NC}"
mkdir -p $backup_dir/tmux
cp -r ~/.tmux.conf $backup_dir/tmux/
echo -e "${BLUE}> ${YELLOW}Migration complete. ${NC}\n"

# git flow
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
[yY])
	echo yes
	echo -n -e "\n${BLUE}:: ${NC}Commit message (required) : "
	read commit_message

	echo -e "\n${BLUE}> ${YELLOW}exec: git commit -m \"${commit_message}\"${NC}"
	git -C $backup_dir/ commit -m "${commit_message}"

	if [ $? -eq 0 ]; then
		echo -e "\n${BLUE}> ${YELLOW}exec: git push${NC}"
		git -C $backup_dir/ push
		echo -e "\n${BLUE}Backup successful.${NC}\n"
	else
		echo -e "\nBackup failed!\n"
		exit 1
	fi
	;;
*)
	echo -e "\n${YELLOW}Backup cancelled!${NC}\n"
	exit 1
	;;
esac
