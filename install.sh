#!/bin/bash
#: Description: Installs pifacedigitalio and its dependecies

# check if the script is being run as root
if [[ $EUID -ne 0 ]]
then
	printf 'This script must be run as root.\nExiting..\n'
	exit 1
fi

#installs python3
pacman -S --needed python

#installs make
pacman -S --needed make

#installs gcc dependency for make
pacman -S --needed gcc

# depends on pifacecommon
python3 -c "import pifacecommon" # is it installed?
if [ $? -ne 0 ]
then
    # install pifacecommon
    printf "Downloading pifacecommon...\n"
    git clone https://github.com/piface/pifacecommon.git
    cd pifacecommon
    #python3 setup.py install
    ./install.sh
    cd -
    printf "\n"
fi

# depends on gpio-admin (no point re-inventing the wheel)
type gpio-admin > /dev/null 2>&1 # is it installed?
if [ $? -ne 0 ]
then
    # install gpio-admin
    printf "Installing gpio-admin...\n"
    git clone https://github.com/quick2wire/quick2wire-gpio-admin.git
    cd quick2wire-gpio-admin
    make
    make install
    gpasswd -a pi gpio
    cd -
    printf "\n"
fi

# install python library
printf "Installing pifacedigitalio...\n"
python3 setup.py install
printf "Done!\n"
