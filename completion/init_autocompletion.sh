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

#==========
# _space
#
# Tab auto completion for bash and zsh.
#
# Bugs: there are still some zsh related oddities.
#
#==========
_space()
{
    local _current=${COMP_WORDS[COMP_CWORD]}
    local _previous=${COMP_WORDS[((COMP_CWORD-1))]}
    local _switches="-f -m -a -M -c -e -d -p -v -h -H -V -C -U -X -k -K -S --"
    local _switchesmute="-f -c -e -d -p -v -h -H -V -C -U -X -k -K -S --"

    # Check if cursor is beyond a duoble dash (--), then we only complete using glob.
    local _counter=0
    while (( _counter < COMP_CWORD )); do
        if [[ ${COMP_WORDS[$_counter]} == "--" ]]; then
            COMPREPLY=($(compgen -G "$_current*"))
            return 0
        fi
        ((_counter+=1))
    done

    # Complete to step further.
    if [[ ((${#_current} == 2)) && ${_current:0:1} == "-" && $_switches =~ "${_current}" ]]; then
        COMPREPLY=("$_current")
        return 0
    fi

    # We want to separate switch from argument.
    if [[ ((${#_current} > 2)) && ${_current:0:1} == "-" && $_switches =~ "${_current:0:2}" ]]; then
        # BUG: The space separation doesn't happen in zsh.
        COMPREPLY=("${_current:0:2} ${_current:2}")
        return 0
    fi

    # First check for simple switches to complete.
    if [[ ${_current} == "-" ]]; then
        COMPREPLY=($(compgen -W "$_switches" -- $_current))
        return 0
    elif [[ ${_previous} == "--" ]]; then
        COMPREPLY=($(compgen -G "$_current*"))
        return 0
    elif [[ ${_previous} == "-f" ]]; then
        COMPREPLY=($(compgen -G "$_current*"))
        return 0
    elif [[ ${_previous} == "-v" ]]; then
        COMPREPLY=($(compgen -W "0 1 2 3 4" -- $_current))
        return 0
    elif [[ ${_previous} == "-C" ]]; then
        COMPREPLY=($(compgen -W "0 1 2" -- $_current))
        return 0
    elif [[ ${_previous} == "-X" ]]; then
        COMPREPLY=($(compgen -W "1 2 3 4" -- $_current))
        return 0
    elif [[ ${_previous} == "-k" ]]; then
        COMPREPLY=($(compgen -W "0 1 2" -- $_current))
        return 0
    elif [[ ${_previous} == "-K" ]]; then
        COMPREPLY=($(compgen -W "0 1 2" -- $_current))
        return 0
    fi

    # Second check for switches not to complete using space.
    if [[ ((${#_previous} == 2)) && ${_previous:0:1} == "-" && $_switchesmute =~ "${_previous}" ]]; then
        return 1
    fi

    local _args=
    # Note: we disable pre process variable auto completion for now, since it's use case is questioned.
    #if [[ ${_previous} == "-p" ]]; then
        #if [[ ${_current} == "" ]]; then
            #_current="."
        #fi
        #_args="${COMP_WORDS[0]} -v0 -2 ${_current} ${COMP_WORDS[@]:1}"
    if [[ ${_previous} == "-m" || ${_previous} == "-M" ]]; then
        if [[ ${_current} == "" ]]; then
            _current="."
        fi
        _args="${COMP_WORDS[0]} -v0 -3 ${_current}"
    else
        # Assume node completion.
        # Set empty "node" to root node.
        if [[ ${_current} == "" ]]; then
            _current="/"
        fi
        _args="${COMP_WORDS[0]} -v0 ${COMP_WORDS[@]:1:(($COMP_CWORD-1))} ${_current} -1 ${COMP_WORDS[@]:(($COMP_CWORD+1))}"
    fi

    if [[ -n $_args ]]; then
        # For some reason bash separates -x=y arguments with spaces so we have to hack them back next to each other.
        _args=${_args//\ =\ /=}

        # Run space completion in subshell.
        local _list="$($_args)"
        if (( $? > 0 )); then
            return 1
        fi

        local _items=() _el=
        for _el in $_list; do
            _items+=("$_el")
        done

        if (( ${#_items[@]} > 0 )); then
            local _default=${_items[0]}
            if [[ $_default == "." ]]; then
                _default=""
            fi
            local _options="${_items[@]:1}"
            COMPREPLY=( $(compgen -W "${_options}" -- ${_default}) )
            return 0
        else
            return 1
        fi
    fi
}

# Test if zsh and then make it bash completion compatible.
if [[ -n ${ZSH_VERSION-} ]]; then
    autoload -U compinit && compinit
    autoload -U bashcompinit && bashcompinit
fi

complete -o nospace -F _space space

