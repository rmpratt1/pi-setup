#!/usr/bin/env bash

############################################################
# My Pi base installer
#
# Currently for OSX
############################################################

# Source config files

# Make sure homebrew is installed, install if not
if [[ $(command -v brew) == "" ]]; then
  echo "Installing Hombrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating Homebrew..."
  brew update --quiet
fi

# Make sure balenaEtcher is installed, install if not
echo ""
echo "Installing Balena Etcher..."
brew cask install balenaetcher >/dev/null 2>&1

# Download Raspbian
echo""
echo "Downloading latest Raspbian..."
IMAGE_LOC="${HOME}/Downloads/raspbian_lite_latest"
pushd "$HOME/Downloads/" >/dev/null
curl -LO# https://downloads.raspberrypi.org/raspbian_lite_latest
popd >/dev/null

echo ""
echo "The latest Raspbian image is downloaded to:"
echo "$IMAGE_LOC"
read -p "Press enter to open Etcher..."

# Install raspbian to SD card
open -W -a balenaEtcher

# Install SSH
while true; do
  read -p "Do you want to enable SSH on boot? (Y/N)" yn
  case $yn in
  [Nn]*)
    break
    ;;
  [Yy]*)
    # Enable SSH
    find /Volumes -name "*rpi*" -depth 2 -exec bash -c 'touch "$(dirname {})/ssh"' \;

    # Notify to plug in card to RaspberryPi
    if [ -z "$(find /Volumes/ -type f -name "ssh")" ]; then
      echo "SSH was not set up automatically. Mount and change to boot directory then run:"
      echo "    touch ssh"
    else
      echo "SSH setup completed"
    fi
    break
    ;;
  *)
    echo "Please enter Y or N"
    ;;
  esac
done

echo ""
echo "Base Pi image setup completed. Insert the memory card into your RaspberryPi"
