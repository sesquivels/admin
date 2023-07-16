#!/bin/bash

wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb

sudo apt install ./libssl1.1_1.1.1f-1ubuntu2_amd64.deb

# save /etc/debian-version
# (which will be something like kali-rolling)
DV_SAVE=$(cat /etc/debian_version)
# pretend we're Debian buster
echo buster | sudo tee /etc/debian_version >/dev/null
# follow ZeroTier install instructions from:
# https://www.zerotier.com/download/
# for example, if you don't care about checking gpg signatures:
curl -s https://install.zerotier.com | sudo bash
# restore /etc/debian-version
echo $DV_SAVE | sudo tee /etc/debian_version >/dev/null
