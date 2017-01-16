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

_TEST_SOURCE_FILE_NON_EXISTANT_CHECK_FAILURE()
{
    SPACE_DEP="PRINT _source_file _error _print"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    _source_file "./some_non-existanT-F1le.txt" > /dev/null 2>&1

    # Expect failure
    if [ "$?" -eq 1 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_NON_EXISTANT_CHECK_NO_TOUCH()
{
    SPACE_DEP="PRINT _source_file _error _print"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    _source_file "./some_non-existanT-F1le.txt" > /dev/null 2>&1

    # Assert that _SOURCE_FILES_TOTAL has remained untouched
    if [ "${#_SOURCE_FILES_TOTAL[*]}" -eq 0 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_ONE_CHECK_RETURN()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    # Source itself
    _source_file "./test/function/source_file/test_source_file.bash" > /dev/null 2>&1

    # Check if return status is OK
    if [ "$?" -eq 0 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_ONE_CHECK_TOUCH()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    # Source itself
    _source_file "./test/function/source_file/test_source_file.bash" > /dev/null 2>&1

    # Check _SOURCE_FILES_TOTAL has been updated, holding exactly one record
    if [ "${#_SOURCE_FILES_TOTAL[*]}" -eq 1 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_ONE_CHECK_SYNTAX_RETURN()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    # Try to source an YAML instead to trigger syntax error
    _source_file "./test/function/source_file/test_source_file.yaml" > /dev/null 2>&1

    # Expects failure
    if [ "$?" -eq 1 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_ONE_CHECK_SYNTAX_TOUCH()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    # Try to source an YAML instead to trigger syntax error
    _source_file "./test/function/source_file/test_source_file.yaml" > /dev/null 2>&1

    # Check _SOURCE_FILES_TOTAL has NOT been touched
    if [ "${#_SOURCE_FILES_TOTAL[*]}" -eq 0 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_MULTIPLE_CHECK_RETURN()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    _source_file "./test/function/source_file/test_source_file.bash" > /dev/null 2>&1
    _source_file "./test/function/source/test_source.bash" > /dev/null 2>&1
    _source_file "./test/function/source_added/test_source_added.bash" > /dev/null 2>&1

    # Check if return status is OK
    if [ "$?" -eq 0 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_MULTIPLE_CHECK_TOUCH()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    _source_file "./test/function/source_file/test_source_file.bash" > /dev/null 2>&1
    _source_file "./test/function/source/test_source.bash" > /dev/null 2>&1
    _source_file "./test/function/source_added/test_source_added.bash" > /dev/null 2>&1

    # Check _SOURCE_FILES_TOTAL has been updated, holding multiple records
    if [ "${#_SOURCE_FILES_TOTAL[*]}" -eq 3 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_MULTIPLE_CHECK_SYNTAX_RETURN()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    _source_file "./test/function/source/test_source.bash" > /dev/null 2>&1
    _source_file "./test/function/source_added/test_source_added.bash" > /dev/null 2>&1

    # Now source an YAML triggering an exit status
    _source_file "./test/function/source_file/test_source_file.yaml" > /dev/null 2>&1


    # Expect failure
    if [ "$?" -eq 1 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

_TEST_SOURCE_FILE_MULTIPLE_CHECK_SYNTAX_TOUCH()
{
    SPACE_DEP="PRINT _source_file _error _print _debug"
    SPACE_ENV="_VERBOSITY _COLOR_FG_RED _COLOR_DEFAULT"

    # Dummy
    _SOURCE_FILES_TOTAL=()

    # Start by sourcing an YAML instead. This will fail to add to SOURCE_FILES_TOTAL
    _source_file "./test/function/source_file/test_source_file.yaml" > /dev/null 2>&1
    _source_file "./test/function/source/test_source.bash" > /dev/null 2>&1
    _source_file "./test/function/source_added/test_source_added.bash" > /dev/null 2>&1

    # Check _SOURCE_FILES_TOTAL has been updated with only one failure
    if [ "${#_SOURCE_FILES_TOTAL[*]}" -eq 2 ]; then
        PRINT "_source_file OK!" "ok"
        return 0
    else
        PRINT "_source_file failed!" "error"
        return "$?"
    fi
}

