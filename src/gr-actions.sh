#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function action_init_fstatement () {
    ${GR_CARGO['f-statement']}
    return $?
}

function action_view_occult_scripture_tree () {
    echo; info_msg "${BLUE}${SCRIPT_NAME}${RESET} occult scripture tree -
    "
    tree ${MD_DEFAULT['notes-dir']}
    return $?
}

function action_create_occult_text_category () {
    while :; do
        echo; info_msg "Existing scripture categories -
        "
        ls ${MD_DEFAULT['notes-dir']}
        echo; info_msg "Type new Grimoire scripture category name or (${MAGENTA}.back${RESET})
        "
        local DIR_NAME=`fetch_data_from_user "${MAGENTA}NewCategory${RESET}"`
        if [ $? -ne 0 ] || [ -z "$DIR_NAME" ]; then
            return 1
        fi; echo
        local DIR_PATH="${MD_DEFAULT['notes-dir']}/${DIR_NAME}"
        mkdir -p ${DIR_PATH} &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Could not create Grimoire scripture category!"\
                "(${RED}$DIR_NAME${RESET})"
        else
            ok_msg "Successfully created Grimoire scripture category!"
        fi
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
    done
    return $?
}

function action_purge_occult_text_category () {
    while :; do
        local CATEGORIES=( `ls ${MD_DEFAULT['notes-dir']}` )
        echo; info_msg "Select category to purge-
        "
        local DIR_NAME=`fetch_selection_from_user "${MAGENTA}Category${RESET}" \
            ${CATEGORIES[@]}`
        if [ $? -ne 0 ] || [ -z "$DIR_NAME" ]; then
            return 1
        fi; echo
        local DIR_PATH="${MD_DEFAULT['notes-dir']}/${DIR_NAME}"
        info_msg "Purging scripture category... (${RED}${DIR_NAME}${RESET})"
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Are you sure about this? ${RED}Y${RESET}/${GREEN}N${RESET}"
        if [ $? -ne 0 ]; then
            info_msg "Aborting action."
            continue
        fi
        rm -rf "${DIR_PATH}" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Could not delete scripture category from Grimoire!"\
                "(${RED}$FILE_NAME${RESET})"
        else
            ok_msg "Successfully purged scripture category from Grimoire!"
        fi
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
    done
    return $?
}

function action_delete_occult_text_scripture () {
    local CATEGORIES=( `ls ${MD_DEFAULT['notes-dir']}` )
    echo; info_msg "Select category -
    "
    local DIR_NAME=`fetch_selection_from_user "${MAGENTA}Category${RESET}" \
        ${CATEGORIES[@]}`
    if [ $? -ne 0 ] || [ -z "$DIR_NAME" ]; then
        return 1
    fi
    local DIR_PATH="${MD_DEFAULT['notes-dir']}/${DIR_NAME}"
    local OCCULT_TEXTS=( `ls "${DIR_PATH}"` )
    while :; do
        echo; info_msg "Select occult ${BLUE}${DIR_NAME}${RESET} text to delete -
        "
        local FILE_NAME=`fetch_selection_from_user "${MAGENTA}OccultText${RESET}" ${OCCULT_TEXTS[@]}`
        if [ $? -ne 0 ] || [ -z "$FILE_NAME" ]; then
            break
        fi; echo
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Are you sure about this? ${RED}Y${RESET}/${GREEN}N${RESET}"
        if [ $? -ne 0 ]; then
            info_msg "Aborting action."
            continue
        fi
        info_msg "Purging occult text... (${RED}${FILE_NAME}${RESET})"
        rm -rf "${DIR_PATH}/${FILE_NAME}" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Could not delete occult text from Grimoire!"\
                "(${RED}$FILE_NAME${RESET})"
        else
            ok_msg "Successfully purged occult text from Grimoire!"
        fi; echo
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
    done
    return $?
}

function action_delete_fucking_everything () {
    echo; symbol_msg "${RED}DFE${RESET}" "Purging all Grimoire scripture categories and occult texts..."
    fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Are you sure about this? ${RED}Y${RESET}/${GREEN}N${RESET}"
    if [ $? -ne 0 ]; then
        info_msg "Aborting action."
        return 0
    fi
    rm -rf ${MD_DEFAULT['notes-dir']}/* &> /dev/null
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Could not purge all occult texts from Grimoire!"\
            "(${RED}${MD_DEFAULT['notes-dir']}${RESET})"
    else
        ok_msg "Successfully purged all occult texts from Grimoire!"
    fi
    return $EXIT_CODE
}

function action_manage_occult_texts () {
    local OPTIONS=( 'Create-Category' 'Purge-Category' 'Delete-Notes' 'DFE' )
    echo
    local OPTION=`fetch_selection_from_user \
        "${MAGENTA}ScriptureManager${RESET}" ${OPTIONS[@]}`
    if [ $? -ne 0 ] || [ -z "$OPTION" ]; then
        info_msg "Aborting action."
        return 0
    fi
    while :; do
        case "$OPTION" in
            'Create-Category')
                action_create_occult_text_category
                ;;
            'Purge-Category')
                action_purge_occult_text_category
                ;;
            'Delete-Notes')
                action_delete_occult_text_scripture
                ;;
            'DFE')
                action_delete_fucking_everything
                ;;
            *)
                warning_msg "Invalid action! (${RED}${OPTION}${RESET})"
                continue
                ;;
        esac
        local EXIT_CODE=$?
        break
    done
    return $EXIT_CODE
}

function action_write_occult_text () {
    local CATEGORIES=( `ls ${MD_DEFAULT['notes-dir']}` )
    echo; info_msg "Select category for action (write) -
    "
    local DIR_NAME=`fetch_selection_from_user "${MAGENTA}Category${RESET}" \
        ${CATEGORIES[@]}`
    if [ $? -ne 0 ] || [ -z "$DIR_NAME" ]; then
        return 1
    fi
    local DIR_PATH="${MD_DEFAULT['notes-dir']}/${DIR_NAME}"
    echo; info_msg "Typing a non-existing file name creates it under the"\
        "selected category."
    info_msg "Existing occult texts -
    "
    ls "${DIR_PATH}"
    while :; do
        echo; info_msg "Type file name or (${MAGENTA}.back${RESET}) -
        "
        local FILE_NAME=`fetch_data_from_user "${MAGENTA}OccultText${RESET}"`
        if [ $? -ne 0 ] || [ -z "$FILE_NAME" ]; then
            break
        fi
        ${MD_DEFAULT['editor']} ${MD_DEFAULT['editor-write-args']} \
            "${DIR_PATH}/${FILE_NAME}"
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            warning_msg "Failures detected! ($EXIT_CODE)"
        fi; echo
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        echo; info_msg "Typing a non-existing file name creates it under the"\
        "selected category."
        info_msg "Existing occult texts -
        "
        ls "${DIR_PATH}"
    done
    return $?
}

function action_read_occult_text () {
    local CATEGORIES=( `ls ${MD_DEFAULT['notes-dir']}` )
    echo; info_msg "Select scripture category for action (read) -
    "
    local DIR_NAME=`fetch_selection_from_user "${MAGENTA}Category${RESET}" \
        ${CATEGORIES[@]}`
    if [ $? -ne 0 ] || [ -z "$DIR_NAME" ]; then
        return 1
    fi
    local DIR_PATH="${MD_DEFAULT['notes-dir']}/${DIR_NAME}"
    local OCCULT_TEXTS=( `ls "${DIR_PATH}"` )
    if [ ${#OCCULT_TEXTS[@]} -eq 0 ]; then
        echo; warning_msg "No occult texts found under scripture category!"\
            "(${RED}${DIR_NAME}${RESET})"
        return 0
    fi
    while :; do
        echo; info_msg "Select occult ${BLUE}${DIR_NAME}${RESET} text for action (read) -
        "
        local FILE_NAME=`fetch_selection_from_user 'OccultText' ${OCCULT_TEXTS[@]}`
        if [ $? -ne 0 ] || [ -z "$FILE_NAME" ]; then
            break
        fi
        ${MD_DEFAULT['editor']} ${MD_DEFAULT['editor-readonly-args']} \
            "${DIR_PATH}/${FILE_NAME}"
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            warning_msg "Failures detected! ($EXIT_CODE)"
        fi; echo
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
    done
    return $?
}

function action_lecrik_eyz_cheat_sheet () {
    clear && ${GR_CARGO['lectrik-eyz']} --help
    info_msg "Type cheat sheet args or (${MAGENTA}.back${RESET}) -"
    while :; do
        local CARGO_ARGS=`fetch_data_from_user "${BLUE}Lectrik:Eyz${RESET}"`
        if [ $? -ne 0 ] || [ -z "$CARGO_ARGS" ]; then
            break
        fi; echo
        ${GR_CARGO['lectrik-eyz']} $CARGO_ARGS
        local EXIT_CODE=$?; echo
        if [ $EXIT_CODE -ne 0 ]; then
            warning_msg "Failures detected! (${RED}${EXIT_CODE}${RESET})
            "
        fi
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi; echo
        info_msg "Type cheat sheet args or (${MAGENTA}.back${RESET}) -"
    done
    return $?
}

function action_star_link_cheat_sheet () {
    clear && ${GR_CARGO['star-link']} --help
    info_msg "Type cheat sheet args or (${MAGENTA}.back${RESET}) -"
    while :; do
        local CARGO_ARGS=`fetch_data_from_user "${BLUE}StarLink${RESET}"`
        if [ $? -ne 0 ] || [ -z "$CARGO_ARGS" ]; then
            break
        fi; echo
        ${GR_CARGO['star-link']} $CARGO_ARGS
        local EXIT_CODE=$?; echo
        if [ $EXIT_CODE -ne 0 ]; then
            warning_msg "Failures detected! (${RED}${EXIT_CODE}${RESET})
            "
        fi
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi; echo
        info_msg "Type cheat sheet args or (${MAGENTA}.back${RESET}) -"
    done
    return $?
}

function action_alien_brain_cheat_sheet () {
    clear && ${GR_CARGO['alien-brain']} --help
    info_msg "Type cheat sheet args or (${MAGENTA}.back${RESET}) -"
    while :; do
        local CARGO_ARGS=`fetch_data_from_user "${BLUE}Alien(B)Rain${RESET}"`
        if [ $? -ne 0 ] || [ -z "$CARGO_ARGS" ]; then
            break
        fi; echo
        ${GR_CARGO['alien-brain']} $CARGO_ARGS
        local EXIT_CODE=$?; echo
        if [ $EXIT_CODE -ne 0 ]; then
            warning_msg "Failures detected! (${RED}${EXIT_CODE}${RESET})
            "
        fi
        fetch_ultimatum_from_user "[ ${YELLOW}Q/A${RESET} ]: Would you like to go again? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi; echo
        info_msg "Type cheat sheet args or (${MAGENTA}.back${RESET}) -"
    done
    return $?
}

function action_machine_wizard_magik_cheat_sheets () {
    local CHEAT_SHEETS=( 'lectrik-eyz' 'star-link' 'alien-(b)-rain' )
    echo; info_msg "Select ${RED}Electromancer${RESET} cheat sheet -
    "
    local CARGO_KEY=`fetch_selection_from_user \
        "${MAGENTA}CheatSheet${RESET}" ${CHEAT_SHEETS[@]}`
    if [ $? -ne 0 ] || [ -z "$CARGO_KEY" ]; then
        return 0
    fi
    while :; do
        case "$CARGO_KEY" in
            'lectrik-eyz')
                action_lecrik_eyz_cheat_sheet
                ;;
            'star-link')
                action_star_link_cheat_sheet
                ;;
            'alien-(b)-rain')
                action_alien_brain_cheat_sheet
                ;;
            *)
                warning_msg "Invalid cheat sheet! (${RED}${CARGO_KEY}${RESET})"
                continue
                ;;
        esac; break
    done
    return $?
}

function action_project_self_destruct () {
    echo; info_msg "You are about to delete all (${RED}$SCRIPT_NAME${RESET})"\
        "project files from directory (${RED}${MD_DEFAULT['project-path']}${RESET})."
    fetch_ultimatum_from_user "${YELLOW}Are you sure about this? Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    check_safety_on
    if [ $? -ne 0 ]; then
        echo; warning_msg "Safety is (${GREEN}ON${RESET})!"\
            "Aborting self destruct sequence."
        return 0
    fi; echo
    symbol_msg "${RED}$SCRIPT_NAME${RESET}" "Initiating self destruct sequence!"
    action_self_destruct
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "(${RED}$SCRIPT_NAME${RESET}) self destruct sequence failed!"
    else
        ok_msg "Destruction complete!"\
            "Project (${GREEN}$SCRIPT_NAME${RESET}) removed from system."
    fi
    return $EXIT_CODE
}

function action_install_project_dependencies () {
    action_install_dependencies 'apt'
    return $?
}

function action_set_safety_flag () {
    echo; case "$MD_SAFETY" in
        'on'|'On'|'ON')
            info_msg "Safety is (${GREEN}ON${RESET}), switching to (${RED}OFF${RESET}) -"
            action_set_safety_off
            ;;
        'off'|'Off'|'OFF')
            info_msg "Safety is (${RED}OFF${RESET}), switching to (${GREEN}ON${RESET}) -"
            action_set_safety_on
            ;;
        *)
            info_msg "Safety not set, switching to (${GREEN}ON${RESET}) -"
            action_set_safety_on
            ;;
    esac
    return $?
}

