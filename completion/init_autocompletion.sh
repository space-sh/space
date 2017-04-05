# Copyright 2016-2017 Blockie AB
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

#==========
# _space
#
# Tab auto completion for Bash.
# zsh would work with this if it would word split on '=' and if
# completed words could be replaced and not just appended to.
#
# Caveats:
#   -e var="long value"[tab]
#   will not work because word spitting gives '="'.
#   Instead escape spaces as, -e var=long\ value
#
#==========
[ -n "${BASH_VERSION}" ] &&
_space_join_arr()
{
    local _dest="${1}"
    shift
    local last=
    local first="${1-0}"
    shift || :
    local length="${1-}"
    shift || :
    if [ -z "${length}" ]; then
        length="$(( ${#COMP_WORDS[@]} - $first ))"
    fi
    local A=("${COMP_WORDS[@]:$first:$length}")
    local sep=""
    for line in "${A[@]}"
    do
        if [ "${line}" = '=' ] || ([ "${last}" = '=' ] && [ "${line:0:1}" != "-" ] ); then
            sep=""
        else
            sep=" "
        fi
        eval "$_dest=\"\${$_dest}$sep\$line\""
        last="${line}"
    done
} &&
_space()
{
    local _switches="-f -m -a -M -e -d -p -v -h -V -C -U -X -k -K -S --"

    # We might need to adjust the array to the Bash 4 format
    # where it splits on equal signs according to COMP_WORDBREAKS.
    local i=
    while true; do
        for ((i=0; i<${#COMP_WORDS[@]}; i++)); do
            local line=${COMP_WORDS[$i]}
            local l="${line%%=*}"
            local r="${line#*=}"
            if [ "${l}" != "${r}" ]; then
                local A=("${COMP_WORDS[@]:((i+1))}")
                COMP_WORDS=("${COMP_WORDS[@]:0:$i}")
                if [ -n "${l}" ]; then
                    COMP_WORDS+=("$l")
                fi
                COMP_WORDS+=("=")
                if [ -n "${r}" ]; then
                    COMP_WORDS+=("$r")
                fi
                if [ $COMP_CWORD -ge $i ]; then
                    if [ -n "${l}" ]; then
                        ((COMP_CWORD+=1))
                    fi
                    if [ -n "${r}" ]; then
                        ((COMP_CWORD+=1))
                    fi
                fi
                COMP_WORDS+=("${A[@]}")
                continue 2
            fi
        done
        break
    done
    local _current=${COMP_WORDS[COMP_CWORD]}
    local _previous=${COMP_WORDS[((COMP_CWORD-1))]}

    local _args=
    while true; do
        # Check if cursor is beyond a double dash (--).
        local _counter=0
        while (( _counter < COMP_CWORD )); do
            if [ "${COMP_WORDS[$_counter]}" = "--" ]; then
                # TODO: this must be unescaped at back end.
                local _arg=${_current//\"/\\\"}
                local part1=""
                _space_join_arr "part1" "1" $(($COMP_CWORD-1))
                local index=$((COMP_CWORD-_counter-1))
                _args="${COMP_WORDS[0]} -v0 -6 $index=${_current} $part1"
                break 2
            fi
            ((_counter+=1))
        done

        if [[ ${_current} == "-" ]]; then
            COMPREPLY=($(compgen -W "$_switches" -- "$_current"))
            return 0
        fi

        if [[ ((${#_current} == 2)) && ${_current:0:1} == "-" && $_switches =~ "${_current}" ]]; then
            # Complete with space, to keep stepping.
            COMPREPLY=("$_current ")
            return 0
        fi
        for s in "-K 0 1 2" "-X 1 2 3 4" "-v 0 1 2 3 4" "-C 0 1 2" "-k 0 1 2" ""; do
            local flag="${s%% *}"
            local options="${s#* }"
            for option in ${options}; do
                if ([ "${_previous}" == "${flag}" ] && [ "${_current}" == "${option}" ]) || [ "${_current}" == "${flag}${option}" ]; then
                    COMPREPLY=("$_current ")
                    return 0
                fi
            done
            if [ "${_previous}" == "${flag}" ]; then
                COMPREPLY=($(compgen -W "${options}" -- $_current))
                return 0
            fi
        done

        if [ "${_current}" == "-f" ]; then
            COMPREPLY=("$_current ")
            return 0
        fi

        # We want to separate switch from argument,
        # so that further completion works in a normalized manner.
        if [[ ((${#_current} > 2)) && ${_current:0:1} == "-" && $_switches =~ "${_current:0:2}" ]]; then
            COMPREPLY=("${_current:0:2} ${_current:2}")
            return 0
        fi

        if [[ ${_previous} == "-f" ]]; then
            if [ -f "${_current}" ]; then
                COMPREPLY=("$_current ")
            else
                COMPREPLY=($(compgen -G "$_current*"))
            fi
            return 0
        fi

        if [[ ${_previous} == "-m" || ${_previous} == "-M" ]]; then
            if [[ ${_current} == "" ]]; then
                _current="."
            fi
            _args="${COMP_WORDS[0]} -v0 -3 ${_current}"
            break
        fi
        if [ "${_previous}" = "-e" ]; then
            if [[ ${_current} == "" ]]; then
                _current="."
            fi
            local part1=""
            _space_join_arr "part1" "1"
            _args="${COMP_WORDS[0]} -v0 -4 ${_current} ${part1}"
            break
        fi
        if [ "${_current}" = "=" ]; then
            if [ "${COMP_CWORD}" -ge 1 ]; then
                local _aprev="${COMP_WORDS[((COMP_CWORD-1))]}"
                if [ "${#_aprev}" > 2 ] && [ "${_aprev:0:2}" = "-e" ]; then
                    # Complete on empty value.
                    local part1=""
                    _space_join_arr "part1" "1"
                    _args="${COMP_WORDS[0]} -v0 -5 ${_aprev:2}= ${part1}"
                    break
                fi
            fi
            if [ "${COMP_CWORD}" -ge 2 ]; then
                if [ "${COMP_WORDS[((COMP_CWORD-2))]}" == "-e" ]; then
                    # Complete on empty value.
                    local part1=""
                    _space_join_arr "part1" "1"
                    _args="${COMP_WORDS[0]} -v0 -5 ${_previous}= ${part1}"
                    break
                fi
            fi
        fi
        if [ "${_previous}" = "=" ]; then
            if [ "${COMP_CWORD}" -ge 2 ]; then
                local _aprev="${COMP_WORDS[((COMP_CWORD-2))]}"
                if [ "${#_aprev}" > 2 ] && [ "${_aprev:0:2}" = "-e" ]; then
                    # Complete on value.
                    local part1=""
                    _space_join_arr "part1" "1"
                    _args="${COMP_WORDS[0]} -v0 -5 ${_aprev:2}=${_current} ${part1}"
                    break
                fi
            fi
            if [ "${COMP_CWORD}" -ge 3 ]; then
                if [ "${COMP_WORDS[((COMP_CWORD-3))]}" == "-e" ]; then
                    # Complete on value.
                    local _prevprev="${COMP_WORDS[((COMP_CWORD-2))]}"
                    local part1=""
                    _space_join_arr "part1" "1"
                    _args="${COMP_WORDS[0]} -v0 -5 ${_prevprev}=${_current} ${part1}"
                    break
                fi
            fi
        fi

        # Assume node completion.
        # Set empty "node" to root node.
        if [[ ${_current} == "" ]]; then
            _current="/"
        fi
        local part1=""
        _space_join_arr "part1" "1" "$(($COMP_CWORD-1))"
        local part2=""
        _space_join_arr "part2" "$(($COMP_CWORD+1))"
        _args="${COMP_WORDS[0]} -v0 ${part1} ${_current} -1 ${part2}"
        break

        return 1
    done

    #########################################
    # Do dynamic completion by calling space.

    # Run space completion in subshell.
    local result=
    result="$($_args)"
    local status=$?
    if (( $status == 2 )); then
        # Dynamic completion.
        local part1=
        _space_join_arr "part1" "1"
        _args="${COMP_WORDS[0]} -v0 $result ${part1}"
        local result=
        result="$($_args)"
        local status=$?
        if [ "${_current}" = "=" ]; then
            _current=""
        fi
        local a=()
        while IFS=$'\n' read -r _line; do
            if [[ $_line =~ ^${_current}.* ]]; then
                a+=("${_line}")
            fi
        done <<< "${result}"
        if [ "${#a[@]}" -eq 1 ]; then
            _current="${a[0]}"
            COMPREPLY=("$_current ")
            return $status
        fi
        local _options=
        printf -v _options "%s " "${a[@]}"
        COMPREPLY=( $(compgen -W "${_options}" -- "${_current}") )
        return $status
    elif (( $status > 0 )); then
        return 1
    fi

    local _items=()
    while IFS=$'\n' read -r _line; do
        _items+=("${_line}")
    done <<< "${result}"

    if (( ${#_items[@]} > 0 )); then
        local _default=${_items[0]}
        if [[ $_default == "." ]]; then
            _default=""
        fi
        if [ "${#_items[@]}" -eq 1 ]; then
            if [ -z "${_items[0]}" ]; then
                return 1
            fi
            COMPREPLY=("${_items[0]} ")
            return 0
        fi
        if [ "${#_items[@]}" -eq 2 ]; then
            COMPREPLY=("${_items[1]}")
            return 0
        fi
        local _options="${_items[@]:1}"
        COMPREPLY=( $(compgen -W "${_options}" -- "${_default}") )
        return 0
    fi

    return 1
} && complete -o nospace -F _space space
:

# ex: filetype=sh
