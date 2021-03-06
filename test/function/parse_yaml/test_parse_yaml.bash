#
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

_TEST_PARSE_YAML_CHECK_STATUS_OK()
{
    SPACE_DEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _pp_yaml _parse_yaml"
    SPACE_ENV="_SPACEGAL_EOF_TAG"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/test_spacefile.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile
    _parse_yaml "_yamlrows" "_parsedyaml" "_parsedyamlcompletion"

    # Check return status is good
    if [ "$?" -eq 0 ]; then
        PRINT "_parse_yaml OK!" "ok"
        return 0
    else
        PRINT "_parse_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PARSE_YAML_CHECK_PARSED_YAML_OK()
{
    SPACE_DEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _pp_yaml _parse_yaml"
    SPACE_ENV="_SPACEGAL_EOF_TAG"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/test_spacefile.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    local _expected_result='_0x5fenv_0_BIN0x5fPREFIX "/usr/local" _SPACEGAL_SAYS_END_OF_FINITY_ _0x5fenv_1_AC0x5fPREFIX "/usr/share/bash-completion/completions" _SPACEGAL_SAYS_END_OF_FINITY_ _0x5finfo_title Space.sh installer _SPACEGAL_SAYS_END_OF_FINITY_ _0x5finfo_desc Provides system wide installation and Bash auto-completion setup. Provides an uninstall utility for listing files originally installed by Space.  _SPACEGAL_SAYS_END_OF_FINITY_ _0x5fdep0x5finstall_0x5finfo_title Verify Space dependencies _SPACEGAL_SAYS_END_OF_FINITY_ _0x5fdep0x5finstall_0x5fenv_0_RUN SPACE_DEP_INSTALL _SPACEGAL_SAYS_END_OF_FINITY_ _install_0x5finfo_title Install Space.sh _SPACEGAL_SAYS_END_OF_FINITY_ _install_0x5finfo_desc Perform Space.sh install. Parameters (both optional):     1: BIN_PREFIX which is where the program and man page will be installed.     2: AC_PREFIX where the auto completion will be installed. Example (using default values):     ./space /install/ -- "/usr/local" "/usr/share/bash-completion/completions"  _SPACEGAL_SAYS_END_OF_FINITY_ _install_0x5fenv_0_RUN SPACE_INSTALL _SPACEGAL_SAYS_END_OF_FINITY_ _uninstall_0x5finfo_title Uninstall Space.sh _SPACEGAL_SAYS_END_OF_FINITY_ _uninstall_0x5finfo_desc Auto detects and lists all the files originally installed by Space.sh.  _SPACEGAL_SAYS_END_OF_FINITY_ _uninstall_0x5fenv_0_RUN SPACE_UNINSTALL _SPACEGAL_SAYS_END_OF_FINITY_'

    _pp_yaml "_yamlrows" $_yamlfile
    _parse_yaml "_yamlrows" "_parsedyaml" "_parsedyamlcompletion"

    # Check return status is good
    if [ "${_parsedyaml[*]}" = "${_expected_result}" ]; then
        PRINT "_parse_yaml OK!" "ok"
        return 0
    else
        PRINT "_parse_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PARSE_YAML_CHECK_PARSED_YAML_FAIL()
{
    SPACE_DEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _pp_yaml _parse_yaml"
    SPACE_ENV="_SPACEGAL_EOF_TAG"

    local _yamlrows=("") _yamlfilelist=""
    local _yamlfile="./Spacefile.bash"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=("")

    _pp_yaml "_yamlrows" $_yamlfile
    _parse_yaml "_yamlrows" "_parsedyaml" "_parsedyamlcompletion"

    # Expect empty parse
    if [ "${_parsedyaml[0]}" = "" ]; then
        PRINT "_parse_yaml OK!" "ok"
        return 0
    else
        PRINT "_parse_yaml failed!" "error"
        return "$?"
    fi
}

