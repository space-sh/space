#!/usr/bin/env sh
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

#
# Check for base system binaries
#
set -o nounset


#=========================
# _check_version
#
# Checks current major.minor version is equal or bigger than
# required major.minor
#
# Parameters:
#   1: program name for message output
#   2: required major version number
#   3: required minor version number
#   4: current major version number
#   5: current minor version number
#
#=========================
_check_version()
{
    local _program_name=$1
    local _required_major=$2
    local _required_minor=$3
    local _current_major=$4
    local _current_minor=$5
    if [ "$_current_major" -lt "$_required_major" ] \
      || ( [ "$_current_major" -le "$_required_major" ] && [ "$_current_minor" -lt "$_required_minor" ]); then
        printf "FAIL: %s version is too old. Version %s.%s or later is required. Current version: %s.%s\n" \
               "$_program_name" "$_required_major" "$_required_minor" "$_current_major" "$_current_minor" 1>&2
        exit 1
    fi
}

#
# bash
if ! command -v bash >/dev/null; then
    printf "Missing bash program\n" 1>&2
    exit 1
else
    _BASH_REQUIRED_MAJOR="3"
    _BASH_REQUIRED_MINOR="2"
    _BASH_CURRENT_MAJOR="${BASH_VERSINFO[0]}"
    _BASH_CURRENT_MINOR="${BASH_VERSINFO[1]}"
    _check_version "bash" "$_BASH_REQUIRED_MAJOR" "$_BASH_REQUIRED_MINOR" "$_BASH_CURRENT_MAJOR" "$_BASH_CURRENT_MINOR"
    printf "OK: bash %s.%s\n" "$_BASH_CURRENT_MAJOR" "$_BASH_CURRENT_MINOR"
fi

#
# base64
if ! command -v base64 >/dev/null; then
    printf "Missing base64 program\n" 1>&2
    exit 1
else
    printf "OK: base64\n"
fi

#
# curl
if ! command -v curl >/dev/null; then
    printf "Missing curl program\n" 1>&2
    exit 1
else
    _CURL_REQUIRED_MAJOR="7"
    _CURL_REQUIRED_MINOR="51"
    _CURL_VERSION=$(curl --version | grep curl | cut -d ' ' -f2)
    _CURL_CURRENT_MAJOR="$(printf $_CURL_VERSION | cut -d. -f1)"
    _CURL_CURRENT_MINOR="$(printf $_CURL_VERSION | cut -d. -f2)"
    _check_version "Curl" "$_CURL_REQUIRED_MAJOR" "$_CURL_REQUIRED_MINOR" "$_CURL_CURRENT_MAJOR" "$_CURL_CURRENT_MINOR"
    printf "OK: curl %s.%s\n" "$_CURL_CURRENT_MAJOR" "$_CURL_CURRENT_MINOR"
fi

#
# git
if ! command -v git >/dev/null; then
    printf "Missing git program\n" 1>&2
    exit 1
else
    _GIT_REQUIRED_MAJOR="2"
    _GIT_REQUIRED_MINOR="8"
    _GIT_VERSION=$(git --version | cut -d ' ' -f3)
    _GIT_CURRENT_MAJOR="$(printf $_GIT_VERSION | cut -d. -f1)"
    _GIT_CURRENT_MINOR="$(printf $_GIT_VERSION | cut -d. -f2)"
    _check_version "Git" "$_GIT_REQUIRED_MAJOR" "$_GIT_REQUIRED_MINOR" "$_GIT_CURRENT_MAJOR" "$_GIT_CURRENT_MINOR"
    printf "OK: git %s.%s\n" "$_GIT_CURRENT_MAJOR" "$_GIT_CURRENT_MINOR"
fi

#
# space
if ! command -v space >/dev/null; then
    printf "Missing space program\n" 1>&2
    exit 1
else
    _SPACE_REQUIRED_MAJOR="0"
    _SPACE_REQUIRED_MINOR="10"
    _SPACE_VERSION=$(space -V 2>&1 | cut -d ' ' -f2)
    _SPACE_CURRENT_MAJOR="$(printf $_SPACE_VERSION | cut -d. -f1)"
    _SPACE_CURRENT_MINOR="$(printf $_SPACE_VERSION | cut -d. -f2)"
    _check_version "Space" "$_SPACE_REQUIRED_MAJOR" "$_SPACE_REQUIRED_MINOR" "$_SPACE_CURRENT_MAJOR" "$_SPACE_CURRENT_MINOR"
    printf "OK: space %s.%s\n" "$_SPACE_CURRENT_MAJOR" "$_SPACE_CURRENT_MINOR"
fi

