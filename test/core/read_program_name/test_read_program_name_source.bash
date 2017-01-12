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

_READ_PROGRAM_NAME_SOURCE()
{
    _BIN_NAME=$(basename "$1")
    shift || :

    # Check if bin name matches expected value
    if [ "${_BIN_NAME}" = "space" ]; then
        _BASE_PATH="$( cd "${_SPACEBIN%/*}" 2>/dev/null ; pwd )"
        PRINT "Base path = ${_BASE_PATH}"
        PRINT "_SPACEBIN test OK!" "ok"
        return 0
    else
        PRINT "_SPACEBIN value=[${_BIN_NAME}] doesn't match expected value [space]" "error"
        return 1
    fi
}

