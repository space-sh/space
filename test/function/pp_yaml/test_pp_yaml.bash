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

_TEST_PP_YAML_CHECK_STATUS_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _debug _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/good_config.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile

    # Check return status is good
    if [ "$?" -eq 0 ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_PREPROCESSED_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _debug _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/good_config.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()
    local _expected_output='_env:     - BIN_PREFIX: "/usr/local"     - AC_PREFIX: "/usr/share/bash-completion/completions" _info:     title: SpaceGal shell installer     desc: |         Provides system wide installation and Bash auto-completion setup.         Provides an uninstall utility for listing files originally installed by Space. _dep_install:     _info:         title: Verify Space dependencies     _env:         - CMD: SPACE_DEP_INSTALL install:     _info:         title: Install SpaceGal shell         desc: |             Perform SpaceGal shell install.             Parameters (both optional):                 1: BIN_PREFIX which is where the program and man page will be installed.                 2: AC_PREFIX where the auto completion will be installed.             Example (using default values):                 ./space /install/ -- "/usr/local" "/usr/share/bash-completion/completions"     _env:         - CMD: SPACE_INSTALL uninstall:     _info:         title: Uninstall SpaceGal shell         desc: |             Auto detects and lists all the files originally installed by SpaceGal shell.     _env:         - CMD: SPACE_UNINSTALL _env:     - SOME_VAR: "false" install:     _info:         title: TEST TITLE         desc: |             t1             t2 t7             t3 t4 t5     _env:         - CMD: ""'

    _pp_yaml "_yamlrows" $_yamlfile

    # Check return matches expected output
    if [ "${_yamlrows[*]}" = "${_expected_output}" ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_STATUS_FAIL_1()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./this_file_does_not_exist.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile

    # Expecting failure here
    if [ "$?" -eq 1 ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_STATUS_FAIL_2()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/bad_include.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile 2> /dev/null

    # Expecting failure here
    if [ "$?" -eq 2 ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_STATUS_FAIL_3()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/bad_clone.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile 2> /dev/null

    # Expecting failure here
    if [ "$?" -eq 3 ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_STATUS_FAIL_4()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _debug _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/bad_assert.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile 2> /dev/null

    # Expecting failure here
    if [ "$?" -eq 4 ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_FILTER_STATUS_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _debug _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/good_config.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()

    _pp_yaml "_yamlrows" $_yamlfile "/tests/0/"

    # Check return status is good
    if [ "$?" -eq 0 ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_FILTER_PREPROCESSED_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _debug _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/good_config.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()
    local _expected_output='_info:     title: TEST TITLE     desc: |         t1         t2 t7         t3 t4 t5 _env:     - CMD: ""'

    _pp_yaml "_yamlrows" $_yamlfile "/install/"

    # Check return matches expected output
    if [ "${_yamlrows[*]}" = "${_expected_output}" ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

_TEST_PP_YAML_CHECK_INHERITED_INDENT_PREPROCESSED_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_multiline _yaml_get_next _yaml_get_row _yaml_find_nextindent _module_find_yaml _error _print _debug _pp_yaml"
    SPACE_CMDENV="_SPACEGAL_EOF_TAG _VERBOSITY _TERM _COLOR_RED"

    local _yamlrows=() _yamlfilelist=""
    local _yamlfile="./test/function/pp_yaml/good_config.yml"
    local _PP_DIR=${_yamlfile%/*}
    local _INCLUDEPATH=("")
    local _parsedyaml=()
    local _expected_output='      _info:           title: TEST TITLE           desc: |               t1               t2 t7               t3 t4 t5       _env:           - CMD: ""'

    _pp_yaml "_yamlrows" $_yamlfile "/install/" "6"

    # Check return matches expected output
    if [ "${_yamlrows[*]}" = "${_expected_output}" ]; then
        PRINT "_pp_yaml OK!" "success"
        return 0
    else
        PRINT "_pp_yaml failed!" "error"
        return "$?"
    fi
}

