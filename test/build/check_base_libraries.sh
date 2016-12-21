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
# Check for base system libraries
#
set -o nounset

_check_library()
{
    local _lib_name=$1
    local _output=

    for _ext in ".a" ".so" ".so.*"; do
        _output=$(find /usr/lib -name "${_lib_name}${_ext}" -print)
        if [ -n "$_output" ]; then
            return 0
        fi

        _output=$(find /usr/local/lib -name "${_lib_name}${_ext}" -print)
        if [ -n "$_output" ]; then
            return 0
        fi
    done

    printf "FAIL: could not find library %s\n" "$_lib_name" 1>&2
    exit 1
}

_YAML_LIB_NAME="libyaml"
_check_library "$_YAML_LIB_NAME"
printf "OK: %s\n" "$_YAML_LIB_NAME"

