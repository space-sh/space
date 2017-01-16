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

#=======================
# _CHECK_EXIT_STATUS
#
# Check for status code and increment a counter on error
#
# Parameters:
#   $1: the status code to check
#
# Expects:
#   _exit_status
#
#=======================
_CHECK_EXIT_STATUS()
{
    local _status_code="$1"

    if [ "$_status_code" -gt 0 ]; then
        PRINT "  Failed!" "error"

        # Update exit counter. Cap to 255 to prevent the value wrapping back
        if [ "$_exit_status" -lt 255 ]; then
            _exit_status=$((_exit_status + 1 ))
        fi
    else
        PRINT "  [OK!]" "ok"
    fi

}

_PARSE_YAML()
{
    # External
    SPACE_DEP="PRINT _CHECK_EXIT_STATUS"

    DIFF_BIN=diff

    if [ ! -d "./test" ] && [ ! -f "./space" ]; then
       PRINT "Tests must be performed from space root development directory" "error"
       return
    fi

    # Loop through all subdirs for testing
    local _exit_status=0
    for _dir_name in ./test/yaml/* ; do
        if [ -d "$_dir_name" ]; then
            PRINT "Performing test: \"$_dir_name\" *"

            PRINT "  X1: preprocess step"
            ./space -C0 -f ./"$_dir_name"/input.yaml -X1 | \
                $DIFF_BIN - ./"$_dir_name"/output_X1.yaml 
            _CHECK_EXIT_STATUS "$?"

            PRINT "  X2: parse step"
            ./space -C0 -f ./"$_dir_name"/input.yaml -X2 | \
                $DIFF_BIN - ./"$_dir_name"/output_X2.yaml
            _CHECK_EXIT_STATUS "$?"

            PRINT "  X3: transform step"
            ./space -C0 -f ./"$_dir_name"/input.yaml -X3 | \
                $DIFF_BIN - ./"$_dir_name"/output_X3.yaml
            _CHECK_EXIT_STATUS "$?"

            PRINT "  X4: env eval step"
            ./space -C0 -f ./"$_dir_name"/input.yaml -X4 | \
                $DIFF_BIN - ./"$_dir_name"/output_X4.yaml
            _CHECK_EXIT_STATUS "$?"

            PRINT ""
        fi
    done

    return "$_exit_status"
}

