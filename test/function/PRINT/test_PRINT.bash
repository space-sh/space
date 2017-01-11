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

_TEST_PRINT()
{
    SPACE_CMDDEP="PRINT"

    PRINT_LEVEL=5

    local _tmp_file_name="./tmp_test_PRINT"

    local _level=$1
    local _level_tag=""

    if [ "$_level" = "error" ]; then
        _level_tag="\[ERROR\]"
    elif [ "$_level" = "security" ]; then
        _level_tag="\[SEC\]"
    elif [ "$_level" = "warning" ]; then
        _level_tag="\[WARN\]"
    elif [ "$_level" = "success" ]; then
        _level_tag="\[OK\]"
    elif [ "$_level" = "info" ]; then
        _level_tag="\[INFO\]"
    elif [ "$_level" = "debug" ]; then
        _level_tag="\[DEBUG\]"
    fi

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

    # Redirect expected output to file
    PRINT "testing 1, 2, 3 . . ." "$_level" 2> "$_tmp_file_name"

    # Check if file size is > 0
    if [ ! -s "$_tmp_file_name" ]; then
        PRINT "PRINT FAILED!" "error"

        # Remove tmp file
        rm "$_tmp_file_name"
        return 1
    else
        # Read first line of file
        local _print_line="0"
        read -r _print_line<"$_tmp_file_name"
        #PRINT "read=[$_print_line]"

        # Check pattern matches expected results
        PRINT "Trying to match results with expected print format..."
        local _extracted_tag=''
        if [[ "$_print_line" =~ (${_level_tag})(.*) ]]; then
            _extracted_tag=${BASH_REMATCH[1]}
        fi

        if [ "$_extracted_tag" = "${_level_tag//\\}" ]; then
            PRINT "PRINT $_level OK!" "success"
            # remove tmp file
            rm "$_tmp_file_name"
            return 0
        else
            PRINT "PRINT failed!" "error"
            # remove tmp file
            rm "$_tmp_file_name"
            return 2
        fi
    fi
}

_TEST_PRINT_LEVEL_ERROR()
{
    SPACE_CMDDEP="_TEST_PRINT"

    _TEST_PRINT "error"
}


_TEST_PRINT_LEVEL_SECURITY()
{
    SPACE_CMDDEP="_TEST_PRINT"

    _TEST_PRINT "security"
}

_TEST_PRINT_LEVEL_WARNING()
{
    SPACE_CMDDEP="_TEST_PRINT"

    _TEST_PRINT "warning"
}

_TEST_PRINT_LEVEL_SUCCESS()
{
    SPACE_CMDDEP="_TEST_PRINT"

    _TEST_PRINT "success"
}

_TEST_PRINT_LEVEL_INFO()
{
    SPACE_CMDDEP="_TEST_PRINT"

    _TEST_PRINT "info"
}
_TEST_PRINT_LEVEL_DEBUG()
{
    SPACE_CMDDEP="_TEST_PRINT"

    _TEST_PRINT "debug"
}

