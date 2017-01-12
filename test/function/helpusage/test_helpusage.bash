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

_TEST_HELPUSAGE()
{
    SPACE_CMDDEP="PRINT _helpusage"
    SPACE_CMDENV="_USAGE"

    local _tmp_file_name="./tmp_test_helpusage"

    #
    # Create temporary file

    # Make sure it doesn't already exist
    if [ -f "$_tmp_file_name" ]; then
        PRINT "File $_tmp_file_name already exists. That was unexpected!" "error"
        return 1
    fi

    # Create
    touch "$_tmp_file_name"

    # Make sure it was indeed created
    if [ ! -f "$_tmp_file_name" ]; then
        PRINT "Failed to create temporary file needed for testing" "error"
        return 1
    fi

    PRINT "Calling _helpusage..."
    # Redirect stderr to file
    _helpusage 2> "$_tmp_file_name"
    PRINT "Checking if it generated any output..."

    # Check if file size is >0
    if [ ! -s "$_tmp_file_name" ]; then
        PRINT "_helpusage FAILED!" "error"

        # Remove tmp file
        rm "$_tmp_file_name"
        return 1
    else
        # Check if file contains some manually picked strings
        local _count1=$(grep -c "Blockie AB" "${_tmp_file_name}")
        local _count2=$(grep -c "Usage:" "${_tmp_file_name}")
        PRINT "Trying to look for predefined strings..."
        if [ "$_count1" -gt 0 ] && [ "$_count2" -gt 0 ]; then
            PRINT "_helpusage OK!" "ok"
            # remove tmp file
            rm "$_tmp_file_name"
            return 0
        else
            PRINT "_helpusage failed!" "error"
            # remove tmp file
            rm "$_tmp_file_name"
            return 2
        fi
    fi
}

