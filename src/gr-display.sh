#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_project_settings () {
    display_formatted_settings | column
    echo; return $?
}

function display_banners () {
    clear && ${GR_CARGO['cold-banner']} && ${GR_CARGO['hot-banner']} ${GR_DEFAULT['conf-file']}
    return $?
}

function display_formatted_settings () {
    display_formatted_project_root
    display_formatted_setting_conf_file
    display_formatted_setting_log_file
    display_formatted_setting_log_lines
    display_formatted_setting_safety_flag
    return 0
}

function display_formatted_project_root () {
    if [ ! -z ${MD_DEFAULT['project-path']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['project-path']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Project Root${RESET}        ]: ${BLUE}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_conf_file () {
    if [ ! -z ${MD_DEFAULT['conf-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['conf-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Conf File${RESET}           ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_log_file () {
    if [ ! -z ${MD_DEFAULT['log-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['log-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Log File${RESET}            ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_log_lines () {
    echo "[ ${CYAN}Log Lines${RESET}           ]: ${WHITE}${MD_DEFAULT['log-lines']:-${RED}Unspecified}${RESET} lines"
    return $?
}


function display_formatted_setting_safety_flag () {
    local FORMATTED=`format_flag_colors "$MD_SAFETY"`
    echo "[ ${CYAN}Safety${RESET}              ]: ${FORMATTED:-${RED}Unspecified}${RESET}"
    return $?
}


