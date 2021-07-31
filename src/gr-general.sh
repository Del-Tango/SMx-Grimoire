#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# GENERAL

function shorten_file_path () {
    local FILE_PATH="$1"
    DIR_PATH=`dirname $FILE_PATH 2> /dev/null`
    DIR_NAME=`basename $DIR_PATH 2> /dev/null`
    FL_NAME=`basename $FILE_PATH 2> /dev/null`
    local FL_SHORT="${DIR_NAME}/${FL_NAME}"
    echo "$FL_SHORT"
    return $?
}

