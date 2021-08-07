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
|| |     .;kXXNNNNN0,              | |=| |        G R I M O I R E        | ||
|| |     :kKXNNNNNNXd              | |=| |    Lone Star Electromancer    | ||
||      .xXXNNNNNX0KX;               |=|      |                     |      ||
||       :dOk;:;'   .k               |=|      |                     |      ||
||          ..    . .O .             |=|      |      I am the       |      ||
||          ,O..  .lNN:              |=|      |     voice in the    |      ||
||          'NKX0OXNWNl'             |=|      |       machine       |      ||
||     o0X. .NKKXNWNK:c              |=|      |                     |      ||
||      c.   lcdXXNK;.               |=|      |          x          |      ||
||            dNNNKk,.               |=|      |        x            |      ||
||          'cOxd:cl,                |=|      |        x x x        |      ||
||           .,;':kol                |=|      |                     |      ||
||           ;xk0XXo                 |=|      |      All  good      |      ||
||           ckkxx: ..               |=|      |    men I met are    |      ||
||            .'l:.oN.               |=|      |      Dangerous      |      ||
||       dol:;:lx0WW0                |=|      |                     |      ||
|| |     xNNK'kWWWWN,              | |=| |    |                     |    | ||
|| |     ;NO   xWWNx               | |=| |    Tradecraft (&) Machines    | ||
|| |_____'X     NWd0.         _____| |=| |_____                     _____| ||
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
