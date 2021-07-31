#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

function project_setup () {
    lock_and_load
    load_project_config
    create_menu_controllers
    setup_project_menu_controllers
    return 0
}

function setup_project_menu_controllers () {
    setup_project_dependencies
    setup_main_menu_controller
    setup_settings_menu_controller
    setup_log_viewer_menu_controller
    setup_occult_texts_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."
    return 0
}

# LOADERS

function load_project_config () {
    load_project_script_name
    load_project_prompt_string
    load_settings_project_default
    load_project_logging_levels
    load_project_cargo_scripts
}

function load_project_cargo_scripts () {
    if [ ${#GR_CARGO[@]} -eq 0 ]; then
        warning_msg "No cargo scripts found docked to $GR_SCRIPT_NAME."
        return 1
    fi
    for cargo in ${!GR_CARGO[@]}; do
        load_cargo "$cargo" "${GR_CARGO[$cargo]}"
    done
    return $?
}

function load_project_prompt_string () {
    if [ -z "$GR_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    if [ ! -z ${GR_DEFAULT['player-rank']} ]; then
        local PPROMPT="${RED}${GR_DEFAULT['player-rank']}${RESET}> "
    else
        local PPROMPT="${RED}${GR_PS3}${RESET}"
    fi
    set_project_prompt "$PPROMPT"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$GR_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$GR_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_project_logging_levels () {
    if [ ${#GR_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${GR_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_project_default () {
    if [ ${#GR_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for sc_setting in ${!GR_DEFAULT[@]}; do
        MD_DEFAULT[$sc_setting]=${GR_DEFAULT[$sc_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$sc_setting - ${GR_DEFAULT[$sc_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_project_script_name () {
    if [ -z "$GR_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SCRIPT_NAME."
        return 1
    fi
    set_project_name "$GR_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$GR_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$GR_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

# SETUP DEPENDENCIES

function setup_project_dependencies () {
    setup_project_apt_dependencies
    return 0
}

function setup_project_apt_dependencies () {
    if [ ${#GR_APT_DEPENDENCIES[@]} -eq 0 ]; then
        warning_msg "No ${RED}$SCRIPT_NAME${RESET} dependencies found."
        return 1
    fi
    FAILURE_COUNT=0
    SUCCESS_COUNT=0
    for util in ${GR_APT_DEPENDENCIES[@]}; do
        add_apt_dependency "$util"
        if [ $? -ne 0 ]; then
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        else
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    done_msg "(${GREEN}$SUCCESS_COUNT${RESET}) ${BLUE}$SCRIPT_NAME${RESET}"\
        "dependencies staged for installation using the APT package manager."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

# OCCULT SETUP

function setup_occult_texts_menu_controller () {
    setup_occult_textx_menu_option_view_notes
    setup_occult_textx_menu_option_read_note
    setup_occult_textx_menu_option_write_note
    setup_occult_textx_menu_option_manage_notes
    setup_occult_textx_menu_option_back
    done_msg "(${CYAN}$OCCULT_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_occult_textx_menu_option_view_notes () {
    setup_menu_controller_action_option \
        "$OCCULT_CONTROLLER_LABEL" 'View-Notes' 'action_view_occult_scripture_tree'
    return $?
}

function setup_occult_textx_menu_option_read_note () {
    setup_menu_controller_action_option \
        "$OCCULT_CONTROLLER_LABEL" 'Read-Note' 'action_read_occult_text'
    return $?
}

function setup_occult_textx_menu_option_write_note () {
    setup_menu_controller_action_option \
        "$OCCULT_CONTROLLER_LABEL" 'Write-Note' 'action_write_occult_text'
    return $?
}

function setup_occult_textx_menu_option_manage_notes () {
    setup_menu_controller_action_option \
        "$OCCULT_CONTROLLER_LABEL" 'Manage-Notes' 'action_manage_occult_texts'
    return $?
}

function setup_occult_textx_menu_option_back () {
    setup_menu_controller_action_option \
        "$OCCULT_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# SETTINGS SETUP

function setup_settings_menu_controller () {
    setup_settings_menu_option_set_safety_flag
    setup_settings_menu_option_set_log_file
    setup_settings_menu_option_set_log_lines
    setup_settings_menu_option_set_editor
    setup_settings_menu_option_install_dependencies
    setup_settings_menu_option_back
    done_msg "(${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_settings_menu_option_set_editor () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-File-Editor' \
        'action_set_file_editor'
    return $?
}

function setup_settings_menu_option_set_safety_flag () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Safety-Flag' \
        'action_set_safety_flag'
    return $?
}

function setup_settings_menu_option_set_log_file () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-File' \
        'action_set_log_file'
    return $?
}

function setup_settings_menu_option_set_log_lines () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-Lines' \
        'action_set_log_lines'
    return $?
}

function setup_settings_menu_option_install_dependencies () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Install-Dependencies' \
        'action_install_project_dependencies'
    return $?
}

function setup_settings_menu_option_back () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# MAIN MENU SETUP

function setup_main_menu_controller () {
    setup_main_menu_option_machine_wizard
    setup_main_menu_option_occult_texts
    setup_main_menu_option_fstatement
    setup_main_menu_option_self_destruct
    setup_main_menu_option_control_panel
    setup_main_menu_option_log_viewer
    setup_main_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_main_menu_option_fstatement () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" "F-Statement" \
        'action_init_fstatement'
    return $?
}

function setup_main_menu_option_machine_wizard () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" "Machine-Wizard" \
        'action_machine_wizard_magik_cheat_sheets'
    return $?
}

function setup_main_menu_option_occult_texts () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" "Occult-Texts" \
        "$OCCULT_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_self_destruct () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" "Self-Destruct" \
        'action_project_self_destruct'
    return $?
}

function setup_main_menu_option_control_panel () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" 'Control-Panel' \
        "$SETTINGS_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_log_viewer () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL"  "Log-Viewer" \
        "$LOGVIEWER_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_back () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# LOG VIEWER SETUP

function setup_log_viewer_menu_controller () {
    setup_log_viewer_menu_option_display_tail
    setup_log_viewer_menu_option_display_head
    setup_log_viewer_menu_option_display_more
    setup_log_viewer_menu_option_clear_log
    setup_log_viewer_menu_option_back
    done_msg "(${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_log_viewer_menu_option_clear_log () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Clear-Log' 'action_clear_log_file'
    return $?
}

function setup_log_viewer_menu_option_display_tail () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Display-Tail' 'action_log_view_tail'
    return $?
}

function setup_log_viewer_menu_option_display_head () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Display-Head' 'action_log_view_head'
    return $?
}

function setup_log_viewer_menu_option_display_more () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Display-More' 'action_log_view_more'
    return $?
}

function setup_log_viewer_menu_option_back () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Back' 'action_back'
    return $?
}

# CODE DUMP
