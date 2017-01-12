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

_TEST_HELPNODE_EMPTY_STRING_PARAMETER()
{
    SPACE_CMDDEP="PRINT _helpnode _print _copy _list"
    SPACE_CMDENV="_YAML_PREFIX _YAML_NAMESPACE"

    local _tmp_file_name="./tmp_test_helpnode"

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

    #
    # Mock intricate dependency
    _list()
    {
        local _output=$1
        local _nodes=()
        _nodes+=("Predefined_node1")
        _nodes+=("preDefined_NODE2")
        eval "${_output}=(\"\${_nodes[@]}\")"
    }

    _helpnode "" >> "$_tmp_file_name" 2>&1

    # Check if file size is >0
    if [ ! -s "$_tmp_file_name" ]; then
        PRINT "_helpnode FAILED!" "error"

        # Remove tmp file
        rm "$_tmp_file_name"
        return 1
    else
        # Check if file contents match the expected string
        local _expected_string=
        _expected_string=$(printf "\n\t\n\n+ Predefined_node1\n+ preDefined_NODE2")

        PRINT "Looking for expected results..."
        PRINT "Testing: $(cat ${_tmp_file_name})"
        PRINT "Expected: $_expected_string"
        if [ "$(cat ${_tmp_file_name})" = "$_expected_string" ]; then
            PRINT "_helpnode OK!" "ok"
            # remove tmp file
            rm "$_tmp_file_name"
            return 0
        else
            PRINT "_helpnode failed!" "error"
            # remove tmp file
            rm "$_tmp_file_name"
            return 2
        fi
    fi

    PRINT "_helpnode OK!" "ok"
}

_TEST_HELPNODE_WITH_PARAMETER()
{
    SPACE_CMDDEP="PRINT _helpnode _print _copy _list"
    SPACE_CMDENV="_YAML_PREFIX _YAML_NAMESPACE"

    local _tmp_file_name="./tmp_test_helpnode"

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

    #
    # Mock intricate dependency
    _list()
    {
        local _output=$1
        local _nodes=()
        _nodes+=("Predefined_node1")
        _nodes+=("preDefined_NODE2")
        eval "${_output}=(\"\${_nodes[@]}\")"
    }

    _helpnode "/test123/" >> "$_tmp_file_name" 2>&1

    # Check if file size is >0
    if [ ! -s "$_tmp_file_name" ]; then
        PRINT "_helpnode FAILED!" "error"

        # Remove tmp file
        rm "$_tmp_file_name"
        return 1
    else
        # Check if file contents match the expected string
        local _expected_string=
        _expected_string=$(printf "/test123/\n\t\n\n+ Predefined_node1\n+ preDefined_NODE2")

        PRINT "Looking for expected results..."
        PRINT "Testing: $(cat ${_tmp_file_name})"
        PRINT "Expected: $_expected_string"
        if [ "$(cat ${_tmp_file_name})" = "$_expected_string" ]; then
            PRINT "_helpnode OK!" "ok"
            # remove tmp file
            rm "$_tmp_file_name"
            return 0
        else
            PRINT "_helpnode failed!" "error"
            # remove tmp file
            rm "$_tmp_file_name"
            return 2
        fi
    fi

    PRINT "_helpnode OK!" "ok"
}

