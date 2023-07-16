#!/bin/bash
sudo apt-get update
sudo apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms

sudo modprobe -r b44 b43 b43legacy ssb brcmsmac bcma
sudo modprobe wl

sudo reboot
