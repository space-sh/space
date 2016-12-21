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
# Check for Lua libraries
#
set -o nounset

if command -v "lua5.1" >/dev/null 2>&1 ; then
    for _lib_name in "lyaml" "base64" "cjson" "posix"; do
        if ! "lua5.1" -e "require '${_lib_name}'" 2>/dev/null ; then
            printf "FAIL: could not find library %s\n" "$_lib_name" 1>&2
            exit 1
        else
            printf "OK: %s\n" "$_lib_name"
        fi
    done
else
    printf "FAIL: missing lua5.1 program\n" 1>&2
    exit 1
fi

