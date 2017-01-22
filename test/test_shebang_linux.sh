#!/usr/bin/env bash
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

#======================
# Test Space shebang line
# Linux style
#
#======================
set -o nounset

#======================
# _CHECK_CONTAINS
#
# Checks if a piece of data is part of a bigger string
#
# Parameters:
#   1: the string to find
#   2: the data to check against
#
# Returns:
#   1 if it finds a match
#
#======================
_CHECK_CONTAINS()
{
    local _contains="$1"
    local _string="$2"
    if [ -z "${_string##*$_contains*}" ]; then
        return 1
    else
        return 0
    fi
}

#======================
# _RUN_CHECK_FAIL
#
# Wraps a Space command line call for testing
#
# Note:
#   Avoiding command substitution and subshelling while still 
#   providing full command call via parameters.
#   Makes it so that the test toolset can keep track of function calls.
#
# Parameters:
#   1: message describing what the check is about
#   2: expected message on stdout/err
#   3: command line to test
#======================
_RUN_CHECK_FAIL()
{
    local _message_description=$1
    shift
    local _expected_message=$1
    shift
    local _command_line=$@
    local _status=
    local _output=

    _output=$($_command_line 2>&1)
    _status="$?"
    if [ "$_status" -ne 0 ]; then
        _CHECK_CONTAINS "$_expected_message" "$_output"
        if [ "$?" -eq 1 ]; then
            printf "\033[32m[OK] %s\033[0m\n" "$_message_description"
        else
            printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tExpected output to contain: \"%s\"\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_expected_message" "$_output"
            exit 1
        fi
    else
        printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tFailed with exit status (%s)\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_status" "$_output"
        exit 1
    fi
}

_RUN_CHECK_FAIL "Test shebang line" "Wait for files timeouted after 2 seconds" ./test/exit_status_cases/shebang_linux.sh -m docker /run_wrap/ -- 2
