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
# Check for Lua binaries
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
# lua
if ! command -v lua5.1 >/dev/null; then
    printf "Missing lua5.1 program\n" 1>&2
    exit 1
else
    _LUA_REQUIRED_MAJOR="5"
    _LUA_REQUIRED_MINOR="1"
    _LUA_VERSION="$(lua5.1 -v 2>&1 | cut -d ' ' -f2)"
    _LUA_CURRENT_MAJOR="$(printf $_LUA_VERSION | cut -d. -f1)"
    _LUA_CURRENT_MINOR="$(printf $_LUA_VERSION | cut -d. -f2)"
    _check_version "lua" "$_LUA_REQUIRED_MAJOR" "$_LUA_REQUIRED_MINOR" "$_LUA_CURRENT_MAJOR" "$_LUA_CURRENT_MINOR"
    printf "OK: lua %s.%s\n" "$_LUA_CURRENT_MAJOR" "$_LUA_CURRENT_MINOR"
fi

#
# luajit
if ! command -v luajit >/dev/null; then
    printf "Missing luajit program\n" 1>&2
    exit 1
else
    _LUAJIT_REQUIRED_MAJOR="2"
    _LUAJIT_REQUIRED_MINOR="0"
    _LUAJIT_VERSION="$(luajit -v | cut -d ' ' -f2)"
    _LUAJIT_CURRENT_MAJOR="$(printf $_LUAJIT_VERSION | cut -d. -f1)"
    _LUAJIT_CURRENT_MINOR="$(printf $_LUAJIT_VERSION | cut -d. -f2)"
    _check_version "luajit" "$_LUAJIT_REQUIRED_MAJOR" "$_LUAJIT_REQUIRED_MINOR" "$_LUAJIT_CURRENT_MAJOR" "$_LUAJIT_CURRENT_MINOR"
    printf "OK: luajit %s.%s\n" "$_LUAJIT_CURRENT_MAJOR" "$_LUAJIT_CURRENT_MINOR"
fi

