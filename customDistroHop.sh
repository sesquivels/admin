#!/bin/bash


#=============================
#-----------Variables---------
#=============================



#=============================
#-----------Menues------------
#=============================

function mainmenu() {
    echo -ne "
====================================================    
============Custom Disto Hop install================
====================================================
 What distro want to customize?
 1) PopOs
 2) Parrot
 3) Kali
 4) Fedora37
 5) CentOS 7.xx
 6) RHEL 7.x
 7) Ubuntu WSL
 0) Exit  
Choose an option:  "
    read -r ans
    case $ans in
    1)
        clear
        submenuPop
        mainmenu
        ;;
    2)
        clear
        parrotOS
        ;;
    3)
        clear
        submenu
        mainmenu
        ;;
    4)
        clear
        submenu
        mainmenu
        ;;
    5)
        clear
        submenuCentos
        mainmenu
        ;;
    6)
        clear
        submenu
        mainmenu
        ;;
    7)
        clear
        ubuntuWSL
        mainmenu
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
}

function submenuPop() {
    echo -ne "
SUBMENU
1) POP Intel
2) POP Nvidia
3) Go Back to Main Menu
0) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        popOsIntel
        ;;
    2)
        popOsNvidia
        ;;
    3)
        menu
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
}

function submenuCentos() {
    echo -ne "
SUBMENU
1) Office Infrastructure
2) Office Custom support
3) Go Back to Main Menu
0) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        submenuCentosInfra
        ;;
    2)
        centosSoporte
        ;;
    3)
        menu
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
}

function submenuCentosInfra() {
    echo -ne "
SUBMENU
1) Logger
2) Arcmc
3) Connector
4) LoadBalancer
5) NFS
0) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        centosLogger
        ;;
    2)
        centosArcmc
        ;;
    3)
        centosConnector
        ;;
    4)
        centosLoadBalancer
        ;;
    5)
        centosNFS
        ;;
    3)
        menu
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
}


#=============================
#---Montajes de NFS o Cifs----
#=============================
function monuntPersonal() {
    sudo chown -R sesquivels:root /opt /mnt /installers
    mkdir -p /mnt/{general,sesquivels}
    echo "192.168.100.235:/zroot/general /mnt/general nfs defaults 0 0" |sudo tee -a /etc/fstab
    echo "192.168.100.235:/zroot/sesquivels /mnt/sesquivels nfs defaults 0 0" |sudo tee -a /etc/fstab
    sudo mount -a
    exit 0
}
function monuntPro() {
    mkdir -p /mnt/{mf_data,mf_brete}
    echo "192.168.100.235:/zroot/MF_Brete /mnt/mf_brete nfs defaults 0 0" | tee -a /etc/fstab
    echo "192.168.100.235:/zroot/MF_Data /mnt/mf_data nfs defaults 0 0" | tee -a /etc/fstab
    mount -a
    exit 0
}

#=============================
#--------Debian Forks---------
#=============================

function popOsIntel() {
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common
    monuntPersonal
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/startUPS/setupDeb.tar.gz /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupDeb.tar.gz
    cd firstSetupDeb
    sudo apt install ./google-chrome-stable_current_amd64.deb
    ./ohmyzsh.sh
    ./colorscripts.sh
    cp .zshrc ~/.zshrc
    cd ~/Documents
    ln /mnt/general/unidocs .
    ln /mnt/sesquivels/Estudios .
    ln /mnt/sesquivels/Dev .
    exit 0
}
function popOsNvidia() {
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common nvidia-cuda-toolkit
    monuntPersonal
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/startUPS/setupDeb.tar.gz /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupDeb.tar.gz
    cd firstSetupDeb
    sudo apt install ./google-chrome-stable_current_amd64.deb
    ./ohmyzsh.sh
    ./colorscripts.sh
    cp .zshrc ~/.zshrc
    cd ~/Documents
    ln /mnt/general/unidocs .
    ln /mnt/sesquivels/Estudios .
    ln /mnt/sesquivels/Dev .
    exit 0
}

function kaliOs() {
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common  nvidia-driver nvidia-cuda-toolkit 
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
    monuntPersonal
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/startUPS/setupDeb.tar.gz /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupDeb.tar.gz
    cd firstSetupDeb
    sudo apt install ./google-chrome-stable_current_amd64.deb
    ./ohmyzsh.sh
    ./colorscripts.sh
    cp .zshrc ~/.zshrc
    cd ~/Documents
    ln /mnt/general/unidocs .
    ln /mnt/sesquivels/Estudios .
    ln /mnt/sesquivels/Dev .
    exit 0
}

function ubuntuWSL() {
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common
    sudo mkdir /installers
    mkdir -p /installers/startupConfigs
    scp sesquivels@192.168.100.235:/zroot/general/configs/startUPS/setupDeb.tar.gz /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupDeb.tar.gz
    cd firstSetupDeb
    ./ohmyzsh.sh
    ./colorscripts.sh
    cp .zshrc ~/.zshrc
    exit 0
}

function parrotOS() {
    sudo apt update && sudo apt upgrade	
    sudo apt install neovim curl git mc zsh cifs-utils nfs-common firmware-realtek nvidia-driver nvidia-cuda-toolkit 
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
    monuntPersonal
    mkdir -p /installers/startupConfigs
    cp /mnt/general/configs/startUPS/setupDeb.tar.gz /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupDeb.tar.gz
    cd firstSetupDeb
    sudo apt install ./google-chrome-stable_current_amd64.deb
    ./ohmyzsh.sh
    ./colorscripts.sh
    cp .zshrc ~/.zshrc
    cd ~/Documents
    ln /mnt/general/unidocs .
    ln /mnt/sesquivels/Estudios .
    ln /mnt/sesquivels/Dev .
    exit 0
}
#=============================
#---------RHEL Forks----------
#=============================
function centosSoporte() {
    #Este seria el equipo para correr scripts
    #primero actualiza la maquina
    yum update -y
    yum install -y epel-release
    #luego instala lo primordial
	yum install -y curl htop lynx mc git neovim mc zsh cifs-utils nfs-utils net-tools bind-utils
    #preguntamos el hostname deseado lo leemos de pantalla y lo asignamos
    echo -ne " Que nombre de equipo quiere?"
    read -r hostnamE
    hostnamectl set-hostname $hostnamE
    #montamos las unidades de trabajo
    monuntPro
    #pasamos a installar colorsripts y ohmyzsh
    mkdir -p /installers/startupConfigs
    scp sesquivels@192.168.100.235:/zroot/general/configs/startUPS/setupRHEL.tar.gz /installers/startupConfigs
    cd /installers/startupConfigs
    tar xvf setupRHEL.tar.gz
    cd firstSetupRHEL
    ./ohmyzsh.sh
    ./colorscripts.sh
    cp .zshrc ~/.zshrc
    exit 0
}

function centosNFS() {
    #Este seria el equipo para alojar el nfs de cdf
    #Se instalan los requisitos del nfs server
    yum install -y bind-utils nfs-utils
    #Se crean los directorios y se cambia el permision set
    mkdir -p /opt/arcsight-nfs/itom-vol /opt/arcsight-nfs/db-single-vol /opt/arcsight-nfs/db-backup-vol /opt/arcsight-nfs/itom-logging-vol /opt/arcsight-nfs/arcsight-volume/opt/arcsight-nfs/itom-vol/opt/arcsight-nfs/db-single-vol/opt/arcsight-nfs/db-backup-vol/opt/arcsight-nfs/itom-logging-vol/opt/arcsight-nfs/arcsight-volume
    chown -R 1999:1999 /opt/arcsight-nfs
    #se carga la config a exports eso si el dom local si se tiene que cambiar de dominio se cambia de nombre o se usa la subred 10.14.10.0/24 o se usa *
    echo "/opt/arcsight-nfs/itom-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/db-single-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/db-backup-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/itom-logging-vol dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    echo "/opt/arcsight-nfs/arcsight-volume dom.local (rw,sync,anonuid=1999,anongid=1999,all_squash)" | tee -a /etc/exports
    exportfs -ra
    # se levantan los servicios y se baja el firewall
    systemctl enable rpcbind
    systemctl start rpcbind
    systemctl enable nfs-server
    systemctl start nfs-server
    systemctl disable firewalld
    systemctl stop firewalld
}

function centosLogger() {

    #Este es el script para instalar el logger software
    #primero los requisitos con base a la version de Centos RHEL
    
    echo -ne "Que version de Centos es? 7 u 8?"
    read -r sub

    case $sub in
    7)
        yum install -y unzip fontconfig dejavu-sans-fonts
        ;;
    8)
        dnf install -y unzip fontconfig dejavu-sans-fonts libnsl compat-openssl10 ncurses-compat-libs rng-tools
        systemctl start rngd.service
        systemctl enable rngd.service
        ;;
    *)
        echo "Wrong option."
        exit 1
        ;;
    esac
    #Se agregan el usuario y grupo
    groupadd –g 750 arcsight
    useradd –m –g arcsight –u 1500 arcsight

    #se abren los limites
    echo "* soft nproc 10240" | tee -a /etc/security/limits.d/20-nproc.conf
    echo "* hard nproc 10240" | tee -a /etc/security/limits.d/20-nproc.conf
    echo "* soft nofile 65536" | tee -a /etc/security/limits.d/20-nproc.conf
    echo "* hard nofile 65536" | tee -a /etc/security/limits.d/20-nproc.conf

    sed -i 's/#RemoveIPC=no/RemoveIPC=no/' /etc/systemd/logind.conf
    systemctl restart systemd-logind.service

    echo "net.ipv4.tcp_fin_timeout = 30" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_time = 60" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_intvl = 2" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_keepalive_probes = 2" | tee -a /etc/sysctl.conf
    
    sysctl -p

    #segenera la carpeta y se copia el instalador necesario
    cd /opt 
    mkdir loggerInstall
    cd loggerInstall

    echo -ne "Que version de Logger? 
    1) Logger 7.2.2
    2) Logger 7.1
    3) Logger 7.0"
    #por ultimo le damos privilegios de ejecucion y corremos el instalador
    read -r logg
    case $logg in
    1)
        scp sesquivels@192.168.100.235:/zroot/MF_Data/Installers/Logger/7.2.2/ArcSight-logger-7.2.2.8402.0.bin .
        chmod +x ArcSight-logger-7.2.2.8402.0.bin
        ./ArcSight-logger-7.2.2.8402.0.bin -i console 
        ;;
    2)
        scp sesquivels@192.168.100.235:/zroot/MF_Data/Installers/Logger/7.1/ArcSight-logger-7.1.0.8337.0.bin .
        chmod +x ArcSight-logger-7.1.0.8337.0.bin
        ./ArcSight-logger-7.1.0.8337.0.bin -i console
        ;;
    3)
        scp sesquivels@192.168.100.235:/zroot/MF_Data/Installers/Logger/7.0/ArcSight-logger-7.0.1.8316.0.bin .
        chmod +x ArcSight-logger-7.0.1.8316.0.bin
        ./ArcSight-logger-7.0.1.8316.0.bin -i console
        ;;
    esac
    
}

function centosArcmc() {

    #Este es el script para instalar el logger software
    #primero los requisitos con base a la version de Centos RHEL
    
    echo -ne "Que version de Centos es? 7 u 8?"
    read -r sub

    case $sub in
    7)
        yum install -y unzip fontconfig dejavu-sans-fonts perl
        ;;
    8)
        dnf install -y unzip fontconfig dejavu-sans-fonts perl
        ;;
    *)
        echo "Wrong option."
        exit 1
        ;;
    esac
    #Se agregan el usuario y grupo
    groupadd –g 750 arcsight
    useradd –m –g arcsight –u 1500 arcsight

    #se abren los limites
    echo "* soft nproc 10240" | tee -a /etc/security/limits.conf
    echo "* hard nproc 10240" | tee -a /etc/security/limits.conf


    sed -i 's/#RemoveIPC=no/RemoveIPC=no/' /etc/systemd/logind.conf
    systemctl restart systemd-logind.service

 

    #segenera la carpeta y se copia el instalador necesario
    cd /opt 
    mkdir ArcmcInstall
    cd arcmcInstall

    echo -ne "Que version de Logger? 
    1) Arcmc 3.0
    2) Arcmc 3.1"
    #por ultimo le damos privilegios de ejecucion y corremos el instalador
    read -r arcmcd
    case $arcmcd in
    1)
        scp sesquivels@192.168.100.235:/zroot/MF_Data/Installers/Arcmc/ArcSight-ArcMC-3.0.0.2236.0.bin .
        chmod +x ArcSight-ArcMC-3.0.0.2236.0.bin
        ./ArcSight-ArcMC-3.0.0.2236.0.bin -i console 
        ;;
    2)
        scp sesquivels@192.168.100.235:/zroot/MF_Data/Installers/Arcmc/3.1/ArcSight-ArcMC-3.1.0.2266.0.bin .
        chmod +x ArcSight-ArcMC-3.1.0.2266.0.bin
        ./ArcSight-ArcMC-3.1.0.2266.0.bin -i console
        ;;
    esac
    
}


#=============================
#---------Main Program--------
#=============================
#este llama a todos
mainmenu
