#!/usr/bin/env bash

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

date=$(date +%Y%m%d-%H%M%S)

logo () {
	
	local text="${1:?}"
	echo -en "                      
    ██████████████████████████████████████████████████████████████
    ██████████████████████████████████████████████████████████████
    ██████████████████████████████████████████████████████████████
    ████████████████████  ██████████████████  ████████████████████
    ████████████████████    █████████████     ████████████████████
    █████████████████████    ██████████       ████████████████████
    ███████████████████████    █████        ██████████████████████
    ████████████████████████   █      █    ███████████████████████
    ███████████████████████        ███    ████████████████████████
    █████████████████████        ████   ██████████████████████████
    ██████████████████     ███   ███   ███████████████████████████
    ██████████████       ██████        ███████████████████████████
    ███████████                                         ██████████
    ███████████████████████████       ████████████    ████████████
    ██████████████████████████   ███   ██████████    █████████████
    ████████████████████████    █████   ███████     ██████████████
    ███████████████████████    ███████    ████    ████████████████
    ██████████████████████   ██████████   ███    █████████████████
    ████████████████████     ██████████    █   ███████████████████
    ████████████████████   █████████████       ███████████████████
    ██████████████████    ███████████████    █████████████████████
    ███████████████████  █████████████████  ██████████████████████
    ██████████████████████████████████████████████████████████████
    ██████████████████████████████████████████████████████████████
    ██████████████████████████████████████████████████████████████
 		            	  ThesoulOfPixels Dotfiles\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

########## ---------- Welcome ---------- ##########

logo "Welcome!"
printf '%s%sThis is for personal use currently.%s\n\n' "${BLD}" "${CRE}" "${CNC}"
while true; do
	read -rp " Do you wish to continue? [y/N]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf " Error: just write 'y' or 'n'\n\n";;
		esac
    done
clear

########## ---------- Install packages  ---------- ##########

dependencias=(bat exa lsd fd ripgrep fzf jq sd tldr btop \
        zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

is_installed() {
  pacman -Qi "$1" &> /dev/null
  return $?
}

printf "%s%sChecking for required packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
for paquete in "${dependencias[@]}"
do
  if ! is_installed "$paquete"; then
    sudo pacman -S "$paquete" --noconfirm
    printf "\n"
  else
    printf '%s%s is already installed on your system!%s\n' "${CGR}" "$paquete" "${CNC}"
  fi
done
sleep 3
clear

########## ---------- Installing Paru ---------- ##########

logo "installing Paru"

if ! command -v paru >/dev/null 2>&1; then
	printf "%s%sInstalling paru%s\n" "${BLD}" "${CBL}" "${CNC}"
	cd
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	makepkg -si --noconfirm
	cd
else
	printf "%s%sParu is already installed%s\n" "${BLD}" "${CGR}" "${CNC}"
fi

########## ------------- Config NvChad -------------- ##########

logo "Config NvChad"

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
# cp -R "$HOME"/dotfiles/misc/custom "$HOME"/.config/nvim/lua/
printf "%s%sDone!! It will auto install plugins at first launch.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
sleep 3


########## --------- Changing shell to zsh ---------- ##########

logo "Changing default shell to zsh"
printf "%s%sIf your shell is not zsh will be changed now.\nYour root password is needed to make the change.\n\nAfter that is important for you to reboot.\n %s\n" "${BLD}" "${CYE}" "${CNC}"
if [[ $SHELL != "/usr/bin/zsh" ]]; then
  echo "Changing shell to zsh, your root pass is needed."
  chsh -s /usr/bin/zsh
else
  printf "%s%sYour shell is already zsh\nGood bye! installation finished, now reboot%s\n" "${BLD}" "${CGR}" "${CNC}"
  zsh
fi
