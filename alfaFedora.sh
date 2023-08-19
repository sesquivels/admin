#!/bin/bash

dnf update -y
dnf install realtek-rtl88xxau-dkms -y
dnf install dkms -y

git clone https://github.com/aircrack-ng/rtl8812au
cd rtl8812au
make
make install

