#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# F.Statement
# u
# nction

declare -A SYSTEM_COMMANDS
declare -a DEPENDENCIES

# HOT PARAMETERS

BOM_DB=
LOG_FILE=
ACTION='search'                 # (search | dump | update | delete)
DUMP='all'                      # (bom-id | action | project | version | bom | all)
SEARCH='bom-id'                 # (bom-id | action | project | version)
SEARCH_BOM_ID=
SEARCH_ACTION=
SEARCH_PROJECT=
SEARCH_VERSION=
RECORD=
SILENT='off'
DEBUG='off'

# COLD PARAMETERS

SCRIPT_NAME='F.Statement'
DEPENDENCIES=(
'apt'
'touch'
'sed'
'awk'
)
SYSTEM_COMMANDS=(
['install-dependencies']="for pkg in \`echo ${DEPENDENCIES[@]}\`; do apt-get install \${pkg} &> /dev/null && echo \"[ OK ]: Package installed: (\${pkg})\" || echo \"[ NOK ]: Could not install! (\${pkg})\"; done"
)

# CHECKERS

function check_util_installed () {
    local UTIL_NAME="$1"
    type "$UTIL_NAME" &> /dev/null
    return $?
}

# VALIDATORS

function validate_action_delete_data_set () {
    local FAILURE_COUNT=0
    if [ -z "$SEARCH_BOM_ID" ]; then
        log_msg "NOK" "Invalid BOM ID: (${SEARCH_BOM_ID})"
    fi
    local CHECK=`awk -F, -v bom_id="$SEARCH_BOM_ID" \
        '$1 !~ "#" $1 !~ "^$" $1 == bom_id {print $0}' ${BOM_DB}`
    if [ $? -ne 0 ]; then
        log_msg "NOK" "Bill Of Materials ID not registered! (${SEARCH_BOM_ID})"
        local FAILURE_COUNT=$((FAILURE_COUNT + 1))
    else
        log_msg "OK" "Bill Of Materials: (${SEARCH_BOM_ID})"
    fi
    return $FAILURE_COUNT
}

function validate_action_update_data_set () {
    local FAILURE_COUNT=0
    local CHECK=`echo "${RECORD}" | awk -F, '{print NF}'`
    if [ $CHECK -ne 5 ]; then
        log_msg "NOK" "Invalid database entry record! (${RECORD})"
        local FAILURE_COUNT=$((FAILURE_COUNT + 1))
    else
        log_msg "OK" "Record: (${RECORD})"
    fi
    return $FAILURE_COUNT
}

function validate_action_dump_data_set () {
    local FAILURE_COUNT=0
    if [[ "$DUMP" != 'bom-id' ]] \
            && [[ "$DUMP" != 'action' ]] \
            && [[ "$DUMP" != 'project' ]] \
            && [[ "$DUMP" != 'version' ]] \
            && [[ "$DUMP" != 'bom' ]] \
            && [[ "$DUMP" != 'all' ]]; then
        log_msg "NOK" "Invalid dump target! (${DUMP})"
        local FAILURE_COUNT=$((FAILURE_COUNT + 1))
    else
        log_msg "OK" "Dump: (${DUMP})"
    fi
    return $FAILURE_COUNT
}

function validate_action_search_data_set () {
    local FAILURE_COUNT=0
    log_msg "..." "Search: (${SEARCH})"
    case "${SEARCH}" in
        'bom-id')
            if [ -z "${SEARCH_BOM_ID}" ]; then
                log_msg "NOK" "Invalid BOM ID! (${SEARCH_BOM_ID})"
                local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            else
                log_msg "OK" "BOM ID: (${SEARCH_BOM_ID})"
            fi
            ;;
        'action')
            if [ -z "${SEARCH_ACTION}" ]; then
                log_msg "NOK" "Invalid action label! (${SEARCH_ACTION})"
                local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            else
                log_msg "OK" "Action Label: (${SEARCH_ACTION})"
            fi
            ;;
        'project')
            if [ -z "${SEARCH_PROJECT}" ]; then
                log_msg "NOK" "Invalid project name! (${SEARCH_PROJECT})"
                local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            else
                log_msg "OK" "Project: (${SEARCH_PROJECT})"
            fi
            ;;
        'version')
            if [ -z "${SEARCH_VERSION}" ]; then
                log_msg "NOK" "Invalid project version! (${SEARCH_VERSION})"
                local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            else
                log_msg "OK" "Project Version: (${SEARCH_VERSION})"
            fi
            ;;
        *)
            log_msg "NOK" "Invalid search criteria! (${SEARCH})"
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            ;;
    esac
    return $FAILURE_COUNT
}

function validate_data_set () {
    local FAILURE_COUNT=0
    if [ ! -f "${BOM_DB}" ]; then
        log_msg "NOK" "Invalid Bill Of Materials file! (${BOM_DB})"
        local FAILURE_COUNT=$((FAILURE_COUNT + 1))
    fi
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE" &> /dev/null
        if [ $? -ne 0 ]; then
            log_msg "NOK" "Invalid log file! ($LOG_FILE)"
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
        fi
    fi
    log_msg "..." "Action: (${ACTION})"
    case "${ACTION}" in
        'search')
            validate_action_search_data_set
            local FAILURE_COUNT=$((FAILURE_COUNT + $?))
            ;;
        'dump')
            validate_action_dump_data_set
            local FAILURE_COUNT=$((FAILURE_COUNT + $?))
            ;;
        'update')
            validate_action_update_data_set
            local FAILURE_COUNT=$((FAILURE_COUNT + $?))
            ;;
        'delete')
            validate_action_delete_data_set
            local FAILURE_COUNT=$((FAILURE_COUNT + $?))
            ;;
        *)
            log_msg "NOK" "Invalid action! (${ACTION})"
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
    esac
    return $FAILURE_COUNT
}

function validate_dependencies () {
    local FAILURE_COUNT=0
    for pkg in ${DEPENDENCIES[@]}; do
        check_util_installed "$pkg"
        if [ $? -ne 0 ]; then
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            log_msg "NOK" "Dependency not installed! (${pkg})"
            continue
        fi
        log_msg "OK" "Dependency installed! (${pkg})"
    done
    return $FAILURE_COUNT
}

# PROCESSORS

function process_action_dump () {
    case "${DUMP}" in
        'bom-id')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['dump-bom-ids']})"
            echo "${SYSTEM_COMMANDS['dump-bom-ids']}" | bash
            ;;
        'action')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['dump-action-labels']})"
            echo "${SYSTEM_COMMANDS['dump-action-labels']}" | bash
            ;;
        'project')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['dump-project-names']})"
            echo "${SYSTEM_COMMANDS['dump-project-names']}" | bash
            ;;
        'version')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['dump-project-versions']})"
            echo "${SYSTEM_COMMANDS['dump-project-versions']}" | bash
            ;;
        'bom')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['dump-bill-of-materials']})"
            echo "${SYSTEM_COMMANDS['dump-bills-of-materials']}" | bash
            ;;
        'all')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['dump-all']})"
            echo "${SYSTEM_COMMANDS['dump-all']}" | bash
            ;;
        *)
            log_msg "WARNING" "Invalid dump target! (${DUMP})"
            return 1
            ;;
    esac
    return $?
}

function process_action_search () {
    case "${SEARCH}" in
        'bom-id')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['search-bom-id']})"
            echo "${SYSTEM_COMMANDS['search-bom-id']}" | bash
            ;;
        'action')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['search-action-label']})"
            echo "${SYSTEM_COMMANDS['search-action-label']}" | bash
            ;;
        'project')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['search-project-name']})"
            echo "${SYSTEM_COMMANDS['search-project-name']}" | bash
            ;;
        'version')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['search-project-version']})"
            echo "${SYSTEM_COMMANDS['search-project-version']}" | bash
            ;;
        *)
            log_msg "DEBUG" "Invalid search criteria! (${SEARCH})"
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    log_msg "DEBUG" "Exit Code ($EXIT_CODE) "
    return $EXIT_CODE
}

function process_action () {
    case "${ACTION}" in
        'search')
            process_action_search
            ;;
        'dump')
            process_action_dump
            ;;
        'update')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['update-record']})"
            echo "${SYSTEM_COMMANDS['update-record']}" | bash
            ;;
        'delete')
            log_msg "DEBUG" "Executing: (${SYSTEM_COMMANDS['delete-record']})"
            echo "${SYSTEM_COMMANDS['delete-record']}" | bash
            ;;
        *)
            log_msg "WARNING" "Invalid action! (${ACTION})"
            return 1
    esac
    return $?
}

# FORMATTERS

function format_log_message () {
    local LOG_LVL="$1"
    local LOG_MSG="${@:2}"
    echo "[ $LOG_LVL ]: $LOG_MSG"
    return $?
}

# GENERAL

function log_msg () {
    local LOG_LVL="$1"
    local MSG=${@:2}
    if [[ "$SILENT" != 'on' ]]; then
        if [[ "$LOG_LVL" == 'DEBUG' ]] \
            && [[ "$DEBUG" == 'on' ]]; then
            format_log_message "$LOG_LVL" "$MSG"
        elif [[ "$LOG_LVL" != 'DEBUG' ]]; then
            format_log_message "$LOG_LVL" "$MSG"
        fi
    fi
    if [ -f "$LOG_FILE" ]; then
        format_log_message "$LOG_LVL" "$MSG" >> "$LOG_FILE"
    fi
    return 0
}

# DISPLAY

function display_header () {
    if [[ "$SILENT" == 'on' ]]; then
        return 0
    fi
     cat <<EOF

    ___________________________________________________________________________

     *              *            *  F.Statement  *             *             *
    _____________________________________________________v1.0KnowItAll_________
                       Regards, the Alveare Solutions society

EOF
    return $?
}

function display_usage () {
    display_header
    cat <<EOF
    -h   | --help            Display this message.
           --setup           Setup F.Statement project and install dependencies.
                             Super User priviledges required!
           --debug           Display DEBUG level messages on screen.
    -d=* | --bom-db=*        Bill Of Materials database path.
    -l=* | --log-file=*      Log file path.
    -a=* | --action=*        Execution intent, can be (search | dump | update |
                             delete).
    -D=* | --dump=*          Specify the database columns to dump. Valid flags
                             are (bom-id | action | project | version | bom | all).
    -R=* | --bom-record=*    Implies (-a=update). Specify formatted
                             Bill Of Materials entry record.
    -s=* | --search=*        Implies (-a=search). Specify search criteria. Valid
                             flags are (bom-id | action | project | version).
    -I   | --bom-id          Implies (-a=dump). Dump all BOM IDs in database.
    -A   | --bom-action      Implies (-a=dump). Dump all action labels in databse.
    -P   | --bom-project     Implies (-a=dump). Dump all project names in database.
    -V   | --bom-version     Implies (-a=dump). Dump all project versions in database.
    -S   | --silent          Display the minimum amount of information possible.
    -I=* | --bom-id=*        Implies (-a=search -s=bom-id). Display records that
                             match the specified value.
    -A=* | --bom-action=*    Implies (-a=search -s=action). Display records that
                             match the specified value.
    -P=* | --bom-project=*   Implies (-a=search -s=project). Display records that
                             match the specified value.
    -V=* | --bom-version=*   Implies (-a=search -s=version). Display records that
                             match the specified value.

EOF
}

# INIT

function init_fstatement () {
    display_header
    validate_dependencies
    if [ $? -ne 0 ]; then
        log_msg "WARNING" "Not all dependencies satisfied!"\
            "Run $SCRIPT_NAME with super user priviledges and the --setup flag"\
            "to install."
        return 1
    fi
    validate_data_set
    if [ $? -ne 0 ]; then
        log_msg "WARNING" "Invalid data set for specified action!"\
            "Correct input values and re-execute."
        return 2
    fi
    process_action
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        log_msg "NOK" "$SCRIPT_NAME terminated with errors! ($EXIT_CODE)"
    else
        log_msg "OK" "$SCRIPT_NAME terminated successfully!"
    fi
    return $EXIT_CODE
}

# MISCELLANEOUS

if [ ${#@} -eq 0 ]; then
    display_usage
    exit 1
fi

for opt in $@; do
    case "$opt" in
        -h|--help)
            display_usage
            exit 0
            ;;
        --setup)
            if [ $EUID -ne 0 ]; then
                log_msg "WARNING" "$SCRIPT_NAME setup requires super user"\
                    "priviledges! Are you root?"
                exit 1
            fi
            log_msg "INFO" "Installing $SCRIPT_NAME dependencies..."
            log_msg "DEBUG" "Executing (${SYSTEM_COMMANDS['install-dependencies']})"
            echo "${SYSTEM_COMMANDS['install-dependencies']}" | bash
            exit $?
            ;;
        --debug)
            DEBUG='on'
            ;;
        -d=*|--bom-db=*)
            if [ ! -r "${opt#*=}" ]; then
                log_msg "NOK" "$SCRIPT_NAME Bill of Materials database not found!"\
                    "File (${opt#*=}) is not readable."
                continue
            fi
            BOM_DB="${opt#*=}"
            ;;
        -l=*|--log-file=*)
            if [ ! -f "${opt#*=}" ]; then
                touch "${opt#*=}" &> /dev/null
                if [ $? -ne 0 ]; then
                    log_msg "NOK" "Could not create $SCRIPT_NAME log file! (${opt#*=})"
                    continue
                fi
            fi
            LOG_FILE="${opt#*=}"
            ;;
        -a=*|--action=*)
            if [[ "${opt#*=}" != "search" ]] \
                    && [[ "${opt#*=}" != "dump" ]] \
                    && [[ "${opt#*=}" != "update" ]] \
                    && [[ "${opt#*=}" != "delete" ]]; then
                log_msg "NOK" "Invalid $SCRIPT_NAME action! (${opt#*=})"
                continue
            fi
            ACTION="${opt#*=}"
            ;;
        -D=*|--dump=*)
            if [[ "${opt#*=}" != "bom-id" ]] \
                    && [[ "${opt#*=}" != "action" ]] \
                    && [[ "${opt#*=}" != "project" ]] \
                    && [[ "${opt#*=}" != "version" ]] \
                    && [[ "${opt#*=}" != "bom" ]] \
                    && [[ "${opt#*=}" != "all" ]]; then
                log_msg "NOK" "Invalid $SCRIPT_NAME dump target! (${opt#*=})"
                continue
            fi
            DUMP="${opt#*=}"
            ;;
        -R=*|--bom-record=*)
            VALIDATE_RECORD=`echo "${opt#*=}" | awk -F, '{print NF}'`
            if [ $VALIDATE_RECORD -ne 5 ]; then
                log_msg "NOK" "Invalid $SCRIPT_NAME BOM record format! (${opt#*=})"
                continue
            fi
            RECORD="${opt#*=}"
            ;;
        -S|--silent)
            SILENT='on'
            ;;
        -s=*|--search=*)
            if [[ "${opt#*=}" != "bom-id" ]] \
                    && [[ "${opt#*=}" != "action" ]] \
                    && [[ "${opt#*=}" != "project" ]] \
                    && [[ "${opt#*=}" != "version" ]]; then
                log_msg "NOK" "Invalid $SCRIPT_NAME search criteria! (${opt#*=})"
                continue
            fi
            SEARCH="${opt#*=}"
            ;;
        -I|--bom-id|-I=*|--bom-id=*)
            if [[ "$ACTION" == 'dump' ]]; then
                DUMP='bom-id'
                continue
            fi
            SEARCH_BOM_ID="${opt#*=}"
            ;;
        -A|--bom-action|-A=*|--bom-action=*)
            if [[ "$ACTION" == 'dump' ]]; then
                DUMP='action'
                continue
            fi
            SEARCH_ACTION="${opt#*=}"
            ;;
        -P|--bom-project|-P=*|--bom-project=*)
            if [[ "$ACTION" == 'dump' ]]; then
                DUMP='project'
                continue
            fi
            SEARCH_PROJECT="${opt#*=}"
            ;;
        -V|--bom-version|-V=*|--bom-version=*)
            if [[ "$ACTION" == 'dump' ]]; then
                DUMP='version'
                continue
            fi
            SEARCH_VERSION="${opt#*=}"
            ;;
    esac
done

SYSTEM_COMMANDS=(
['search-bom-id']="awk -F, -v bom_id=\"${SEARCH_BOM_ID}\" '\$1 !~ \"#\" && \$1 !~ \"^$\" && \$1 ~ bom_id {print \$0}' '${BOM_DB}'"
['search-action-label']="awk -F, -v action_label=\"${SEARCH_ACTION}\" '\$1 !~ \"#\" && \$1 !~ \"^$\" && \$2 ~ action_label {print \$0}' '${BOM_DB}'"
['search-project-name']="awk -F, -v project_name=\"${SEARCH_PROJECT}\" '\$1 !~ \"#\" && \$1 !~ \"^$\" && \$3 ~ project_name {print \$0}' ${BOM_DB}"
['search-project-version']="awk -F, -v project_version=\"${SEARCH_VERSION}\" '\$1 !~ \"#\" && \$1 !~ \"^$\" && \$4 ~ project_version {print \$0}' ${BOM_DB}"
['dump-bom-ids']="awk -F, '\$1 !~ \"#\" && \$1 !~ \"^$\" {print \$1}' ${BOM_DB}"
['dump-action-labels']="awk -F, '\$1 !~ \"#\" && \$1 !~ \"^$\" {print \$2}' ${BOM_DB}"
['dump-project-names']="awk -F, '\$1 !~ \"#\" && \$1 !~ \"^$\" {print \$3}' ${BOM_DB}"
['dump-project-versions']="awk -F, '\$1 !~ \"#\" && \$1 !~ \"^$\" {print \$4}' ${BOM_DB}"
['dump-bills-of-materials']="awk -F, '\$1 !~ \"#\" && \$1 !~ \"^$\" {print \$5}' ${BOM_DB}"
['dump-all']="awk -F, '\$1 !~ \"#\" && \$1 !~ \"^$\" {print \$0}' ${BOM_DB}"
['update-record']="echo \"${RECORD}\" >> ${BOM_DB} 2> /dev/null"
['delete-record']="sed -i '/${SEARCH_BOM_ID},*/d' ${BOM_DB} &> /dev/null"
)

init_fstatement
exit $?

# CODE DUMP

