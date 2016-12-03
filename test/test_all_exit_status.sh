#!/usr/bin/env bash
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

#======================
# Test switches
#
# Checks that all front-facing user operations
# and interactions are returning known exit codes.
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
# _RUN_CHECK_OK and FAIL
#
# Wraps a Space command line call for testing
#
# Note:
#   Avoiding command substitution and subshelling while still 
#   providing full command call via parameters.
#   Makes it so that the test toolset can keep track of function calls.
#
#======================
_RUN_CHECK_OK()
{
    local _status=
    bash "$@" > /dev/null 2>&1
    _status="$?"
    if [ "$_status" -eq 0 ]; then
        printf "\033[32m[OK] %s\033[0m\n" "$*"
    else
        printf "\033[31m[ERROR] %s. Expected it to succeed\033[0m\n" "$*"
        exit 1
    fi
}

_RUN_CHECK_FAIL()
{
    local _status=
    bash "$@" > /dev/null 2>&1
    _status="$?"
    if [ "$_status" -eq 0 ]; then
        printf "\033[31m[ERROR] %s. Expected it to fail\033[0m\n" "$*"
        exit 1
    else
        printf "\033[32m[OK] %s\033[0m\n" "$*"
    fi
}

# Invalid space calls
_RUN_CHECK_FAIL space
_RUN_CHECK_FAIL $_SPACE_BIN -
_RUN_CHECK_FAIL $_SPACE_BIN -6
_RUN_CHECK_FAIL $_SPACE_BIN -Z
_RUN_CHECK_FAIL $_SPACE_BIN -X6
_RUN_CHECK_FAIL $_SPACE_BIN -- something1 otherthing2

# Regular environment variable
_RUN_CHECK_OK   $_SPACE_BIN -e dummyenv=mukyanjong    / -h
# Malformed environment variable settings
_RUN_CHECK_FAIL $_SPACE_BIN -e malformedEnv           / -h

# Valid preprocessing variables
_RUN_CHECK_OK $_SPACE_BIN -p var1=ready   / -h
_RUN_CHECK_OK $_SPACE_BIN -p var1+=again  / -h

# All verbosity levels
_RUN_CHECK_OK   $_SPACE_BIN   / -h -v0
_RUN_CHECK_OK   $_SPACE_BIN   / -h -v1
_RUN_CHECK_OK   $_SPACE_BIN   / -h -v2
_RUN_CHECK_OK   $_SPACE_BIN   / -h -v3
_RUN_CHECK_OK   $_SPACE_BIN   / -h -v4
_RUN_CHECK_FAIL $_SPACE_BIN   / -h -v6

# All caching modes
_RUN_CHECK_OK   $_SPACE_BIN -C1   / -h
_RUN_CHECK_OK   $_SPACE_BIN -C2   / -h
_RUN_CHECK_FAIL $_SPACE_BIN -C3   / -h

# List mode
_RUN_CHECK_OK $_SPACE_BIN /install/ -l

# Bash mode
_RUN_CHECK_OK $_SPACE_BIN -B /install/ -h

# Dry run
_RUN_CHECK_OK $_SPACE_BIN /install/ -d

# Bash Completion expected to return 1
_RUN_CHECK_FAIL $_SPACE_BIN -1
_RUN_CHECK_FAIL $_SPACE_BIN -1 /install/
_RUN_CHECK_FAIL $_SPACE_BIN -2

# Help
_RUN_CHECK_OK $_SPACE_BIN -h

# helpversion
_RUN_CHECK_OK $_SPACE_BIN -V

# helpnode
_RUN_CHECK_OK   $_SPACE_BIN / -h
_RUN_CHECK_OK   $_SPACE_BIN /install/ -h
_RUN_CHECK_OK   $_SPACE_BIN -f ./test/yaml/test.yaml /tests/ -h
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/yaml/test.yaml wrongnode -h
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/yaml/test.yaml /tests/wrongpath -h

# prompt during preprocessing
echo "input" | _RUN_CHECK_OK $_SPACE_BIN -C0 -f test/exit_status_cases/prompt.yaml /print_input/

# Misc base cases
_RUN_CHECK_OK $_SPACE_BIN -C0 -f ./test/exit_status_cases/test.yaml / -h
_RUN_CHECK_OK $_SPACE_BIN -C0 -f ./test/exit_status_cases/test.yaml /print_test/

# Fail cloning repo
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_clone.yaml / -h

# Fail include during preprocessing
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_include_file.yaml / -h
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_include_module.yaml / -h
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_include_file_on_included.yaml / -h

# Malformed clone import name
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_clone_malformed.yaml / -h

# Fail assert during preprocessing
_RUN_CHECK_FAIL $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_assert.yaml / -h

#
# Fail cloning module repository
_RUN_CHECK_FAIL $_SPACE_BIN -m ssh://gitlab.com/space-sh/non-existent-repo/ / -h
_RUN_CHECK_FAIL $_SPACE_BIN -m ssh://username@gitlab.com/space-sh/non-existent-repo/ / -h
# Bad commit
_RUN_CHECK_FAIL $_SPACE_BIN -m username/os:badversion3 / -h


#
# Modules
#
# Security check TODO: FIXME: point to trusted module
#_RUN_CHECK_OK $_SPACE_BIN -C0 -k2 -m os / -h
_RUN_CHECK_OK   $_SPACE_BIN   / -h -k0
_RUN_CHECK_OK   $_SPACE_BIN   / -h -k1
_RUN_CHECK_OK   $_SPACE_BIN   / -h -k2
_RUN_CHECK_FAIL $_SPACE_BIN   / -h -k3
_RUN_CHECK_FAIL $_SPACE_BIN   / -h -k6

# # Signature check
_RUN_CHECK_OK   $_SPACE_BIN   / -h -K0
_RUN_CHECK_OK   $_SPACE_BIN   / -h -K1
# TODO: FIXME: not available
#_RUN_CHECK_OK   $_SPACE_BIN   / -h -K2
#_RUN_CHECK_FAIL $_SPACE_BIN -C0 -K2 -S -m os / -h
_RUN_CHECK_FAIL $_SPACE_BIN   / -h -K3
_RUN_CHECK_FAIL $_SPACE_BIN   / -h -K6
# Clone and load, adding a dummy CMDOVERRIDE
_RUN_CHECK_OK $_SPACE_BIN -M os -c "# dummy command" / -h
# Completion returns 1
_RUN_CHECK_FAIL $_SPACE_BIN -3 -m os / -h
# Multi
_RUN_CHECK_OK $_SPACE_BIN -C0 -m sshd -m os -m file / -h
# Cached
_RUN_CHECK_OK $_SPACE_BIN -m sshd -m os -m file / -h
# Bad cache
_RUN_CHECK_FAIL $_SPACE_BIN -C6 -m sshd -m os -m file / -h
# Too many namespaces
_RUN_CHECK_FAIL $_SPACE_BIN -C0 -m os1 -m os2 -m os3 -m os4
_RUN_CHECK_FAIL $_SPACE_BIN -C0 -f Spacefile.yaml -f Spacefile.yaml -f Spacefile.yaml -f Spacefile.yaml

# TODO: FIXME: 
# Disabled until fix returning non-zero on some platforms
# Update one module
#_RUN_CHECK_OK $_SPACE_BIN -U "os"

# No dimensions
_RUN_CHECK_FAIL $_SPACE_BIN -a

# Too many dimensions
_RUN_CHECK_FAIL $_SPACE_BIN /a/ /b/ /c/ /d/

#
# YAML
_RUN_CHECK_OK $_SPACE_BIN -f ./test/yaml/test.yaml /tests/0/ -a

