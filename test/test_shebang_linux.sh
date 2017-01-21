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

./test/exit_status_cases/shebang_linux.sh -m docker /run_wrap/ -- 2
_status="$?"
if [ "${_status}" -ne 1 ]; then
    # TODO: catch stderr to check output is expected:
    # [INFO]  UTILS_WAITFORFILE: Wait for files timeouted after 2 seconds.
    echo "Wrong status returned: ${_status}, was expecting 1." >&2
fi
