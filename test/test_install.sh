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
# Test Space install
#
# Test Space base module and make sure install works
#
#======================

set -o nounset

#
# Pass custom parameter for Space in case Git is not available
_SPACE_BIN="space"
if ! command -v git >/dev/null; then
    _SPACE_BIN="space -S"
    printf "\033[35mGit command is not available. Signaling Space with -S switch.\033[0m\n"
else
    printf "\033[35mGit command is available.\033[0m\n"
fi

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
# _RUN_CHECK_OK and FAIL
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
_RUN_CHECK_OK()
{
    local _message_description=$1
    shift
    local _expected_message=$1
    shift
    local _command_line=$@
    local _status=
    local _output=

    _output=$(bash $_command_line 2>&1)
    _status="$?"
    if [ "$_status" -eq 0 ]; then
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

_RUN_CHECK_FAIL()
{
    local _message_description=$1
    shift
    local _expected_message=$1
    shift
    local _command_line=$@
    local _status=
    local _output=

    _output=$(bash $_command_line 2>&1)
    _status="$?"
    if [ "$_status" -eq 0 ]; then
        printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tFailed with exit status (%s)\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_status" "$_output"
        exit 1
    else
        _CHECK_CONTAINS "$_expected_message" "$_output"
        if [ "$?" -eq 1 ]; then
            printf "\033[32m[OK] %s\033[0m\n" "$_message_description"
        else
            printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tExpected output to contain: \"%s\"\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_expected_message" "$_output"
            exit 1
        fi
    fi
}

printf "\033[35mTesting base Space module...\033[0m\n"

which space > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    printf "\033[32m[OK] Test space command is not available\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space command to be unavailable\033[0m\n"
    exit 1
fi

# Also check for generated man page. Not really generated man but dummy from manuals/space.md
cp manuals/space.md space.1
_RUN_CHECK_OK "Test space install: no parameters" "\[OK\]    SPACE_INSTALL_BIN:" space /install/

which space > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
    printf "\033[32m[OK] Test space command is available\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space command to be available\033[0m\n"
    exit 1
fi

_RUN_CHECK_OK "Test space -V" "Space " space -V

_RUN_CHECK_OK "Test Space install: overwrite existing install" "Replacing current installed version" space /install/
_RUN_CHECK_OK "Test space -V: repeating test" "Space " space -V

# Test installer script
_RUN_CHECK_OK "Test install.sh" "Space " ./tools/installer/install.sh

# Pass no args but set PREFIX first
export PREFIX=$(pwd)
_RUN_CHECK_OK "Test space install: PREFIX set" "\[OK\]    SPACE_INSTALL_BIN:" space /install/
_RUN_CHECK_OK "Test space -V: PREFIX" "Space " ./bin/space -V
if [ -f "$(pwd)"/share/man/man1/space.1 ]; then
    printf "\033[32m[OK] Test space man is installed: PREFIX\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space completion file to be present: PREFIX\033[0m\n"
    exit 1
fi

# Pass binprefix only - to local dir relative.
_RUN_CHECK_OK "Test space install: BIN_DEST set to relative path" "\[OK\]    SPACE_INSTALL_BIN:" space /install/ -- ./relativedir
_RUN_CHECK_OK "Test space -V: relative path" "Space " ./relativedir/bin/space -V
if [ -f "$(pwd)"/relativedir/share/man/man1/space.1 ]; then
    printf "\033[32m[OK] Test space man is installed: relative path\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space completion file to be present: relative path\033[0m\n"
    exit 1
fi

# Pass binprefix only - to local dir absolute
_RUN_CHECK_OK "Test space install: BIN_DEST set to absolute path" "\[OK\]    SPACE_INSTALL_BIN:" space /install/ -- "$(pwd)"/absolutedir
_RUN_CHECK_OK "Test space -V: absolute path" "Space " ./absolutedir/bin/space -V
if [ -f "$(pwd)"/absolutedir/share/man/man1/space.1 ]; then
    printf "\033[32m[OK] Test space man is installed: absolute path\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space completion file to be present: absolute path\033[0m\n"
    exit 1
fi

# Pass binprefix + acprefix
_RUN_CHECK_OK "Test space install: BIN_DEST and AC_DEST set" "\[OK\]    SPACE_INSTALL_BIN:" space /install/ -- "$(pwd)"/customdir "$(pwd)"/customdir
_RUN_CHECK_OK "Test space -V: BIN and AC set" "Space " ./absolutedir/bin/space -V
if [ -f "$(pwd)"/customdir/space ]; then
    printf "\033[32m[OK] Test space completion is installed: BIN and AC set\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space completion file to be present: BIN and AC set\033[0m\n"
    exit 1
fi
if [ -f "$(pwd)"/customdir/share/man/man1/space.1 ]; then
    printf "\033[32m[OK] Test space man is installed: BIN and AC set\033[0m\n"
else
    printf "\033[31m[ERROR] Expected space completion file to be present: BIN and AC set\033[0m\n"
    exit 1
fi

# Check uninstall
_RUN_CHECK_OK "Test space uninstall" "In order to uninstall Space, remove the following files" space /uninstall/
# TODO: FIXME: grep output files and test if they exist
#

