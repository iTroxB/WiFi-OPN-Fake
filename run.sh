#!/bin/bash
# Author: iTrox

######################################################
#################### COLOURS EDIT ####################
######################################################
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

###################################################
#################### FUNCTIONS ####################
###################################################

# Bye Ctrl+C
function ctrl_c(){
    echo -e "\n\n ${red}[!] Exit...${end}\n"
    tput cnorm && exit 1
}
trap ctrl_c INT

# Banner
print_banner() {
    echo;
    echo -e " ${yellow}  _       ___ _______    ____  ____  _   __   ______      __ ${end}"
    echo -e " ${yellow} | |     / (_) ____(_)  / __ \/ __ \/ | / /  / ____/___ _/ /_____ ${end}"
    echo -e " ${yellow} | | /| / / / /_  / /  / / / / /_/ /  |/ /  / /_  / __ '/ //_/ _ \ ${end}"
    echo -e " ${yellow} | |/ |/ / / __/ / /  / /_/ / ____/ /|  /  / __/ / /_/ / ,< /  __/ ${end}"
    echo -e " ${yellow} |__/|__/_/_/   /_/   \\____/_/   /_/ |_/  /_/    \__,_/_/|_|\\___/ ${end}\n\n"
    echo -e "  ${turquoise}Web template and Go server to implement Evil Twin Wi-Fi attack by Rogue AP. ${end}"
    echo -e "  ${turquoise}Version 1.0${end}"
    echo -e "  ${blue}Made by iTrox${end}\n"
}


# Arch run 
function run_arch {
    echo -e "\n${turquoise}➤${end} ${gray}Updated repositories and system...${end}"
    sudo pacman -Syu --noconfirm
    
    # Install Go
    if [ "$(which go)" == "/usr/bin/go" ]; then
        echo -e "\n ${green}[✔]${end} ${blue}Go${end} ${gray}installed...${end}\n"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Go${end} ${gray}is not installed on your system...${end}"
        echo -e "\n ${turquoise}[➤]${end} ${gray}Installing${end} ${blue}Go${end}${gray}...${end}"
        sudo pacman -S go --noconfirm
        echo -e "\n ${green}[✔]${end} ${blue}Go${end} ${gray}has successfully installed on your system...${end}"
    fi

    # Install Apache
    if [ "$(which httpd)" == "/usr/bin/httpd" ]; then
        echo -e "\n ${green}[✔]${end} ${blue}Apache${end} ${gray}installed...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Apache${end} ${gray}is not installed on your system...${end}"
        echo -e "\n ${turquoise}[➤]${end} ${gray}Installing${end} ${blue}Apache${end}${gray}...${end}"
        sudo pacman -S apache --noconfirm
        echo -e "\n ${green}[✔]${end} ${blue}Apache${end} ${gray}has successfully installed on your system...${end}"
    fi

    # Install PHP
    if [ "$(which php)" == "/usr/bin/php" ]; then
        echo -e "\n ${green}[✔]${end} ${blue}PHP${end} ${gray}installed...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}PHP${end} ${gray}is not installed on your system...${end}"
        echo -e "\n ${turquoise}[➤]${end} ${gray}Installing${end} ${blue}PHP${end}${gray}...${end}"
        sudo pacman -S php --noconfirm
        echo -e "\n ${green}[✔]${end} ${blue}PHP${end} ${gray}has successfully installed on your system...${end}"
    fi

    # Run apache server
    echo -e "\n${turquoise}➤${end} ${gray}Run apache service...${end}"
    sudo systemctl start httpd.service
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${blue}Apache${end} ${gray}started successfully...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Apache${end} ${gray}failed to start...${end}"
        exit 1
    fi

    # Copy code source to /srv/http path
    sudo cp -r /opt/WiFi-OPN-Fake/* /srv/http/
    sudo rm -rf /srv/http/run.sh
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${gray}Code source in /srv/http path...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${gray}Code source failed...${end}"
        exit 1
    fi

    # Compiling Go server
    echo -e "\n${turquoise}➤${end} ${gray}Compiling Go server...${end}"
    sudo go build -o wifiServer /srv/http/server.go
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${gray}Go server compiled ok...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${gray}Go server compiled failed...${end}"
        exit 1
    fi

    # Run Go server
    echo -e "\n${turquoise}➤${end} ${gray}Run Go server...${end}"
    sleep 5
    cd /srv/http
    sudo ./wifiServer
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${gray}Run Go server in 127.0.0.1:8888...${end}"
        echo -e "\n ${green}[✔]${end} ${gray}Open browser in 127.0.0.1 to visit the website created for the Rogue AP${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Go server failured running...${end}"
        exit 1
    fi
}

# Debian run
function run_debian {
    echo -e "\n${turquoise}➤${end} ${gray}Updated repositories and system...${end}"
    sudo apt update && sudo apt upgrade -y
    
    # Install Go
    if [ "$(which go)" == "/usr/bin/go" ]; then
        echo -e "\n ${green}[✔]${end} ${blue}Go${end} ${gray}installed...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Go${end} ${gray}is not installed on your system...${end}"
        echo -e "\n ${turquoise}[➤]${end} ${gray}Installing${end} ${blue}Go${end}${gray}...${end}"
        sudo apt install golang-go -y
        echo -e "\n ${green}[✔]${end} ${blue}Go${end} ${gray}has successfully installed on your system...${end}"
    fi

    # Install Apache
    if [ "$(which httpd)" == "/usr/bin/httpd" ]; then
        echo -e "\n ${green}[✔]${end} ${blue}Apache${end} ${gray}installed...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Apache${end} ${gray}is not installed on your system...${end}"
        echo -e "\n ${turquoise}[➤]${end} ${gray}Installing${end} ${blue}Apache${end}${gray}...${end}"
        sudo apt install apache2 -y
        echo -e "\n ${green}[✔]${end} ${blue}Apache${end} ${gray}has successfully installed on your system...${end}"
    fi

    # Install PHP
    if [ "$(which php)" == "/usr/bin/php" ]; then
        echo -e "\n ${green}[✔]${end} ${blue}PHP${end} ${gray}installed...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}PHP${end} ${gray}is not installed on your system...${end}"
        echo -e "\n ${turquoise}[➤]${end} ${gray}Installing${end} ${blue}PHP${end}${gray}...${end}"
        sudo apt install php libapache2-mod-php -y
        echo -e "\n ${green}[✔]${end} ${blue}PHP${end} ${gray}has successfully installed on your system...${end}"
    fi

    # Run apache server
    echo -e "\n${turquoise}➤${end} ${gray}Run apache service...${end}"
    sudo systemctl start apache2.service
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${blue}Apache${end} ${gray}started successfully...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Apache${end} ${gray}failed to start...${end}"
        exit 1
    fi

    # Copy code source to /var/www/http path
    sudo cp -r /opt/WiFi-OPN-Fake/* /var/www/html/
    sudo rm -rf /var/www/html/run.sh
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${gray}Code source in /var/www/html path...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${gray}Code source failed...${end}"
        exit 1
    fi

    # Compiling Go server
    echo -e "\n${turquoise}➤${end} ${gray}Compiling Go server...${end}"
    sudo go build -o wifiServer /var/www/html/server.go
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${gray}Go server compiled ok...${end}"
    else
        echo -e "\n ${red}[✘]${end} ${gray}Go server compiled failed...${end}"
        exit 1
    fi

    # Run Go server
    echo -e "\n${turquoise}➤${end} ${gray}Run Go server...${end}"
    sudo ./var/www/html/wifiServer
    if [ $? -eq 0 ]; then
        echo -e "\n ${green}[✔]${end} ${gray}Run Go server in 127.0.0.1:8888...${end}"
        echo -e "\n ${green}[✔]${end} ${gray}Open browser in 127.0.0.1 to visit the website created for the Rogue AP${end}"
    else
        echo -e "\n ${red}[✘]${end} ${blue}Go server failured running...${end}"
        exit 1
    fi
}

# Main function
main() {
    source /etc/os-release
    if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
        echo -e "\n${turquoise}➤${end} ${gray}Arch Linux distribution detected...${end}"
        run_arch
    elif [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
        echo -e "\n${turquoise}➤${end} ${gray}Debian distribution detected...${end}"
        run_debian
    else
        echo "Distribución no compatible o no reconocida."
        exit 1
    fi
}

####################################################
#################### RUN SCRIPT ####################
####################################################
print_banner
main
