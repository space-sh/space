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

_VALIDATE_VERSION()
{
    SPACE_CMDDEP="PRINT"
    SPACE_CMDENV="_VERSION"

    # Check if version string is valid
    if [[ "${_VERSION}" =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
        PRINT "_VERSION test OK!" "ok"
        return 0
    else
        PRINT "_VERSION value=[${_VERSION}] doesn't match expected format" "error"
        return 1
    fi

}

