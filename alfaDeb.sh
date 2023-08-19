#!/bin/bash

apt update && apt upgrade
apt install realtek-rtl88xxau-dkms -y
apt install dkms -y

git clone https://github.com/aircrack-ng/rtl8812au
cd rtl8812au
make
make install

