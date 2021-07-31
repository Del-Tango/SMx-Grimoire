#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# HOT BANNER

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

declare -A GR_DEFAULT

CONFIG_FILE_PATH="$1"
HB_DIRECTORY=$(
    cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd
)
GR_DIRECTORY="$HB_DIRECTORY/.."
if [ -r "$CONFIG_FILE_PATH" ]; then
    source "$CONFIG_FILE_PATH"
else
    echo "[ WARNING ]: Could not source config file! (${CONFIG_FILE_PATH})"
fi

function display_internet_access () {
    ping -c 1 github.com &> /dev/null
    case $? in
        0)
            echo "${GREEN}ON${RESET}"
            ;;
        *)
            echo "${RED}OFF${RESET}"
            ;;
    esac
    return $?
}

function display_external_ipv4_address () {
    curl whatismyip.akamai.com 2> /dev/null
    return $?
}

function display_local_ipv4_address () {
    ifconfig | grep inet | grep '\.' | grep broadcast | awk '{print $2}'
    return $?
}

function display_network_details () {
    display_formatted_external_ipv4
    display_formatted_local_ipv4
    return $?
}

function display_machine_details () {
    display_formatted_hostname
    display_formatted_username
    return $?
}

function display_formatted_timestamp () {
    echo "${CYAN}System Time${RESET}   : ${MAGENTA}`date`${RESET}"
    return $?
}

function display_formatted_external_ipv4 () {
    echo "${CYAN}External IPv4${RESET} : ${MAGENTA}`display_external_ipv4_address`${RESET}"
    return $?
}

function display_formatted_local_ipv4 () {
    echo "${CYAN}Local IPv4${RESET}    : ${MAGENTA}`display_local_ipv4_address`${RESET}"
    return $?
}

function display_formatted_hostname () {
    echo "${CYAN}Machine${RESET}       : ${BLUE}`hostname`${RESET}"
    return $?
}

function display_formatted_username () {
    echo "${CYAN}Practitioner${RESET}  : ${RED}`whoami`${RESET}"
    return $?
}

function display_hot_banner () {
    display_network_details | column
    display_machine_details | column
    display_formatted_timestamp
    return $?
}

display_hot_banner
