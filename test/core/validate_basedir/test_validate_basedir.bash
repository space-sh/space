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

_VALIDATE_BASEDIR()
{
    SPACE_CMDDEP="PRINT"
    SPACE_CMDENV="_BASEDIR"

    # Check if BASEDIR path is valid
    if [[ "${_BASEDIR}" =~ ^\/.*$ ]]; then
        PRINT "_BASEDIR test OK!" "success"
        return 0
    else
        PRINT "_BASEDIR value=[${_BASEDIR}] doesn't match expected format" "error"
        return 1
    fi

}

