#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# COLD BANNER

TMP_FILE="/tmp/od-hb-${RANDOM}.tmp"
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

function display_phantom_commander () {
    cat<<EOF
${RED}
_____________________________________________________________________________
|| ______                     ______ |=| ______                     ______ ||
|| |       .;dkOKKd,               | |=| |                               | ||
|| |     .;kXXNNNNN0,              | |=| |    (O.C.C.U.L.T) Knowledge    | ||
|| |     :kKXNNNNNNXd              | |=| |               -               | ||
||      .xXXNNNNNX0KX;               |=|      Tradecraft  &  Machines      ||
||       :dOk;:;'   .k               |=|      |                     |      ||
||          ..    . .O .             |=|      |                     |      ||
||          ,O..  .lNN:              |=|      |                     |      ||
||          'NKX0OXNWNl'             |=|      |                     |      ||
||     o0X. .NKKXNWNK:c              |=|      |                     |      ||
||      c.   lcdXXNK;.               |=|      |                     |      ||
||            dNNNKk,.               |=|      |   Born to be ROOT,  |      ||
||          'cOxd:cl,                |=|      |    Not to reboot.   |      ||
||           .,;':kol                |=|      |                     |      ||
||           ;xk0XXo                 |=|      |                     |      ||
||           ckkxx: ..               |=|      |                     |      ||
||            .'l:.oN.               |=|      |                     |      ||
||       dol:;:lx0WW0                |=|      |                     |      ||
|| |     xNNK'kWWWWN,              | |=| |    |                     |    | ||
|| |     ;NO   xWWNx               | |=| |    Lone Star Electromancer    | ||
|| |_____'X     NWd0.         _____| |=| |_____      SMx093pk01     _____| ||
||___________________________________|=|___________________________________||
||                                   |=|                                   ||
||      * SMx093pk01 Grimoire *      |=|   Machinist Monastery 31/07/2021  ||
||___________________________________|=|___________________________________||${RESET}

EOF
}

function display_cold_banner () {
    clear; display_phantom_commander
    rm $TMP_FILE &> /dev/null
    return 0
}

display_cold_banner
