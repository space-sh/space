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

_TEST_QUICKSORT()
{
    SPACE_DEP="PRINT _quicksort _sort_pad"
    SPACE_ENV="_ALLOW_EXTERNAL"

    _ALLOW_EXTERNAL=0

    local _unsorted_array=("654" "2" "200000" "z" "c" "d" "y" "e" "zxczxcwqewqee" "dsijewr" "_ae" "_yo_namespace" "no_marrianne" "sq3" "paleo_chicken" "mc_R4men")
    local _sorted_array=("2" "654" "200000" "_ae" "_yo_namespace" "c" "d" "dsijewr" "e" "mc_R4men" "no_marrianne" "paleo_chicken" "sq3" "y" "z" "zxczxcwqewqee")
    local _quicksort_output=()

    # Store current locale settings
    local _unset_locale_flag=0
    local _stored_locale=
    if [ -z "${LC_ALL+unset}" ]; then
        _unset_locale_flag=1
    else
        _stored_locale="${LC_ALL}"
    fi
    # Set locale to get traditional sort order (bytes comparison)
    export LC_ALL="C"

    _quicksort "${_unsorted_array[@]}"

    # Restore locale settings to their original state
    if [ "${_unset_locale_flag}" -eq "1" ]; then
        unset LC_ALL
    else
        LC_ALL="${_stored_locale}"
    fi

    if [[ "${_quicksort_output[*]}" == "${_sorted_array[*]}" ]]; then
        PRINT "_quicksort OK!" "ok"
        return 0
    else
        PRINT "_quicksort failed!" "error"
        return 1
    fi
}

