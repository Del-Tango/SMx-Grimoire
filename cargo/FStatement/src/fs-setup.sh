#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

function project_setup () {
    lock_and_load
    load_config
}

# LOADERS

function load_config () {
    load_project_label
    load_project_prompt
    load_project_default
    load_project_logging_levels
    load_project_cargo
    load_project_dependencies
}

function load_project_dependencies () {
    load_apt_dependencies ${FS_APT_DEPENDENCIES[@]}
    return $?
}

function load_project_prompt () {
    load_prompt_string "$FS_PS3"
    return $?
}

function load_project_logging_levels () {
    load_logging_levels ${FS_LOGGING_LEVELS[@]}
    return $?
}

function load_project_cargo () {
    if [ ${#FS_CARGO[@]} -eq 0 ]; then
        warning_msg "No cargo scripts found docked to $FS_SCRIPT_NAME."
        return 1
    fi
    for cargo in ${!FS_CARGO[@]}; do
        load_cargo "$cargo" "${FS_CARGO[$cargo]}"
    done
    return $?
}

function load_project_default () {
    for setting in ${!FS_DEFAULT[@]}; do
        load_default_setting "$setting" "${FS_DEFAULT[$setting]}"
    done
    return $?
}

function load_project_label () {
    load_script_name "$FS_SCRIPT_NAME"
    return $?
}
