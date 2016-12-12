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

_TEST_SOURCE_ADDED_SINGLE_CHECK_STATUS()
{
    SPACE_CMDDEP="PRINT _source_added"

    # Define expected global
    _SOURCE_FILES=("./test/function/source_added/test_source_added.bash")

    # Mock dependency
    _MOCK_ADDED_COUNT=0
    _source_file()
    {
        local _filepaths=$1
        for _filepath in $_filepaths; do
            if [ ! -f "$_filepath" ]; then
                PRINT "_source_added failed!" "error"
                return 1
            else
                _MOCK_ADDED_COUNT=$((_MOCK_ADDED_COUNT+1))
            fi
        done
    }

    _source_added

    # Check return is OK
    if [ "$?" -eq 0 ]; then
        PRINT "_source_added OK!" "success"
    else
        PRINT "_source_added failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ADDED_SINGLE_CHECK_STATE_CHANGED_0()
{
    SPACE_CMDDEP="PRINT _source_added"

    # Define expected global
    _SOURCE_FILES=("./test/function/source_added/test_source_added.bash")

    # Mock dependency
    _MOCK_ADDED_COUNT=0
    _source_file()
    {
        local _filepaths=$1
        for _filepath in $_filepaths; do
            if [ ! -f "$_filepath" ]; then
                PRINT "_source_added failed!" "error"
                return 1
            else
                _MOCK_ADDED_COUNT=$((_MOCK_ADDED_COUNT+1))
            fi
        done
    }

    _source_added

    # Check global var has been reset
    if [ "${#_SOURCE_FILES[@]}" -eq 0 ]; then
        PRINT "_source_added OK!" "success"
    else
        PRINT "_source_added failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ADDED_SINGLE_CHECK_STATE_CHANGED_1()
{
    SPACE_CMDDEP="PRINT _source_added"

    # Define expected global
    _SOURCE_FILES=("./test/function/source_added/test_source_added.bash")

    # Mock dependency
    _MOCK_ADDED_COUNT=0
    _source_file()
    {
        local _filepaths=$1
        for _filepath in $_filepaths; do
            if [ ! -f "$_filepath" ]; then
                PRINT "_source_added failed!" "error"
                return 1
            else
                _MOCK_ADDED_COUNT=$((_MOCK_ADDED_COUNT+1))
            fi
        done
    }

    _source_added

    # Check _source_file has been called to do the actual job
    if [ "$_MOCK_ADDED_COUNT" -eq 1 ]; then
        PRINT "_source_added OK!" "success"
    else
        PRINT "_source_added failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ADDED_MULTIPLE_CHECK_STATUS()
{
    SPACE_CMDDEP="PRINT _source_added"

    # Define expected global
    _SOURCE_FILES=("./test/function/source_added/test_source_added.bash" "./test/function/source_added/test_source_added.yaml")

    # Mock dependency
    _MOCK_ADDED_COUNT=0
    _source_file()
    {
        local _filepaths=$1
        for _filepath in $_filepaths; do
            if [ ! -f "$_filepath" ]; then
                PRINT "_source_added failed!" "error"
                return 1
            else
                _MOCK_ADDED_COUNT=$((_MOCK_ADDED_COUNT+1))
            fi
        done
    }

    _source_added

    # Check return is OK
    if [ "$?" -eq 0 ]; then
        PRINT "_source_added OK!" "success"
    else
        PRINT "_source_added failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ADDED_MULTIPLE_CHECK_STATE_CHANGED_0()
{
    SPACE_CMDDEP="PRINT _source_added"

    # Define expected global
    _SOURCE_FILES=("./test/function/source_added/test_source_added.bash" "./test/function/source_added/test_source_added.yaml")

    # Mock dependency
    _MOCK_ADDED_COUNT=0
    _source_file()
    {
        local _filepaths=$1
        for _filepath in $_filepaths; do
            if [ ! -f "$_filepath" ]; then
                PRINT "_source_added failed!" "error"
                return 1
            else
                _MOCK_ADDED_COUNT=$((_MOCK_ADDED_COUNT+1))
            fi
        done
    }

    _source_added

    # Check global var has been reset
    if [ "${#_SOURCE_FILES[@]}" -eq 0 ]; then
        PRINT "_source_added OK!" "success"
    else
        PRINT "_source_added failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_ADDED_MULTIPLE_CHECK_STATE_CHANGED_1()
{
    SPACE_CMDDEP="PRINT _source_added"

    # Define expected global
    _SOURCE_FILES=("./test/function/source_added/test_source_added.bash" "./test/function/source_added/test_source_added.yaml")

    # Mock dependency
    _MOCK_ADDED_COUNT=0
    _source_file()
    {
        local _filepaths=$1
        for _filepath in $_filepaths; do
            if [ ! -f "$_filepath" ]; then
                PRINT "_source_added failed!" "error"
                return 1
            else
                _MOCK_ADDED_COUNT=$((_MOCK_ADDED_COUNT+1))
            fi
        done
    }

    _source_added

    # Check _source_file has been called to do the actual job
    if [ "$_MOCK_ADDED_COUNT" -eq 2 ]; then
        PRINT "_source_added OK!" "success"
    else
        PRINT "_source_added failed!" "error"
        return "$?"
    fi
}

