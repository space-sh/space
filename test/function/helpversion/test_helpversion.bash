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

_TEST_HELPVERSION()
{
    SPACE_DEP="PRINT _helpversion"
    SPACE_ENV="_VERSION"

    local _tmp_file_name="./tmp_test_helpversion"

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

    PRINT "Calling _helpversion..."
    # Redirect expected stderr to file
    _helpversion 2> "$_tmp_file_name"
    PRINT "Checking if it generated any output..."

    # Check if file size is > 0
    if [ ! -s "$_tmp_file_name" ]; then
        PRINT "_helpversion FAILED!" "error"

        # Remove tmp file
        rm "$_tmp_file_name"
        return 1
    else
        # Read first line of file
        local _version="0"
        read -r _version<"$_tmp_file_name"
        PRINT "version=[$_version]"

        # Check version indeed matches a version pattern
        PRINT "Trying to match results with expected version format..."
        if [[ "$_version" =~ ^(Space )+[0-9]+\.[0-9]+\.[0-9] ]]; then
            PRINT "_helpversion OK!" "ok"
            # remove tmp file
            rm "$_tmp_file_name"
            return 0
        else
            PRINT "_helpversion failed!" "error"
            # remove tmp file
            rm "$_tmp_file_name"
            return 2
        fi
    fi
}

