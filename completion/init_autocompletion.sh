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
#   Spaces inside values isn't handled properly as for now.
#   Quoted values on -e flags makes the rest of the line non completable.
#   Can't handle -e -e var= because of the array concat.
#   compopt -o nospace is not available in bash3, workaround?
#
# TODO:
#   The parsing of COMP_WORDS has become horrendous.
#   It will need a rewrite and a solid way of rearranging the 
#   words to our preferred format. Bash3 and Bash4 seem to behave
#   differently on word splitting even dough their COMP_WORDBREAKS are the same.
#
#==========
[ -n "${BASH_VERSION}" ] &&
_space_dyn_comp()
{
    local timeout=$1
    shift
    local prefix=$1
    shift
    local args_tag=$1
    shift

    local shasbin=
    local tag=
    local status=
    local ts=$(date +"%s")
    if command -v sha256sum >/dev/null; then
        shasbin=sha256sum
    elif command -v sha1sum >/dev/null; then
        shasbin=sha1sum
    elif command -v shasum >/dev/null; then
        shasbin="shasum -a 256"
    else
        shasbin=
    fi
    if [ -n "${shasbin}" ] && [ "${timeout}" -gt 0 ]; then
        tag=$(echo "${prefix}${args_tag}" | ${shasbin} 2>/dev/null)
        tag="${tag%% *}"
        local filename="/tmp/space.$$.${tag}"
        if [ -f "${filename}" ]; then
            # Read file and decide if it's fresh or not
            result="$(cat ${filename})"
            local ts2=
            ts2="${result%%$'\n'*}"
            result="${result#*$'\n'}"
            status="${result%%$'\n'*}"
            if [ "${status}" = "${result}" ]; then
                # To handle ignored newlines on empty result.
                result=""
            else
                result="${result#*$'\n'}"
            fi
            if [ -n "${ts2}" ] && (( ts-ts2 < timeout )); then
                return $status
            fi
            # Fall through
        fi
    fi

    result=$(bash -c "$args")
    local status=$?
    if [ "${status}" -ne 1 ] && [ -n "${tag}" ] && [ "${timeout}" -gt 0 ]; then
        # Cache result.
        ts=$(date +"%s")  # Grab a fresh timestamp.
        local _umask=$(umask)
        umask 0077
        printf "%s\n%s\n%s\n" "${ts}" "${status}" "${result}" > "${filename}"
        umask "$_umask"
        if [ "$?" -gt 0 ]; then
            rm -f "${filename}"
        fi
    fi
    return $status
} &&
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
        length="$(( ${#COMP_WORDS[@]} - first ))"
    fi
    local A=("${COMP_WORDS[@]:$first:$length}")
    local sep=""
    if [ "${#A[@]}" -gt 0 ]; then
        for line in "${A[@]}"; do
            if [ "${line}" = '=' ] || [ "${last}" = '=' ]; then
                sep=""
            else
                sep=" "
            fi
            eval "$_dest=\"\${$_dest}$sep\$line\""
            last="${line}"
        done
    fi
} &&
_space()
{
    local switches="-f -m -a -M -e -d -p -v -h -V -C -U -X -k -K -S -E -L --"
    local timeout1="${SPACE_COMP_TIMEOUT1:-30}"
    local timeout2="${SPACE_COMP_TIMEOUT2:-30}"
    local args_tag=""
    local args_tag_full=""

    # If bash completion is installed we use it to "unbreak" some words for us,
    # this increases the user experience because with out it words containing any
    # breaking character can break the completion.
    if declare -F _get_comp_words_by_ref >/dev/null; then
        local words=() cword=
        _get_comp_words_by_ref -n ":" -w words cword
        COMP_WORDS=("${words[@]}")
        COMP_CWORD="${cword}"
    fi

    # Note: This is an attempt to make bash3 behave more like bash4,
    # but all in all this is somewhat of a hack and should be reconsidered.
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
                if [ "${#A[@]}" -gt 0 ]; then
                    COMP_WORDS+=("${A[@]}")
                fi
                continue 2
            fi
        done
        break
    done

    # Remove any redirection.
    if [ "${#COMP_WORDS[@]}" -gt 0 ]; then
        while true; do
            local last=${COMP_WORDS[((${#COMP_WORDS[@]}-1))]}
            if [[ $last =~ ([0-9]?[\ ]?[\<\>].*$) ]]; then
                last="${last%${BASH_REMATCH[1]}}"
                last="${last% }"
                COMP_WORDS[((${#COMP_WORDS[@]}-1))]="${last}"
                continue
            fi
            unset last
            break
        done
    fi

    local current=${COMP_WORDS[COMP_CWORD]}
    local previous=${COMP_WORDS[((COMP_CWORD-1))]}

    local args=
    while true; do
        # Check if cursor is beyond a double dash (--).
        local counter=0
        while (( counter < COMP_CWORD )); do
            if [ "${COMP_WORDS[$counter]}" = "--" ]; then
                # TODO: we might want to escape this.
                local part1=""
                _space_join_arr "part1" "1" $((COMP_CWORD-1))
                local index=$((COMP_CWORD-counter-1))
                args="${COMP_WORDS[0]} -v0 -6 $index=${current} $part1"
                _space_join_arr "args_tag" "1" "$((COMP_CWORD-1))"
                _space_join_arr "args_tag_full" "1" "$((COMP_CWORD))"
                break 2
            fi
            ((counter+=1))
        done
        unset counter

        if [[ ${current} == "-" ]]; then
            COMPREPLY=($(compgen -W "$switches" -- "$current"))
            return 0
        fi

        if [[ ((${#current} == 2)) && ${current:0:1} == "-" && $switches =~ "${current}" ]]; then
            # Complete with space, to keep stepping.
            COMPREPLY=("$current")
            return 0
        fi
        for s in "-K 0 1 2" "-X 1 2 3 4" "-v 0 1 2 3 4" "-C 0 1 2" "-k 0 1 2" "-L 0 1 2 3 4 5" ""; do
            local flag="${s%% *}"
            local options="${s#* }"
            for option in ${options}; do
                if ([ "${previous}" == "${flag}" ] && [ "${current}" == "${option}" ]) || [ "${current}" == "${flag}${option}" ]; then
                    COMPREPLY=("$current")
                    return 0
                fi
            done
            if [ "${previous}" == "${flag}" ]; then
                COMPREPLY=($(compgen -W "${options}" -- $current))
                return 0
            fi
        done

        # We want to separate switch from argument,
        # so that further completion works in a normalized manner.
        if [[ ((${#current} > 2)) && ${current:0:1} == "-" && $switches =~ "${current:0:2}" ]]; then
            command -v compopt >/dev/null && compopt -o nospace
            COMPREPLY=("${current:0:2} ${current:2}")
            return 0
        fi

        if [[ ${previous} == "-f" ]] || [[ ${previous} == "-E" ]]; then
            command -v compopt >/dev/null && compopt -o filenames
            COMPREPLY=($(compgen -G "$current*" -- $current))
            return 0
        fi

        if [[ ${previous} == "-m" || ${previous} == "-M" ]]; then
            args="${COMP_WORDS[0]} -v0 -3 ${current:-.}"
            timeout1=0
            break
        fi
        if [ "${previous}" = "-e" ]; then
            local part1=""
            _space_join_arr "part1" "1"
            args="${COMP_WORDS[0]} -v0 -4 . ${part1}"
            timeout1=0
            command -v compopt >/dev/null && compopt -o nospace
            break
        fi
        if [ "${current}" = "=" ]; then
            current=""
            if [ "${COMP_CWORD}" -ge 1 ]; then
                local _aprev="${COMP_WORDS[((COMP_CWORD-1))]}"
                if [ "${#_aprev}" -gt 2 ] && [ "${_aprev:0:2}" = "-e" ]; then
                    # Complete on empty value.
                    local part1=""
                    _space_join_arr "part1" "1"
                    args="${COMP_WORDS[0]} -v0 -5 ${_aprev:2}= ${part1}"
                    _space_join_arr "args_tag" "1" "$((COMP_CWORD))"
                    _space_join_arr "args_tag_full" "1" "$((COMP_CWORD))"
                    break
                fi
            fi
            if [ "${COMP_CWORD}" -ge 2 ]; then
                if [ "${COMP_WORDS[((COMP_CWORD-2))]}" == "-e" ]; then
                    # Complete on empty value.
                    local part1=""
                    _space_join_arr "part1" "1"
                    args="${COMP_WORDS[0]} -v0 -5 ${previous}= ${part1}"
                    _space_join_arr "args_tag" "1" "$((COMP_CWORD))"
                    _space_join_arr "args_tag_full" "1" "$((COMP_CWORD))"
                    break
                fi
            fi
        fi
        if [ "${previous}" = "=" ]; then
            if [ "${COMP_CWORD}" -ge 2 ]; then
                local _aprev="${COMP_WORDS[((COMP_CWORD-2))]}"
                if [ "${#_aprev}" -gt 2 ] && [ "${_aprev:0:2}" = "-e" ]; then
                    # Complete on value.
                    local part1=""
                    _space_join_arr "part1" "1"
                    args="${COMP_WORDS[0]} -v0 -5 ${_aprev:2}=${current} ${part1}"
                    _space_join_arr "args_tag" "1" "$((COMP_CWORD-1))"
                    _space_join_arr "args_tag_full" "1" "$((COMP_CWORD))"
                    break
                fi
            fi
            if [ "${COMP_CWORD}" -ge 3 ]; then
                if [ "${COMP_WORDS[((COMP_CWORD-3))]}" == "-e" ]; then
                    # Complete on value.
                    local _prevprev="${COMP_WORDS[((COMP_CWORD-2))]}"
                    local part1=""
                    _space_join_arr "part1" "1"
                    args="${COMP_WORDS[0]} -v0 -5 ${_prevprev}=${current} ${part1}"
                    _space_join_arr "args_tag" "1" "$((COMP_CWORD-1))"
                    _space_join_arr "args_tag_full" "1" "$((COMP_CWORD))"
                    break
                fi
            fi
        fi

        if [[ ${current:0:1} == "-" ]]; then
            # Unknown switch
            return 1
        fi

        # Assume node completion.
        # Set empty "node" to root node.
        if [[ ${current} == "" ]]; then
            current="/"
        fi
        local part1=""
        _space_join_arr "part1" "1" "$((COMP_CWORD-1))"
        local part2=""
        _space_join_arr "part2" "$((COMP_CWORD+1))"
        args="${COMP_WORDS[0]} -v0 ${part1} ${current} -1 ${part2}"
        timeout1=0
        command -v compopt >/dev/null && compopt -o nospace
        break
    done

    #########################################
    # Do dynamic completion by calling space.
    #

    # Run space completion in subshell.

    # If we detect any redirection, we quit.
    if [ "${args%>*}" != "${args}" ]; then
        return 1
    fi
    if [ "${args%<*}" != "${args}" ]; then
        return 1
    fi

    local result=
    _space_dyn_comp $timeout1 "first" "$args_tag"
    local status=$?
    if (( status == 2 )); then
        # Dynamic completion.
        local cachelevel=
        if [[ $result =~ (.*)[\ ](.*) ]]; then
            result=${BASH_REMATCH[1]}
            cachelevel=${BASH_REMATCH[2]}
        fi
        if [[ $result =~ ^[123]:G$ ]]; then
            command -v compopt >/dev/null && compopt -o filenames
            COMPREPLY=($(compgen -G "$current*" -- $current))
            return 0
        fi
        local part1=
        _space_join_arr "part1" "1"
        args="${COMP_WORDS[0]} -v0 $result ${part1}"
        local result=
        if [ "${cachelevel}" = 1 ]; then
            # Fine grained cache
            _space_dyn_comp $timeout2 "second" "$args_tag_full"
        elif [ "${cachelevel}" = 2 ]; then
            # Course cache
            _space_dyn_comp $timeout2 "second" "$args_tag"
        else
            # No cache
            _space_dyn_comp 0 "second" ""
        fi
        local status=$?
        local a=()
        while IFS=$'\n' read -r _line; do
            if [[ -n $_line ]] && [[ $_line =~ ^${current}.* ]]; then
                a+=("${_line}")
            fi
        done <<< "${result}"
        if [ "${#a[@]}" -eq 1 ]; then
            # Check if single line is a directory, then don't space it.
            if [ "${a[0]: -1}" = "/" ]; then
                command -v compopt >/dev/null && compopt -o nospace
            fi
        fi
        if [ "${#a[@]}" -gt 0 ]; then
            local _options=
            printf -v _options "%s " "${a[@]}"
            COMPREPLY=( $(compgen -W "${_options}" -- "${current}") )
            return $status
        fi
        return 1
    elif (( status == 3 )); then
        # This is a special case of rewriting the current word.
        # Fall through.
        :
    elif (( status == 4 )); then
        # This is a special case of adding trailing space to final word.
        command -v compopt >/dev/null && compopt +o nospace
    elif (( status > 0 )); then
        return 1
    fi

    local _items=()
    while IFS=$'\n' read -r _line; do
        _items+=("${_line}")
    done <<< "${result}"

    if (( ${#_items[@]} > 0 )); then
        if [ "${#_items[@]}" -eq 1 ] && [ -z "${_items[0]}" ]; then
            return 1
        fi
        if [ "${#_items[@]}" -eq 1 ]; then
            current="${_items[0]}"
            local _options="${_items[@]}"
        elif (( status == 3 )); then
            current="${_items[0]}"
            local _options="${_items[@]:1}"
        else
            local _options="${_items[@]}"
        fi

        COMPREPLY=( $(compgen -W "${_options}" -- "${current}") )
        return 0
    fi
    return 1
} && complete -F _space space
:

# ex: filetype=sh
