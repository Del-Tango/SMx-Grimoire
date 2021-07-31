#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FETCHERS

function fetch_action_count () {
    local ACTION_COUNT=`cat ${MD_DEFAULT['bom-db']} | \
        egrep -v "^#" | egrep -v "^$" | wc -l`
    echo $ACTION_COUNT
    return $?
}
function fetch_project_count () {
    local PROJECT_COUNT=`awk -F, '{print $3}' ${MD_DEFAULT['bom-db']} | \
        egrep -v "^#" | egrep -v "^$" | sort -u | wc -l`
    echo $PROJECT_COUNT
    return $?
}
function fetch_version_count () {
    local VERSION_COUNT=`awk -F, '{print $4}' ${MD_DEFAULT['bom-db']} | \
        egrep -v "^#" | egrep -v "^$" | sort -u | wc -l`
    echo $VERSION_COUNT
    return $?
}
