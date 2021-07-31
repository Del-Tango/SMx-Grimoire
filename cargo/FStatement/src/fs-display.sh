#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_registered_action_count () {
    local ACTIONS=`fetch_action_count`
    if [ $? -ne 0 ]; then
        local DISPLAY="${RED}Unknown${RESET}"
    else
        local DISPLAY="${WHITE}${ACTIONS}${RESET}"
    fi
    echo "    [ ${CYAN}Actions Registered${RESET} ]: $DISPLAY"
    return $?
}

function display_registered_project_count () {
    local PROJECTS=`fetch_project_count`
    if [ $? -ne 0 ]; then
        local DISPLAY="${RED}Unknown${RESET}"
    else
        local DISPLAY="${WHITE}${PROJECTS}${RESET}"
    fi
    echo "    [ ${CYAN}Projects Registered${RESET} ]: $DISPLAY"
    return $?
}

function display_registered_version_count () {
    local VERSIONS=`fetch_version_count`
    if [ $? -ne 0 ]; then
        local DISPLAY="${RED}Unknown${RESET}"
    else
        local DISPLAY="${WHITE}${VERSIONS}${RESET}"
    fi
    echo "    [ ${CYAN}Versions Registered${RESET} ]: $DISPLAY"
    return $?
}

function display_bill_of_materials_database () {
    if [ -z "${MD_DEFAULT['bom-db']}" ]; then
        local DISPLAY="${RED}Unknown${RESET}"
    else
        local DIR_NAME=`dirname ${MD_DEFAULT['bom-db']} | awk -F/ '{print $NF}'`
        local FL_NAME=`basename ${MD_DEFAULT['bom-db']}`
        local SHORT="${DIR_NAME}/${FL_NAME}"
        local DISPLAY="${YELLOW}${SHORT}${RESET}"
    fi
    echo "    [ ${CYAN}Bills Of Materials${RESET} ]: $DISPLAY"
    return $?
}

function display_formatted_stats () {
    display_bill_of_materials_database
    display_registered_action_count
    display_registered_project_count
    display_registered_version_count
    return $?
}

function display_stats () {
    display_formatted_stats | column
    return $?
}


FS_SCRIPT_NAME='F.Statement'
FS_PS3='FStatement> '
FS_VERSION='KnowItAll'
FS_VERSION_NUMBER='1.0'


function display_header () {
     cat <<EOF

    ___________________________________________________________________________

     *              *            *  ${FS_SCRIPT_NAME}  *             *             *
    _____________________________________________________v${FS_VERSION_NUMBER}${FS_VERSION}_________
                       Regards, the Alveare Solutions society

EOF
    return $?
}


