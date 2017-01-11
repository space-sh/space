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

_TEST_SOURCE_ONE_CHECK_STATUS()
{
    SPACE_CMDDEP="PRINT _source"

    _SOURCE_FILES=()
    local _expected_output=("./adding_file.extension")

    _source "./adding_file.extension"

    # Check return is OK
    if [ "$?" -eq 0 ]; then
        PRINT "_source OK!" "ok"
        return 0
    else
        PRINT "_source failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ONE_CHECK_STATE_CHANGED()
{
    SPACE_CMDDEP="PRINT _source"

    _SOURCE_FILES=()
    local _expected_output=("./adding_file.extension")

    _source "./adding_file.extension"

    # Check SOURCE_FILES has been filled
    if [ "${#_SOURCE_FILES[@]}" -eq 1 ]; then
        PRINT "_source OK!" "ok"
        return 0
    else
        PRINT "_source failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ONE_CHECK_EXPECTED_OUTPUT()
{
    SPACE_CMDDEP="PRINT _source"

    _SOURCE_FILES=()
    local _expected_output=("./adding_file.extension")

    _source "./adding_file.extension"

    # Check expected output matches current SOURCE_FILES
    if [ "${_SOURCE_FILES[*]}" = "${_expected_output[*]}" ]; then
        PRINT "_source OK!" "ok"
        return 0
    else
        PRINT "_source failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_MULTIPLE_CHECK_STATUS()
{
    SPACE_CMDDEP="PRINT _source"

    _SOURCE_FILES=()
    local _expected_output=("./adding_file.extension" "adding_various_files" "/more/source/testing_123/" "path_shouldnt_matter_at_this_stage!!11" "/more/source/testing_123/")

    _source "./adding_file.extension"
    _source "adding_various_files"
    _source "/more/source/testing_123/"
    _source "path_shouldnt_matter_at_this_stage!!11"
    _source "/more/source/testing_123/" "multiple params also shouldn't matter"

    # Check return is OK
    if [ "$?" -eq 0 ]; then
        PRINT "_source OK!" "ok"
        return 0
    else
        PRINT "_source failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_MULTIPLE_CHECK_STATE_CHANGED()
{
    SPACE_CMDDEP="PRINT _source"

    _SOURCE_FILES=()
    local _expected_output=("./adding_file.extension" "adding_various_files" "/more/source/testing_123/" "path_shouldnt_matter_at_this_stage!!11" "/more/source/testing_123/")

    _source "./adding_file.extension"
    _source "adding_various_files"
    _source "/more/source/testing_123/"
    _source "path_shouldnt_matter_at_this_stage!!11"
    _source "/more/source/testing_123/" "multiple params also shouldn't matter"

    # Check SOURCE_FILES has been filled
    if [ "${#_SOURCE_FILES[@]}" -eq 5 ]; then
        PRINT "_source OK!" "ok"
        return 0
    else
        PRINT "_source failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_MULTIPLE_CHECK_EXPECTED_OUTPUT()
{
    SPACE_CMDDEP="PRINT _source"

    _SOURCE_FILES=()
    local _expected_output=("./adding_file.extension" "adding_various_files" "/more/source/testing_123/" "path_shouldnt_matter_at_this_stage!!11" "/more/source/testing_123/")

    _source "./adding_file.extension"
    _source "adding_various_files"
    _source "/more/source/testing_123/"
    _source "path_shouldnt_matter_at_this_stage!!11"
    _source "/more/source/testing_123/" "multiple params also shouldn't matter"

    # Check expected output matches current SOURCE_FILES
    if [ "${_SOURCE_FILES[*]}" = "${_expected_output[*]}" ]; then
        PRINT "_source OK!" "ok"
        return 0
    else
        PRINT "_source failed!" "error"
        return "$?"
    fi
}

