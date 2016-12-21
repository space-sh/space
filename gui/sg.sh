#!/usr/bin/env bash
#
# Copyright 2016 Blockie AB
#
# This file is part of Space.
#
# Space is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 3 of the License.
#
# Space is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Space.  If not, see <http://www.gnu.org/licenses/>.
#

#
# Space GUI
#

# ===============================================
# Configuration

# Exit when trying to access undeclared variables.
set -o nounset

# ===============================================
# Constants

#
# ANSI color table (ECMA-48 / ISO 6429)
# Attributes
COLOR_DEFAULT="\033[0m"
COLOR_ATTRIB_OFF="\033[20m"
COLOR_ATTRIB_BOLD="\033[1m"
COLOR_ATTRIB_DIM="\033[2m"
COLOR_ATTRIB_UNDERSCORE="\033[4m"
COLOR_ATTRIB_BLINK="\033[5m"
COLOR_ATTRIB_REVERSE="\033[7m"
COLOR_ATTRIB_CONCEALED="\033[8m"

# Text color
COLOR_FG_DEFAULT="\033[39m"
COLOR_FG_BLACK="\033[30m"
COLOR_FG_RED="\033[31m"
COLOR_FG_GREEN="\033[32m"
COLOR_FG_YELLOW="\033[33m"
COLOR_FG_BLUE="\033[34m"
COLOR_FG_MAGENTA="\033[35m"
COLOR_FG_CYAN="\033[36m"
COLOR_FG_WHITE="\033[37m"
COLOR_FG_GRAY="\033[90m"
COLOR_FG_LIGHT_RED="\033[91m"
COLOR_FG_LIGHT_GREEN="\033[92m"
COLOR_FG_LIGHT_YELLOW="\033[93m"
COLOR_FG_LIGHT_BLUE="\033[94m"
COLOR_FG_LIGHT_MAGENTA="\033[95m"
COLOR_FG_LIGHT_CYAN="\033[96m"
COLOR_FG_LIGHT_GRAY="\033[97m"

# Background color
COLOR_BG_DEFAULT="\033[49m"
COLOR_BG_BLACK="\033[40m"
COLOR_BG_RED="\033[41m"
COLOR_BG_GREEN="\033[42m"
COLOR_BG_YELLOW="\033[43m"
COLOR_BG_BLUE="\033[44m"
COLOR_BG_MAGENTA="\033[45m"
COLOR_BG_CYAN="\033[46m"
COLOR_BG_WHITE="\033[47m"
COLOR_BG_GRAY="\033[100m"
COLOR_BG_LIGHT_RED="\033[101m"
COLOR_BG_LIGHT_GREEN="\033[102m"
COLOR_BG_LIGHT_YELLOW="\033[103m"
COLOR_BG_LIGHT_BLUE="\033[104m"
COLOR_BG_LIGHT_MAGENTA="\033[105m"
COLOR_BG_LIGHT_CYAN="\033[106m"
COLOR_BG_LIGHT_GRAY="\033[107m"

# Special graphics characters for Draw Mode (ANSI/vt100)
# Octal code                # US set equivalent
DRAW_BLANK="\137"           # "_"
DRAW_DIAMOND="\140"         # "`"
DRAW_CHECKERBOARD="\141"    # "a"
DRAW_HT="\142"              # "b" (horizontal tab symbol)
DRAW_FF="\143"              # "c" (form feed symbol)
DRAW_CR="\144"              # "d" (carriage return symbol)
DRAW_LF="\145"              # "e" (line feed symbol)
DRAW_DEGREE="\146"          # "f" (degree symbol)
DRAW_PLUS_MINUS="\147"      # "g" (plus/minus symbol)
DRAW_NL="\150"              # "h" (new line symbol)
DRAW_VT="\151"              # "i" (vertical tab symbol)
DRAW_LOWER_RIGHT="\152"     # "j"
DRAW_UPPER_RIGHT="\153"     # "k"
DRAW_UPPER_LEFT="\154"      # "l"
DRAW_LOWER_LEFT="\155"      # "m"
DRAW_CROSS="\156"           # "n"
DRAW_HLINE_1="\157"         # "o"
DRAW_HLINE_3="\160"         # "p"
DRAW_HLINE_5="\161"         # "q"
DRAW_HLINE_7="\162"         # "r"
DRAW_HLINE_9="\163"         # "s"
DRAW_LEFT_T="\164"          # "t"
DRAW_RIGHT_T="\165"         # "u"
DRAW_BOTTOM_T="\166"        # "v"
DRAW_TOP_T="\167"           # "w"
DRAW_VLINE="\170"           # "x"
DRAW_LESS_THAN="\171"       # "y" (less than or equal to symbol)
DRAW_GREATER_THAN="\172"    # "z" (greater than or equal to symbol)
DRAW_PI="\173"              # "{"
DRAW_NOT_EQUAL="\174"       # "|"
DRAW_POUND="\175"           # "}"
DRAW_DOT="\176"             # "~"

#
# Characters (ANSI X3.4-1977)
CHAR_BELL="\007"
CHAR_TAB=$'\x09'
CHAR_LF="\012"           # line feed
CHAR_CR="\015"           # carriage return
CHAR_ESC="\033"          #
CHAR_SPACE="\040"        #
CHAR_DEL=$'\x7f'
CHAR_ESC=$'\x1b'
CHAR_ENTER=$'\x0a'

#
# Cursor style
CURSOR_BLINKING_1=0
CURSOR_BLINKING_2=1
CURSOR_STEADY=2
CURSOR_BLINKING_UNDERLINE=3
CURSOR_STEADY_UNDERLINE=4
CURSOR_BLINKING_BAR=5
CURSOR_STEADY_BAR=6

# Keycodes
KEY_ARROW_UP="^[[A"
KEY_ARROW_DOWN="^[[B"
KEY_ARROW_LEFT="^[[D"
KEY_ARROW_RIGHT="^[[C"
KEY_ENTER="^M"
KEY_ESC="^["
KEY_BACKSPACE="^?"

#
# Log
LOG_FILE_NAME="run-$(date +%y%m%d).log"
LOG_ENABLED=true

#
# System definitions
SCREEN_WIDTH=${COLUMNS:-$(tput cols)}
SCREEN_HEIGHT=${LINES:-$(tput lines)}


# ===============================================
# Globals

_EXIT=0

# Menu
readonly _MENU_ENTRY_POS_X_START=6
_MENU_ENTRY_COUNT=0
_MENU_ENTRY_ARRAY=()
_MENU_ENTRY_PATH="/"
_MENU_ENTRY_HAS_PARENT=0
_MENU_PARENT_NODE_SYMBOL="."

# Marker
_MARKER_SYMBOL=">"
_MARKER_POS_X=6

# Panel layout
# size with border
readonly _PANEL_LEFT_WIDTH=25
readonly _PANEL_RIGHT_WIDTH=58
_PANEL_RIGHT_WIDTH_EXTENDED=0
_PANEL_LAYOUT_WIDTH=0
_PANEL_LAYOUT_HEIGHT=0

# Color scheme
_COLOR_SCHEME_TEXT_BASE=$COLOR_FG_YELLOW$COLOR_BG_GRAY
_COLOR_SCHEME_TEXT=$COLOR_DEFAULT$_COLOR_SCHEME_TEXT_BASE
_COLOR_SCHEME_TEXT_BOLD=$COLOR_ATTRIB_BOLD$COLOR_ATTRIB_UNDERSCORE$_COLOR_SCHEME_TEXT_BASE
_COLOR_SCHEME_TEXT_BLINK=$COLOR_ATTRIB_BLINK$_COLOR_SCHEME_TEXT_BASE
_COLOR_SCHEME_TEXT_HIGHLIGHT=$COLOR_ATTRIB_OFF$COLOR_FG_GREEN$COLOR_BG_GRAY

# Screen
_SCREEN_WIDTH=0
_SCREEN_HEIGHT=0

# Data
_DATA_FILE="./.sg_shared"

# Latency fork
_LATENCY_FORK_PID=-1

# TODO: FIXME: Deprecated
_GIT_HOST="gitlab.com"
_GIT_USER="git"
_GIT_PROTOCOL="https"

# ===============================================
# Traps
#
# Rewrite relevant traps
#

_sg_trap_myresize()
{
    _sg_render
}
trap _sg_trap_myresize SIGWINCH

_sg_trap_exit()
{
    # Reset keyboard hook and cursor
    if [ -t 0 ]; then stty sane; fi # TODO: consider restoring STTY variable instead?
    _cursor_show

    # EXTERNAL: kill
    trap - SIGTERM
    if [ "$_LATENCY_FORK_PID" -ne "-1" ]; then
        { kill $_LATENCY_FORK_PID && wait $_LATENCY_FORK_PID; } 2> /dev/null
    fi

    _log_info "end: Bye bye bird!"
    exit 0
}
trap _sg_trap_exit SIGINT SIGTERM EXIT ERR


# ===============================================
# Functions
#


#===============================================================
# Cursor
# ------
#
# [Functions]
# * cursor_back_tab
# * cursor_backward
# * cursor_hide
# * cursor_show
# * cursor_set_style
# * cursor_set_pos
# * cursor_save
# * cursor_restore
# * cursor_up
# * cursor_down
# * cursor_left
# * cursor_right
# *_cursor_next_line
# *_cursor_prev_line
# *_cursor_set_column
#
#===============================================================

# $1: Steps to move back
_cursor_back_tab()
{
    num=${1:-1}
    printf "\033[${num}Z";
}

# $1: Steps to move back
_cursor_backward()
{
    num=${1:-1}
    printf "\033[${num}D";
}

_cursor_hide()
{
    printf "\033[?25l";
}

_cursor_show()
{
    printf "\033[?12l\033[?25h";
}

_cursor_set_style()
{
    local style=${1}
    printf "\033[$style q"
}

# Cursor position to X=COLUMN=$1 and Y=COLUMN=$2
_cursor_set_pos()
{
    pos_x=${1}
    shift
    pos_y=${1}
    printf "\033[${pos_x};${pos_y}H";
}

_cursor_save()
{
    printf "\033\067";
}

_cursor_restore()
{
    printf "\033\070";
}

_cursor_up()
{
    printf "\033[A";
}

_cursor_down()
{
    printf "\033[B";
}

_cursor_left()
{
    printf "\033[D";
}

_cursor_right()
{
    printf "\033[C";
}

# $1: Steps to move
_cursor_next_line()
{
    num=${1:-1}
    printf "\033[${num}E";
}

# $1: Steps to move
_cursor_prev_line()
{
    num=${1:-1}
    printf "\033[${num}F";
}

# $1: Steps to move
_cursor_set_column()
{
    num=${1:-1}
    printf "\033[${num}G";
}


#===============================================================
# Screen
# ------
#
# [Functions]
# * screen_clear
# * screen_clear_from_cursor
# * screen_clear_until_cursor
# * screen_clear_line
# * screen_clear_line_from_cursor
# * screen_clear_line_until_cursor
# * screen_save
# * screen_restore
# * screen_set_draw_mode
# * screen_set_write_mode
# * screen_set_write_color
# * screen_set_write_256color
# * screen_set_write_bg_256color
# * screen_set_write_truecolor
# * screen_set_write_bg_truecolor
#
# Note: Special draw mode according to ANSI X3.41-1974
#===============================================================

_screen_clear()
{
    printf "\033c";
}

_screen_clear_from_cursor()
{
    printf "\033[0J";
}

_screen_clear_until_cursor()
{
    printf "\033[1J";
}

_screen_clear_line()
{
    printf "\033[2K";
}

_screen_clear_line_from_cursor()
{
    printf "\033[0K";
}

_screen_clear_line_until_cursor()
{
    printf "\033[1K";
}

_screen_save()
{
    printf "\033[?1049h";
}

_screen_restore()
{
    printf "\033[?1049l"
}

# Set special characters and line set
_screen_set_draw_mode()
{
    printf "\033%%\033(0";
}

# Set regular american character set
_screen_set_write_mode()
{
    printf "\033(B";
}

_screen_set_write_color()
{
    local color="${1}"
    printf "${color}"
}

_screen_set_write_256color()
{
    local color="${1}"
    shift
    printf "\033[38;5;${color}m"
}

_screen_set_write_bg_256color()
{
    local color="${1}"
    shift
    printf "\033[48;5;${color}m"
}

_screen_set_write_truecolor()
{
    local red="${1}"
    shift
    local green="${1}"
    shift
    local blue="${1}"
    shift
    printf "\033[38;2;${red};${green};${blue}m"
}

_screen_set_write_bg_truecolor()
{
    local red="${1}"
    shift
    local green="${1}"
    shift
    local blue="${1}"
    shift
    printf "\033[48;2;${red};${green};${blue}m"
}


#===============================================================
# Logging
# -------
#
# [Functions]
# * log_init
# * log
# * log_info
# * log_warning
# * log_error
#
# [Configurations]
# * LOG_ENABLED
# * LOG_FILE_NAME
#
# [Notes]
# All functions except init take the log message as 
# the first parameter ($1)
#
#===============================================================

_log_init()
{
    _log_info "start:"
    _log_info "  terminal -> \"${TERM:-unknown}\""
    _log_info "  bash     -> \"${BASH:-unknown}\""
    _log_info "  version  -> \"${BASH_VERSION:-unknown}\""
    _log_info "  locale   -> \"${LC_CTYPE:-unknown}\""

    if ! command -v "infocmp" >/dev/null 2>&1; then
        _log_warning "infocmp is not present. Skipping..." >& 2
    else
        _log_info "  capabilities   -> "
        infocmp screen >> ${LOG_FILE_NAME}
    fi
}

_log()
{
    if [[ "${LOG_ENABLED}" == true ]]; then
        timestamp="$(date +%H:%M:%S)"
        printf "[${timestamp}] log: ${1}\n" >> ${LOG_FILE_NAME}
    fi
}

_log_info()
{
    if [[ "${LOG_ENABLED}" == true ]]; then
        timestamp="$(date +%H:%M:%S)"
        printf "[${timestamp}] ${1}\n" >> ${LOG_FILE_NAME}
    fi
}

_log_warning()
{
    if [[ "${LOG_ENABLED}" == true ]]; then
        timestamp="$(date +%H:%M:%S)"
        printf "[${timestamp}] warning: ${1}\n" >> ${LOG_FILE_NAME}
    fi
}

_log_error()
{
    timestamp="$(date +%H:%M:%S)"
    printf "[${timestamp}] error: ${1}\n" >> ${LOG_FILE_NAME}
}


#===============================================================
# Misc
# ----
#
# [Functions]
# * check_dependency_installed
# * keyboard_init
#

_check_dependency_installed()
{
    program_name="${1}"
    if ! command -v "${program_name}" >/dev/null 2>&1; then
        _log_error "${program_name} not installed" >& 2
        exit 1
    fi
}

_keyboard_init()
{
    # Enable key capture
    if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi
}


#==========
# _sg_update_viewport
#
# Update screen dimensions and propagate changes
#
#==========
_sg_update_viewport()
{
    _SCREEN_WIDTH=$(tput cols)
    _SCREEN_HEIGHT=$(tput lines)

    # size with border
    _PANEL_RIGHT_WIDTH_EXTENDED=$(( _SCREEN_WIDTH - _PANEL_LEFT_WIDTH ))
    _PANEL_LAYOUT_WIDTH=$(( _SCREEN_WIDTH - 2 ))
    _PANEL_LAYOUT_HEIGHT=$(( _SCREEN_HEIGHT - 3 ))
}

#==========
# _sg_clear_subpanel
#
# Clear description subpanel
#
#==========
_sg_clear_subpanel()
{
    local _subpanel_width=$(( _PANEL_RIGHT_WIDTH_EXTENDED - 1))
    local _counter=2
    while [ $(( _counter < 20 )) -ne 0 ]; do
        _cursor_set_pos $_counter 26
        printf "%-${_subpanel_width}s" " "
        _counter=$(( _counter + 1 ))
    done
}

#==========
# _sg_draw_bottom_border
#
# Render bottom horizontal line
#
#==========
_sg_draw_bottom_border()
{
    # Switch to DRAW mode
    _screen_set_draw_mode

    local _counter=0
    local _frame="$DRAW_LOWER_LEFT"
    while [ $(( _counter < _SCREEN_WIDTH-2 )) -ne 0 ]; do
        _frame=$_frame"$DRAW_HLINE_5"
        _counter=$(( _counter + 1 ))
    done
    _frame=$_frame"$DRAW_LOWER_RIGHT"
    printf "$_frame"
    _frame=""

    # Switch to TEXT mode
    _screen_set_write_mode
}

#==========
# _sg_draw_panel_info
#
# Draw information panel (right side)
#
#==========
_sg_draw_panel_info()
{
    local _info_title=''
    local _info_desc=''
    local _info_desc_x=3
    local _curr_node_index=$(( _MARKER_POS_X - _MENU_ENTRY_POS_X_START ))
    local _curr_node="${_MENU_ENTRY_ARRAY[$_curr_node_index]}"
    local _node_path="$_MENU_ENTRY_PATH$_curr_node/"

    _sg_clear_subpanel

    # Handle node_path in case this is a parent node
    if [ "$_curr_node" = "/" ]; then
        _node_path="$_MENU_ENTRY_PATH"
    fi

    # Special case for parent root
    if [ "$_curr_node" = ".." ]; then
        local _parent_node_path=''

        # Extract upper level
        _parent_node_path="$(dirname "$_node_path")/"
        _parent_node_path="$(dirname "$_parent_node_path")"
        local _tmp_info_title=''
        _copy "_tmp_info_title" "${_parent_node_path}_info/title"
        _info_title="(Go back to: $_tmp_info_title)"
        _copy "_info_desc" "${_parent_node_path}_info/desc"

    else
        # Load node information
        _copy "_info_title" "${_node_path}_info/title"
        _copy "_info_desc" "${_node_path}_info/desc"
    fi
    # Render title
    _cursor_set_pos $_info_desc_x 26
    printf "%s" "$_info_title"
    _cursor_set_pos $((_info_desc_x+1)) 26
    printf "%.${#_info_title}s" "-------------------------------------------------------"

    # Render description
    # EXTERNAL: either here-strings or grep
    # EXTERNAL: fold
    _info_desc_x=$((_info_desc_x+3))
    _info_desc=$(printf "%s" "$_info_desc" | fold -sw $((_PANEL_RIGHT_WIDTH_EXTENDED-1)))
    while read -r line; do
        _cursor_set_pos "$_info_desc_x" 26
        _info_desc_x=$((_info_desc_x+1))
        printf "%s" "$line"
    done <<< "${_info_desc}"
}

#==========
# _sg_draw_bottom_hints
#
# Draw border hints at the bottom of the screen
#
#==========
_sg_draw_bottom_hints()
{
    local _width=${1}
    shift
    local _height=${1}
    shift

    # Write border hints
    local _bottom_info="up/down: menu navigation | enter: selection"
    local _bottom_info_len=${#_bottom_info}
    _cursor_set_pos "$_height" $(((_width/2) - (_bottom_info_len/2) ))
    printf "%s" "${_bottom_info}"
}

#==========
# _sg_draw_top_bar
#
# Draws information bar at the top of the screen
#
#==========
_sg_draw_top_bar()
{
    # Note: this is a parallel job which updates the latency statistics
    # EXTERNAL: ping
    while true; do
        local _latency=0
        [[ $(ping -q -c3 ${_GIT_HOST%%:*}) =~ \ =\ [^/]*/([0-9]+\.[0-9]+).*ms ]] && _latency="${BASH_REMATCH[1]%%.*}"
        printf "%d" "$_latency" > "$_DATA_FILE"
    done &
    _LATENCY_FORK_PID="$!"

    # Draw top information bar
    _cursor_set_pos 0 4;
    printf "$COLOR_FG_GREEN[HOME]$COLOR_FG_LIGHT_GREEN $_MODULES_SHARED $COLOR_FG_GREEN| [REMOTE] $COLOR_FG_LIGHT_GREEN$_GIT_USER@$_GIT_HOST via $_GIT_PROTOCOL"
}

#==========
# _sg_update_top_bar
#
# Update information text at the top of the screen
#
#==========
_sg_update_top_bar()
{
    if [ -f "$_DATA_FILE" ]; then
        local _latency_value=''
        _latency_value=$(cat "$_DATA_FILE")
        local _latency_color=''
        if [ "$_latency_value" -gt 400 ]; then
            _latency_color=$COLOR_FG_BLACK$COLOR_BG_RED
        elif [ "$_latency_value" -gt 200 ]; then
            _latency_color=$COLOR_FG_BLACK$COLOR_BG_YELLOW
        else
            _latency_color=$COLOR_FG_BLACK$COLOR_BG_GREEN
        fi

        _screen_set_write_mode
        _cursor_set_pos 0 4;
        printf "$COLOR_FG_GREEN[HOME]$COLOR_FG_LIGHT_GREEN $_MODULES_SHARED $COLOR_FG_GREEN| [REMOTE] $COLOR_FG_LIGHT_GREEN$_GIT_USER@$_GIT_HOST via $_GIT_PROTOCOL $_latency_color(${_latency_value} ms)";
    fi
}


#==========
# _sg_draw_layout
#
# Draw main panel layout
#
#==========
_sg_draw_layout()
{
    local _width=${1}
    shift
    local _height=${1}
    shift

    local _frame=""

    # Enter DRAW mode
    _screen_set_draw_mode

    local _color=$_COLOR_SCHEME_TEXT
    _screen_set_write_color "${_color}"

    # Render top horizontal line
    _frame="$DRAW_UPPER_LEFT"
    local _counter=0
    while [ $(( _counter < _PANEL_LAYOUT_WIDTH )) -ne 0 ]; do
        _frame=$_frame"$DRAW_HLINE_5"
        _counter=$(( _counter + 1 ))
    done
    _frame=$_frame"$DRAW_UPPER_RIGHT"
    printf "$_frame"
    _frame=""

    # Render frame border
    _counter=0
    while [ $(( _counter <= _PANEL_LAYOUT_HEIGHT )) -ne 0 ]; do
        # Render vertical line on far left
        _frame=$_frame"\n$DRAW_VLINE"
        printf "$_frame"
        _frame=""

        # Render empty space inside the left panel
        local _inner_counter=0
        while [ $(( _inner_counter <= _PANEL_LEFT_WIDTH-5 )) -ne 0 ]; do
            _frame=$_frame" "
            _inner_counter=$(( _inner_counter + 1 ))
        done
        printf "$_frame"
        _frame=""

        # Render vertical line dividing left and right panels
        _frame=$_frame"$DRAW_VLINE"
        printf "$_frame"
        _frame=""

        # Render vertical line on the far right
        _inner_counter=0
        while [ $(( _inner_counter <= _PANEL_RIGHT_WIDTH_EXTENDED )) -ne 0 ]; do
            _frame=$_frame" "
            _inner_counter=$(( _inner_counter + 1 ))
        done
        _frame=$_frame"$DRAW_VLINE"
        printf "$_frame"
        _frame=""
        _counter=$(( _counter + 1 ))
    done

    _sg_draw_bottom_border

    # Switch to TEXT mode
    _screen_set_write_mode
}

#==========
# _sg_draw_animated_split
#
# Draw animated horizontal line
#
#==========
_sg_draw_animated_split()
{
    local _diamond_pos=${1}
    local _diamond_split=''
    local _color=$_COLOR_SCHEME_TEXT

    # Enter DRAW mode
    _screen_set_draw_mode
    _screen_set_write_color "${_color}"
    _cursor_set_pos 4 0;

    # Render far left side of the split
    _diamond_split="$DRAW_LEFT_T"
    printf "$_diamond_split"
    _diamond_split=""

    # Render main split
    local _ii=0
    for _ii in $(seq 0 9); do
        if [ "$_ii" -eq "${_diamond_pos}" ]; then
            _diamond_split=$_diamond_split" $DRAW_DIAMOND" 
        else
            _diamond_split=$_diamond_split" $DRAW_HLINE_5" 
        fi
    done
    printf "$_diamond_split "
    _diamond_split=""

    # Render far right side of the split
    _diamond_split="$DRAW_RIGHT_T"
    printf "$_diamond_split"
    _diamond_split=""

    # Reset state back to TEXT mode
    _screen_set_write_mode
}

#==========
# _sg_update_animated_split
#
# Update animation routine
#
#==========
_sg_update_animated_split()
{
    _sg_draw_animated_split "$diamond_pos"
    diamond_pos=$((diamond_pos+1))
    if [ "$diamond_pos" -gt 9 ]; then diamond_pos=0; fi;
}

#==========
# _sg_load_menu
#
# Load menu entries from a given node path
#
#==========
_sg_load_menu()
{
    # Clear entries
    _MENU_ENTRY_COUNT=0
    _MENU_ENTRY_ARRAY=()

    # Load nodes
    local _listItems=()
    _list "_listItems" "${_MENU_ENTRY_PATH}"


    # Add parent if available
    if [ "$_MENU_ENTRY_HAS_PARENT" -eq 1 ]; then
        _MENU_ENTRY_ARRAY+=("..")
        _MENU_ENTRY_COUNT=$(( _MENU_ENTRY_COUNT + 1 ))
    fi

    # Add root node
    _MENU_ENTRY_ARRAY+=("/")
    _MENU_ENTRY_COUNT=$(( _MENU_ENTRY_COUNT + 1 ))

    local _item=
    if [ "${#_listItems[@]}" -gt 0 ]; then
        for _item in "${_listItems[@]}"; do
            _MENU_ENTRY_ARRAY+=("$_item")
            _MENU_ENTRY_COUNT=$(( _MENU_ENTRY_COUNT + 1 ))
        done
    fi
}

#==========
# _sg_clear_menu
#
#
#=========
_sg_clear_menu()
{
    # Clear items including the marker
    local _subpanel_width=$(( _PANEL_LEFT_WIDTH - 6))
    local _counter=$_MENU_ENTRY_POS_X_START
    while [ $(( _counter <= (_MENU_ENTRY_POS_X_START+_MENU_ENTRY_COUNT) )) -ne 0 ]; do
        _cursor_set_pos $_counter 3
        printf "%-${_subpanel_width}s" " "
        _counter=$(( _counter + 1 ))
    done

    # Clear node path
    _cursor_set_pos 3 4
    printf "%-${_subpanel_width}s" " "

    # Reset marker position to first position
    _MARKER_POS_X=6
}

#==========
# _sg_draw_menu
#
# Render complete menu with all entries
#
#==========
_sg_draw_menu()
{
    local _menu_entry_height=$_MENU_ENTRY_POS_X_START

    # Draw node path
    local _color=$_COLOR_SCHEME_TEXT_BOLD
    _screen_set_write_color "${_color}"
    _cursor_set_pos 3 4
    printf "%s" "$_MENU_ENTRY_PATH"

    # Draw marker
    _color=$_COLOR_SCHEME_TEXT_BLINK
    _screen_set_write_color "${_color}"
    _cursor_set_pos $_MARKER_POS_X 3
    printf "%s" ${_MARKER_SYMBOL}

    # Draw items
    if [ "${_MENU_ENTRY_COUNT}" -gt 0 ]; then
        for _item in "${_MENU_ENTRY_ARRAY[@]}"; do

            # Transform root node to SYMBOL just for rendering
            if [ "$_item" = "/" ]; then
                _item="$_MENU_PARENT_NODE_SYMBOL"
            fi

            if [ "$_menu_entry_height" -eq "$_MARKER_POS_X" ]; then
                _color=$COLOR_ATTRIB_REVERSE
            else
                _color=$_COLOR_SCHEME_TEXT
            fi
            _screen_set_write_color "${_color}"

            _cursor_set_pos "$_menu_entry_height" 4
            _menu_entry_height=$(( _menu_entry_height + 1 ))
            printf "%s" "$_item"
        done
    fi

    _color=$_COLOR_SCHEME_TEXT
    _screen_set_write_color "${_color}"
}

#==========
# _sg_render
#
# Main render function
#
#==========
_sg_render()
{
    _screen_clear
    _cursor_hide

    _sg_update_viewport

    _sg_draw_layout "$_SCREEN_WIDTH" "$_SCREEN_HEIGHT"
    _sg_draw_bottom_hints "$_SCREEN_WIDTH" "$_SCREEN_HEIGHT"
    _sg_draw_panel_info
    _sg_draw_menu
}

#==========
# _sg_test_node_is_executable
#
# Test if a given node path contains an executable field or not
#
# Returns:
# '0' if there are no commands defined or '1' otherwise
#
#==========
_sg_test_node_is_executable()
{
    local _node_path=$1
    shift

    local _return_status=''
    _copy "_return_status" "${_node_path}_env/0/CMD"
    if [ "$_return_status" = '' ]; then
        return 0
    else
        return 1
    fi
}

#==========
# _sg_execute_node
#
# Calls Space execution
#
# Expects:
# execute_args_array
#
#==========
_sg_execute_node()
{
    local _node_path=$1
    shift

    local _fork_pid=0
    local _fork_status=0
    _exec_dimensions "$_dim1ns" "$_node_path" "" "" "" "" "${_execute_args_array[@]}" &
    _fork_pid="$!"
     wait $_fork_pid
    _fork_status="$?"
    return "$_fork_status"
}

#==========
# _sg_entrypoint
#
# Main
#
#==========
_sg_entrypoint()
{
    local _keypress=''
    local diamond_pos=0

    _log_init
    _log "starting spacegui"

    _check_dependency_installed "tput"

    _keyboard_init

    # Load data
    _sg_load_menu

    # Do very first screen rendering
    _sg_render

    # Spawn job for updating top bar info
    _sg_draw_top_bar

    # Main loop
    while [ "$_EXIT" = 0 ]; do
        _keypress="$(cat -v)"

        if [ "$_keypress" = "q" ] || \
           [ "$_keypress" = "$KEY_ESC" ];then
            if [ "$_MENU_ENTRY_HAS_PARENT" -eq 1 ]; then
                # Go up a level
                _MENU_ENTRY_HAS_PARENT=0
                _curr_node=
                _MENU_ENTRY_PATH="$(dirname $_MENU_ENTRY_PATH)"
                _sg_clear_menu
                _sg_load_menu
                _sg_draw_menu
                _sg_draw_panel_info
            else
                _EXIT=1
            fi
        fi

        if [ "$_keypress" = "${KEY_ARROW_UP}" ] || \
           [ "$_keypress" = "k" ]; then
            if [ "$_MARKER_POS_X" -gt "$_MENU_ENTRY_POS_X_START" ]; then
                # Clear last pos
                _cursor_set_pos ${_MARKER_POS_X} 3
                printf " "

                # Mark new pos
                _MARKER_POS_X=$((_MARKER_POS_X-1))

                # Draw
                _sg_draw_menu
                _sg_draw_panel_info
            fi
        elif [ "$_keypress" = "${KEY_ARROW_DOWN}" ] || \
             [ "$_keypress" = "j" ]; then
            if [ "$_MARKER_POS_X" -lt "$((_MENU_ENTRY_POS_X_START + _MENU_ENTRY_COUNT-1))" ]; then
                _cursor_set_pos ${_MARKER_POS_X} 3
                printf " "

                # Mark new pos
                _MARKER_POS_X=$((_MARKER_POS_X+1))

                # Draw
                _sg_draw_menu
                _sg_draw_panel_info
            fi
        elif [ "$_keypress" = "${KEY_ENTER}" ]; then
            local _info_desc_x=3
            local _curr_node_index=$(( _MARKER_POS_X - _MENU_ENTRY_POS_X_START ))
            local _curr_node="${_MENU_ENTRY_ARRAY[$_curr_node_index]}"
            if [ "$_curr_node" != "/" ] && [ "$_curr_node" != ".." ]; then
                _curr_node="$_MENU_ENTRY_PATH$_curr_node/"
            fi
            local _curr_node_title=''

            # Check if node is NOT executable
            _sg_test_node_is_executable "$_curr_node"
            if [ "$?" -eq 0 ]; then
                if [ "$_curr_node" != "/" ]; then

                    # Go up a level or retrieve non-root node
                    if [ "$_curr_node" = ".." ]; then
                        _MENU_ENTRY_HAS_PARENT=0
                        _curr_node="$(dirname $_MENU_ENTRY_PATH)"
                    else
                        _MENU_ENTRY_HAS_PARENT=1
                    fi

                    _MENU_ENTRY_PATH="$_curr_node"

                    _sg_clear_menu
                    _sg_load_menu
                    _sg_draw_menu
                    _sg_draw_panel_info
                fi
            else
                # Prepare to execute command
                _cursor_set_pos ${_MARKER_POS_X} 3
                color=$_COLOR_SCHEME_TEXT_HIGHLIGHT
                _screen_set_write_color "${color}"
                printf "%s" "${_MARKER_SYMBOL}"

                # Reset screen, keyboard and mouse
                _screen_clear
                _cursor_show

                # Render command title
                _copy "_curr_node_title" "${_curr_node}_info/title"
                local _command_title="$_curr_node_title"
                _cursor_set_pos 1 0
                printf "%s" "$_command_title"
                _cursor_set_pos 2 0
                printf "%.${#_command_title}s" "-------------------------------------------------------"
                local _execute_args=("")
                local _execute_args_count=0
                local _execute_flag=0
                local _screenshot_switch=0
                local _key1=''
                local _key2=''
                local _key3=''
                _cursor_set_pos 4 0
                printf "Enter arguments: "
                while [ "$_execute_flag" -eq "0" ]; do
                    unset _key1 _key2 _key3
                    read -s -N1
                    _key1="$REPLY"
                    read -s -N2 -t 0.001
                    _key2="$REPLY"
                    read -s -N1 -t 0.001
                    _key3="$REPLY"
                    _keypress="$_key1$_key2$_key3"

                    if [ "$_keypress" = "$CHAR_ESC" ]; then
                        _execute_flag="999999"
                    elif [ "$_keypress" = "$CHAR_ENTER" ]; then
                        _execute_flag="1"
                    elif [ "$_keypress" = "$CHAR_TAB" ]; then
                        if [ "$_screenshot_switch" -eq 0 ]; then
                            _screenshot_switch=1
                            _screen_save
                            _sg_render
                        elif [ "$_screenshot_switch" -eq 1 ]; then
                            _screenshot_switch=0
                            _screen_restore
                        fi
                    elif [ "$_keypress" = "$CHAR_DEL" ]; then
                        if [ "$_execute_args_count" -gt 0 ]; then
                            printf "\b \b"
                            _execute_args_count=$((_execute_args_count-1))
                            # TODO: FIXME: bug when abusing key repeat here
                            _execute_args=${_execute_args%?}
                        fi
                    else
                        if [ -n "$_keypress" ]; then
                            printf "%s" "$_keypress"
                            _execute_args+="${_keypress//\"/}"
                            _execute_args_count=$((_execute_args_count+1))
                        fi
                    fi
                    sleep 0.1
                done

                # Assemble args as array
                local _execute_args_array=()
                local _args=''
                if [ -n "$_execute_args" ]; then
                    IFS=' ' read -a _execute_args_array <<< "$_execute_args"
                else
                    _execute_args_array+=("")
                fi

                # Execute node
                if [ "$_execute_flag" -eq "1" ]; then
                    local _status_code=-1
                    if [ -t 0 ]; then stty sane; fi # TODO: consider restoring STTY variable instead?
                    _cursor_set_pos 5 0
                    _sg_execute_node "$_curr_node" "${_execute_args_array}"
                    _status_code="$?"

                    # Setup return message based on return status
                    local _bottom_info=''
                    if [ "$_status_code" -eq "0" ]; then
                        _bottom_info="Done! Press any key to continue..."
                    else
                        _bottom_info="Failed to execute! Press any key to continue..."
                    fi

                    # Draw new message
                    local _color=$_COLOR_SCHEME_TEXT$COLOR_ATTRIB_REVERSE
                    _screen_set_write_color "${_color}"
                    _cursor_set_pos "$_SCREEN_HEIGHT" "0"
                    printf "%s" "${_bottom_info}"
                    read -n1 -rsp ""
                fi

                # Start keyboard capture again and redraw
                _keyboard_init
                _sg_render
            fi
        fi

        _sg_update_top_bar
        _sg_update_animated_split

        # EXTERNAL: sleep
        sleep 0.1
    done


    # Cleanup
    # EXTERNAL: rm
    rm "$_DATA_FILE"
    _screen_clear
    _sg_trap_exit
}

