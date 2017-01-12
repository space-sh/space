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

_TEST_YAML_GET_ROW_CHECK_STATUS_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_row"
    SPACE_CMDENV=""

    local _row_index=0
    local _preprocess=0
    local _allrows=("row1" "row two three four" "another one" "testing anOther_row:")

    _yaml_get_row "$_row_index" "$_preprocess"

    # Check return status is good
    if [ "$?" -eq 0 ]; then
        PRINT "_yaml_get_row OK!" "ok"
        return 0
    else
        PRINT "_yaml_get_row failed!" "error"
        return "$?"
    fi
}

_TEST_YAML_GET_ROW_CHECK_PREPROCESS_STATUS_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_row"
    SPACE_CMDENV=""

    local _row_index=0
    local _preprocess=1
    local _allrows=("row1" "row two three four" "another one" "testing anOther_row:")

    _yaml_get_row "$_row_index" "$_preprocess"

    # Expect failure here
    if [ "$?" -eq 0 ]; then
        PRINT "_yaml_get_row OK!" "ok"
        return 0
    else
        PRINT "_yaml_get_row failed!" "error"
        return "$?"
    fi
}

_TEST_YAML_GET_ROW_CHECK_RETURNED_ROW_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_row"
    SPACE_CMDENV=""

    local _row_index=3
    local _preprocess=0
    local _allrows=("row1" "row two three four" "another one" "testing anOther_row:")
    local _row=''

    _yaml_get_row "$_row_index" "$_preprocess"

    # Check returned row matches expected output
    if [ "$_row" = "testing anOther_row:" ]; then
        PRINT "_yaml_get_row OK!" "ok"
        return 0
    else
        PRINT "_yaml_get_row failed!" "error"
        return "$?"
    fi
}

_TEST_YAML_GET_ROW_CHECK_RETURNED_PREPROCESS_ROW_OK()
{
    SPACE_CMDDEP="PRINT _yaml_get_row"
    SPACE_CMDENV=""

    local _row_index=1
    local _preprocess=1
    local _allrows=("row1" "A: @{_PP_somevar:-test data is good}" "another one" "testing anOther_row:")
    local _row=''

    _yaml_get_row "$_row_index" "$_preprocess"

    # Check returned row matches expected output
    if [ "$_row" = "A: test data is good" ]; then
        PRINT "_yaml_get_row OK!" "ok"
        return 0
    else
        PRINT "_yaml_get_row failed!" "error"
        return "$?"
    fi
}

