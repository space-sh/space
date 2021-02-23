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
# Test switches
#
# Checks that all front-facing user operations
# and interactions are returning known exit codes.
#
#======================

set -o nounset

#
# -S: Pass custom parameter for Space in case Git is not available
_SPACE_BIN="space"
if ! command -v git >/dev/null; then
    _SPACE_BIN="space -S"
    printf "\033[35mGit command is not available. Signaling Space with -S switch.\033[0m\n"
else
    printf "\033[35mGit command is available.\033[0m\n"
fi

#
# Test counter
_test_counter=0
_test_counter_ok=0

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

    _test_counter=$((_test_counter + 1 ))
    _output=$(bash $_command_line 2>&1)
    _status="$?"
    if [ "$_status" -eq 0 ]; then
        _CHECK_CONTAINS "$_expected_message" "$_output"
        if [ "$?" -eq 1 ]; then
            printf "\033[32m[OK] %s\033[0m\n" "$_message_description"
            if [ "$_test_counter_ok" -lt 255 ]; then
                _test_counter_ok=$((_test_counter_ok + 1 ))
            fi
        else
            printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tExpected output to contain: \"%s\"\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_expected_message" "$_output"
        fi
    else
        printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tFailed with exit status (%s)\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_status" "$_output"
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

    _test_counter=$((_test_counter + 1 ))
    _output=$(bash $_command_line 2>&1)
    _status="$?"
    if [ "$_status" -eq 0 ]; then
        printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tFailed with exit status (%s)\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_status" "$_output"
    else
        _CHECK_CONTAINS "$_expected_message" "$_output"
        if [ "$?" -eq 1 ]; then
            printf "\033[32m[OK] %s\033[0m\n" "$_message_description"
            if [ "$_test_counter_ok" -lt 255 ]; then
                _test_counter_ok=$((_test_counter_ok + 1 ))
            fi
        else
            printf "\033[31m[ERROR] %s\n\tCommand: \"%s\"\n\tExpected output to contain: \"%s\"\n\tOutput: \"%s\"\033[0m\n" "$_message_description" "$_command_line" "$_expected_message" "$_output"
        fi
    fi
}

printf "\033[35mTesting Space parameter options...\033[0m\n"

# Invalid Space calls
_RUN_CHECK_FAIL "Test without parameters" "" $_SPACE_BIN
_RUN_CHECK_FAIL "Test without parameters but arguments" "" $_SPACE_BIN -- something1 otherthing2
_RUN_CHECK_FAIL "Test unknown option: dash only" "Unknown option -" $_SPACE_BIN -
_RUN_CHECK_FAIL "Test unknown option: dash and number" "Unknown option -9" $_SPACE_BIN -9
_RUN_CHECK_FAIL "Test unknown option: dash and unknown letter" "Unknown option -Y" $_SPACE_BIN -Y
_RUN_CHECK_FAIL "Test unknown option: dash, known letter, invalid parameter" "Unknown -X argument 6" $_SPACE_BIN -X6
_RUN_CHECK_FAIL "Test invalid node name" "must begin and end with slash" $_SPACE_BIN badNodeName

# -f
_RUN_CHECK_FAIL "Test -f switch: file does not exit" "YAML file UnknownFile.yaml does not exist" $_SPACE_BIN -f UnknownFile.yaml / -h

#
# -m
# Implicit protocol name
_RUN_CHECK_FAIL "Test -m switch: URL missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m github.com/space-sh
_RUN_CHECK_FAIL "Test -m switch: IP missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m 192.168.0.1/username
_RUN_CHECK_FAIL "Test -m switch: hostname missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m host/username
_RUN_CHECK_FAIL "Test -m switch: hostname with slash missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m host/username/
# Explicit protocol name
_RUN_CHECK_FAIL "Test -m switch: Explicit protocol URL missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m ssh://host.com
_RUN_CHECK_FAIL "Test -m switch: Explicit protocol IP missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m ssh://192.168.0.1
_RUN_CHECK_FAIL "Test -m switch: Explicit protocol hostname missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m ssh://host/username
_RUN_CHECK_FAIL "Test -m switch: Explicit protocol hostname with slash missing repo/user combo" "Expected username and reponame" $_SPACE_BIN -m ssh://host/username/
# Missing domain name extension
_RUN_CHECK_FAIL "Test -m switch: Implicit protocol, missing domain name extension" "Expected domain extension" $_SPACE_BIN -m host./user/repo / -h 
_RUN_CHECK_FAIL "Test -m switch: Explicit protocol HTTPS, missing domain name extension" "Expected domain extension" $_SPACE_BIN -m https://host./user/repo / -h 
_RUN_CHECK_FAIL "Test -m switch: Explicit protocol SSH, missing domain name extension" "Expected domain extension" $_SPACE_BIN -m ssh://host./user/repo / -h 

# -h: Help
_RUN_CHECK_OK   "Test -h switch: contains basic program info" "Space. (C) Blockie AB 2016-2021, blockie.org. GPL version 3 licensed." $_SPACE_BIN -h
_RUN_CHECK_OK   "Test -h switch: contains usage section" "Usage:" $_SPACE_BIN -h

# -e: Regular environment variable
_RUN_CHECK_FAIL "Test -e switch: key=value" "The node / has no RUN defined" $_SPACE_BIN -e dummyenv=mukyanjong
_RUN_CHECK_FAIL "Test -e switch: malformed pair" "Malformed -e switch" $_SPACE_BIN -e malformedEnv
# Check duplicates
_test_counter=$((_test_counter + 1 ))
_duplicates_count="$(bash ${_SPACE_BIN} -f ./test/Spacefile.yaml /run/ -e SPACE_ENV="a=1 a=2" -d -C0 | grep -c "a\=")"
if [ "${_duplicates_count}" -ne 1 ]; then
    printf "\033[31m[ERROR] \n\tCommand: \"SPACE_ENV\"\n\tExpected output to contain: \"grep count of a\= equal to 1\"\033[0m\n"
else
    if [ "$_test_counter_ok" -lt 255 ]; then
        _test_counter_ok=$((_test_counter_ok + 1 ))
    fi
fi

# -p: Valid preprocessing variables
_RUN_CHECK_OK "Test -p switch: attribution" ""      $_SPACE_BIN -p var1=ready   / -h
_RUN_CHECK_OK "Test -p switch: += attribution" ""   $_SPACE_BIN -p var1+=again  / -h

# -v: All verbosity levels
_RUN_CHECK_OK   "Test -v0 switch" "" $_SPACE_BIN   / -h -v0
_RUN_CHECK_OK   "Test -v1 switch" "" $_SPACE_BIN   / -h -v1
_RUN_CHECK_OK   "Test -v2 switch" "" $_SPACE_BIN   / -h -v2
_RUN_CHECK_OK   "Test -v3 switch" "" $_SPACE_BIN   / -h -v3
_RUN_CHECK_OK   "Test -v4 switch" "Namespaces loaded" $_SPACE_BIN   / -h -v4
_RUN_CHECK_FAIL "Test -v6: invalid switch" "Unknown -v argument 6" $_SPACE_BIN   / -h -v6

# -C: All caching modes
_RUN_CHECK_OK   "Test -C0 switch" "Deleting cache" $_SPACE_BIN -C0   / -h -v4
_RUN_CHECK_OK   "Test -C1 switch" "Cache file not found" $_SPACE_BIN -C1   / -h -v4
_RUN_CHECK_OK   "Test -C2 switch" "Write to cache file" $_SPACE_BIN -C2   / -h -v4
_RUN_CHECK_FAIL "Test -C3: invalid switch" "Unknown -C argument 3" $_SPACE_BIN -C3   / -h -v4

# -l: List mode
_RUN_CHECK_OK "Test -l switch" "/install/" $_SPACE_BIN /install/ -l

# -d: Dry run
_RUN_CHECK_OK "Test -d switch" "# Script assembled and exported by:" $_SPACE_BIN /install/ -d
_RUN_CHECK_OK "Test -d switch: shell mode" "#!/usr/bin/env sh" $_SPACE_BIN /install/ -d

# -B: Bash mode
_RUN_CHECK_OK "Test -d switch: bash mode" "#!/usr/bin/env bash" $_SPACE_BIN /install/ -d -B

# Bash Completion expected to return 1
_RUN_CHECK_FAIL "Test -1 switch: tab completion" "" $_SPACE_BIN -1
_RUN_CHECK_FAIL "Test -1 switch with args" "" $_SPACE_BIN -1 /install/
_RUN_CHECK_FAIL "Test -2 switch" "" $_SPACE_BIN -2

_RUN_CHECK_OK "Test -h switch" "" $_SPACE_BIN -h

# -V: helpversion
_RUN_CHECK_OK "Test -V switch" "Space " $_SPACE_BIN -V

# -h: helpnode
_RUN_CHECK_OK   "Test -h switch: root node" "Space.sh installer" $_SPACE_BIN / -h
_RUN_CHECK_OK   "Test -h switch: child node" "Install Space.sh" $_SPACE_BIN /install/ -h
_RUN_CHECK_OK   "Test -h switch: specifying file" "+ 0" $_SPACE_BIN -f ./test/yaml/test.yaml /tests/ -h
_RUN_CHECK_FAIL "Test -h switch: specifying file with incorrect node" "must begin and end with slash" $_SPACE_BIN -f ./test/yaml/test.yaml wrongnode -h
_RUN_CHECK_FAIL "Test -h switch: specifying file with incorrect path" "Malformed node path" $_SPACE_BIN -f ./test/yaml/test.yaml /tests/wrongpath -h

# prompt during preprocessing
echo "input" | _RUN_CHECK_FAIL "Test @prompt" "" $_SPACE_BIN -C0 -f test/exit_status_cases/prompt.yaml /print_input/

# Misc base cases
_RUN_CHECK_OK "Test misc base cases: root node" "+ print_test" $_SPACE_BIN -C0 -f ./test/exit_status_cases/test.yaml / -h
#_RUN_CHECK_OK "Test misc base cases: print_test node" "" $_SPACE_BIN -C0 -f ./test/exit_status_cases/test.yaml /print_test/

# Fail cloning repo
_RUN_CHECK_FAIL "Test @clone" "Could not clone module repository" $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_clone.yaml / -h

# Fail include during preprocessing
_RUN_CHECK_FAIL "Test preprocessor include file" "Could not find file \"NonExistentFile.yaml\"." $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_include_file.yaml / -h
_RUN_CHECK_FAIL "Test preprocessor include module" "Could not find file \"username/module\"." $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_include_module.yaml / -h
_RUN_CHECK_FAIL "Test preprocessor include on include file" "Could not find file \"fail_pp_file_include.yaml\"." $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_include_file_on_included.yaml / -h

# Malformed clone import name
if command -v git >/dev/null; then
    _RUN_CHECK_FAIL "Test malformed clone import" "Could not clone" $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_clone_malformed.yaml / -h
else
    _RUN_CHECK_FAIL "Test malformed clone import" "Could not clone module repository" $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_clone_malformed.yaml / -h
fi

# Fail assert during preprocessing
_RUN_CHECK_FAIL "Test @assert" "Assertion failed: nonempty" $_SPACE_BIN -f ./test/exit_status_cases/fail_pp_assert.yaml / -h

#
# Fail cloning module repository
if command -v git >/dev/null; then
    _RUN_CHECK_FAIL "Test @clone" "Could not clone" $_SPACE_BIN -m ssh://github.com/space-sh/non-existent-repo/ / -h
    _RUN_CHECK_FAIL "Test @clone" "Could not clone" $_SPACE_BIN -m ssh://username@github.com/space-sh/non-existent-repo/ / -h
else
    _RUN_CHECK_FAIL "Test @clone" "Could not clone module repository" $_SPACE_BIN -m ssh://github.com/space-sh/non-existent-repo/ / -h
    _RUN_CHECK_FAIL "Test @clone" "Could not clone module repository" $_SPACE_BIN -m ssh://username@github.com/space-sh/non-existent-repo/ / -h
fi

_RUN_CHECK_FAIL "Test module: bad commit" "Expected username and reponame" $_SPACE_BIN -m username/os:badversion3 / -h

#
# Modules
#
# -K: Signature check
_RUN_CHECK_OK   "Test -K switch" "" $_SPACE_BIN   / -h -K
# TODO: FIXME: not available
#_RUN_CHECK_OK   $_SPACE_BIN   / -h -K2
#_RUN_CHECK_FAIL $_SPACE_BIN -C0 -K2 -S -m os / -h
_RUN_CHECK_FAIL "Test -K3 switch: unknown" "Unknown option -K3" $_SPACE_BIN   / -h -K3

# Completion returns 1
_RUN_CHECK_FAIL "Test -3 switch: completion" "" $_SPACE_BIN -3 -m os / -h
# Multi modules
_RUN_CHECK_OK "Test multi module: loading" "" $_SPACE_BIN -C0 -m sshd -m os -m file / -h
# Multi modules Cached
_RUN_CHECK_OK "Test multi module: cached" "" $_SPACE_BIN -m sshd -m os -m file / -h
# Multi modules Bad cache
_RUN_CHECK_FAIL "Test multi module: bad cache" "" $_SPACE_BIN -C6 -m sshd -m os -m file / -h
# Multi -f/-m: Too many namespaces
_RUN_CHECK_FAIL "Test multi module: too many namespaces" "Too many namespaces defined" $_SPACE_BIN -C0 -m os1 -m os2 -m os3 -m os4
_RUN_CHECK_FAIL "Test multi module files: too many namespaces" "Too many namespaces defined" $_SPACE_BIN -C0 -f Spacefile.yaml -f Spacefile.yaml -f Spacefile.yaml -f Spacefile.yaml

# -U: Update one module
if command -v git >/dev/null; then
    _RUN_CHECK_OK "Test -U switch: updating" "Updating space modules to pattern: ./github.com/space-sh/os" $_SPACE_BIN -U "os"
    _RUN_CHECK_OK "Test -U switch: updating" "Updating space modules to pattern: ./github.com/space-sh/os" $_SPACE_BIN -U "github.com/space-sh/os"
fi

# -a: No dimensions
_RUN_CHECK_FAIL "Test -a switch: missing node" "-a flag must come after node." $_SPACE_BIN -a

# Too many dimensions
_RUN_CHECK_FAIL "Test dimensions: too many arguments" "cannot exceed three in total" $_SPACE_BIN /a/ /b/ /c/ /d/

#
# Summary
printf "\n===================\n"
if [ "$_test_counter_ok" -eq "$_test_counter" ]; then
    printf "\033[32mOK!\033[0m Completed %s out of %s tests.\n" "$_test_counter_ok" "$_test_counter"
else
    printf "\033[31mFAIL!\033[0m Completed %s out of %s tests.\n" "$_test_counter_ok" "$_test_counter"
fi
printf "===================\n"

_exit_code=$((_test_counter - _test_counter_ok ))
exit $_exit_code

