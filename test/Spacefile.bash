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

_TEST_ALL_RECURSIVELY()
{
    SPACE_CMDDEP="PRINT"

    # Use parameter as target, otherwise defaults to iterate over everything
    local _target_directory="${1-*}"
    local _output_file_name=
    if [ "$_target_directory" = "*" ]; then
        _output_file_name="./test-results.txt"
    else
        _output_file_name="./test-${_target_directory}-results.txt"
    fi

    # Overwrite output file
    PRINT "${_output_file_name}" > "$_output_file_name"

    # Check if this is being run from project root directory
    if [ -d "./test" ] && [ -f "./space" ]; then

        # Iterate all dirs
        for dir in ./test/$_target_directory; do
            if [ -d "$dir" ]; then
                # Check if any YAML to run
                for file in "$dir"/*.yaml; do
                    if [ -f "$file" ]; then
                        PRINT "Performing test: $file..."
                        ./space -f "$file" /tests/0/ -a >> "$_output_file_name" 2>&1;

                        # Check for failed execution
                        if [ "$?" -ne 0 ]; then
                            PRINT "Failed to execute test for $file" "error" >> "$_output_file_name" 2>&1
                        fi
                        break
                    fi
                done

                # Jump to sub directories
                for subdir in ./"$dir"/*; do
                    # Check if any YAML to run
                    for file in "$subdir"/*.yaml; do
                        # HACK: skip ./test/yaml subdirs
                        if [[ "$subdir" == *"/test/yaml"* ]]; then
                            break
                        fi
                        if [ -f "$file" ]; then
                            PRINT "Performing test: $file..."
                            ./space -f "$file" /tests/0/ -a >> "$_output_file_name" 2>&1;

                            # Check for failed execution
                            if [ "$?" -ne 0 ]; then
                                PRINT "Failed to execute test for $file" "error" >> "$_output_file_name" 2>&1
                            fi

                            break
                        fi
                    done
                done
            fi
        done

        # Count occurrences
        # EXTERNAL: grep
        local _num_ok=$(grep -c "OK" "$_output_file_name")
        local _num_warn=$(grep -c "WARN" "$_output_file_name")
        local _num_error=$(grep -c "ERROR" "$_output_file_name")

        PRINT "----------------"
        PRINT "Test summary:"
        PRINT "OK:      $(echo "$_num_ok")" "ok"
        PRINT "WARNING: $(echo "$_num_warn")" "warning"
        PRINT "ERROR:   $(echo "$_num_error")" "error"
        PRINT "----------------"

        # List all functions that failed
        if [ "$_num_error" -gt 0 ]; then
            PRINT "----------------"
            PRINT "More information:"
            while read -r line; do
                if [[ "$line" =~ (\[ERROR\][[:space:]])(.*)(\:)(.*) ]]; then
                    PRINT "${BASH_REMATCH[4]}" "error"
                fi
            done < "$_output_file_name"
            PRINT "----------------"
        fi
    else
        PRINT "Tests must be called from space root development directory"
    fi

    # Cap max return value
    if [ "$_num_error" -gt 255 ]; then
        _num_error=255
    fi
    exit "$_num_error"
}

