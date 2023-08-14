#!/bin/bash

    #Este seria el equipo para correr scripts
    #primero actualiza la maquina
    echo -ne "
Which Centos are you using?
1) 7.x
2) 8.x
0) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        yum update -y
        yum install -y epel-release
        #luego instala lo primordial
        yum install -y curl htop lynx mc git neovim mc zsh cifs-utils nfs-utils net-tools bind-utils
        #preguntamos el hostname deseado lo leemos de pantalla y lo asignamos
        echo -ne " Que nombre de equipo quiere?"
        read -r hostnamE
        hostnamectl set-hostname $hostnamE
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        exit

        echo "#---------------------------------------------------------------------" | tee /home/sesquivels/.zshrc
        echo "#--------------------------ALIAS SECTION------------------------------" | tee /home/sesquivels/.zshrc
        echo "#---------------------------------------------------------------------" | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        echo "#BASICS:" | tee /home/sesquivels/.zshrc
        echo '  alias setZshrc="nvim ~/.zshrc"' | tee /home/sesquivels/.zshrc
        echo '  alias reloadZshrc="source ~/.zshrc"' | tee /home/sesquivels/.zshrc
        echo '  alias ftp="ftp ftp-pro.houston.softwaregrp.com"' | tee /home/sesquivels/.zshrc
        echo '  alias montarGeneral="mkdir general && sudo mount -t nfs 192.168.100.19:/mnt/tank/general general"' | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        echo "#SUPPORT:" | tee /home/sesquivels/.zshrc
        echo '   alias investigacion="/tank/admin/investigation.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias unzipFiles="/tank/admin/zipFile.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias untarFiles="/tank/admin/tarFile.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias loggerInfo="/tank/admin/loggerApliance.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias esmInfo="/tank/admin/loggerApliance.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias connectorInfo="/tank/admin/connectorScript.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias scisors="/tank/admin/scissor.sh"' | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        source /home/sesquivels/.zshrc
        ;;
    2)
        dnf update -y
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
        dnf update -y
        dnf install -y curl htop mc git neovim mc zsh cifs-utils nfs-utils net-tools bind-utils
        echo -ne " Que nombre de equipo quiere?"
        read -r hostnamE
        hostnamectl set-hostname $hostnamE
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        exit
        echo "#---------------------------------------------------------------------" | tee /home/sesquivels/.zshrc
        echo "#--------------------------ALIAS SECTION------------------------------" | tee /home/sesquivels/.zshrc
        echo "#---------------------------------------------------------------------" | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        echo "#BASICS:" | tee /home/sesquivels/.zshrc
        echo '  alias setZshrc="nvim ~/.zshrc"' | tee /home/sesquivels/.zshrc
        echo '  alias reloadZshrc="source ~/.zshrc"' | tee /home/sesquivels/.zshrc
        echo '  alias ftp="ftp ftp-pro.houston.softwaregrp.com"' | tee /home/sesquivels/.zshrc
        echo '  alias montarGeneral="mkdir general && sudo mount -t nfs 192.168.100.19:/mnt/tank/general general"' | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        echo "#SUPPORT:" | tee /home/sesquivels/.zshrc
        echo '   alias investigacion="/tank/admin/investigation.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias unzipFiles="/tank/admin/zipFile.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias untarFiles="/tank/admin/tarFile.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias loggerInfo="/tank/admin/loggerApliance.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias esmInfo="/tank/admin/loggerApliance.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias connectorInfo="/tank/admin/connectorScript.sh"' | tee /home/sesquivels/.zshrc
        echo '   alias scisors="/tank/admin/scissor.sh"' | tee /home/sesquivels/.zshrc
        echo "#" | tee /home/sesquivels/.zshrc
        source /home/sesquivels/.zshrc
        ;;
    0)
        echo "Bye bye."
        exit 0
        ;;
    *)
        echo "Wrong option."
        exit 1
        ;;
    esac

