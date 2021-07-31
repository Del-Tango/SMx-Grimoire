#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# TEST SUIT

function run_test_suit () {
    local EXIT_CODE=0
    test_search_bom_by_id
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_search_bom_by_action
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_search_bom_by_project
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_search_bom_by_version
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_dump_bom_ids
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_dump_bom_actions
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_dump_bom_projects
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_dump_bom_versions
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_dump_bills_of_materials
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_dump_bom_all
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_update_record
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_delete_record
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_project_setup
    local EXIT_CODE=$((EXIT_CODE + $?))
    symbol_msg "${BLUE}TEST-SUIT${RESET}" "${SCRIPT_NAME} (v.${EY_VERSION})"
    display_test_case_status $EXIT_CODE
    return $EXIT_CODE
}

function test_search_bom_by_id () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file="${MD_DEFAULT['log-file']}" \
        --action='search' \
        --search='bom-id' \
        --bom-id='eyv10341file' \
        --silent
    return $?
}

function test_search_bom_by_action () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='search' \
        --search='action' \
        --bom-action='Rename-Binary-Payloads'
    return $?
}

function test_search_bom_by_project () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='search' \
        --search='project' \
        --bom-project='EvilYuri'
    return $?
}

function test_search_bom_by_version () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='search' \
        --search='version' \
        --bom-version='v1.0Electromancer'
    return $?
}

function test_dump_bom_ids () {
    local EXIT_CODE=0
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        --dump='bom-id'
    local EXIT_CODE=$((EXIT_CODE + $?))
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        -I
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

function test_dump_bom_actions () {
    local EXIT_CODE=0
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        --dump='action'
    local EXIT_CODE=$((EXIT_CODE + $?))
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        -A
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

function test_dump_bom_projects  () {
    local EXIT_CODE=0
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        --dump='project'
    local EXIT_CODE=$((EXIT_CODE + $?))
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        -P
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

function test_dump_bom_versions () {
    local EXIT_CODE=0
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        --dump='version'
    local EXIT_CODE=$((EXIT_CODE + $?))
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        -V
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

function test_dump_bills_of_materials () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        --dump='bom'
    return $?
}

function test_dump_bom_all () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='dump' \
        --dump='all'
    return $?
}

function test_update_record () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='update' \
        --bom-record='TODO,Bom,Record,4,5'
    return $?
}

function test_delete_record () {
    ${MD_CARGO['fstatement']} \
        --bom-db=${MD_DEFAULT['bom-db']} \
        --log-file=${MD_DEFAULT['log-file']} \
        --action='delete' \
        --bom-id='TODO'
    return $?
}

function test_project_setup () {
    warning_msg "Under construction, building..."
    sudo ${MD_CARGO['fstatement']} --setup
}


function display_test_case_status () {
    local EXIT_CODE=$1
    local MSG="EXIT CODE ($EXIT_CODE) - `date +%D-%T`"
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "$MSG"
    else
        ok_msg "$MSG"
    fi
    return $EXIT_CODE
}

