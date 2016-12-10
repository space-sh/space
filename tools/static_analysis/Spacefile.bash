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

#
# Static analysis
#

#
# Shellcheck
#
_RUN_SHELLCHECK()
{
    SPACE_CMDDEP="PRINT"

    if [ "$#" -lt 2 ]; then
        PRINT "Missing two parameters: input file name and output file name." "error"
        PRINT "Example: -- \"space\" \"static_analysis_shellcheck.txt\"" "error"
        return 1
    fi
    local _file_name=$1
    shift || :
    local _output_file_name=$1
    shift || :
    local _shell_name="sh"
    local _command_name="shellcheck"

    PRINT "Shellcheck analysis..."
    # EXTERNAL: command
    if command -v "$_command_name" >/dev/null 2>&1; then
        echo "###### spacegal ######" > "$_output_file_name"
        ${_command_name} --shell="$_shell_name" -e SC2004 -e SC2034 "$_file_name" >> "$_output_file_name"
        echo "Done"
    else
        PRINT "Needs 'shellcheck' binary. Skipping this step...\nPlease visit:\n  https://www.shellcheck.net\n  https://github.com/koalaman/shellcheck" "error"
        return 1
    fi

    # Count occurrences
    # EXTERNAL: grep
    local _num_occurrences=
    _num_occurrences=$(grep -c "SC[0-9]" "$_output_file_name")
    PRINT "Found $(echo "$_num_occurrences") issues. Read $_output_file_name for details." "warning"
}

#
# Checkbashisms
#
_RUN_CHECKBASHISMS()
{
    SPACE_CMDDEP="PRINT"

    if [ "$#" -lt 2 ]; then
        PRINT "Missing two parameters: input file name and output file name." "error"
        PRINT "Example: -- \"space\" \"static_analysis_checkbashisms.txt\"" "error"
        return 1
    fi

    local _file_name=$1
    shift || :
    local _output_file_name=$1
    shift || :
    local _command_name="checkbashisms"

    PRINT "Checkbashisms analysis..."
    # EXTERNAL: command
    if command -v "$_command_name" >/dev/null 2>&1; then
        echo "###### spacegal ######" > "$_output_file_name"
        ${_command_name} -f "$_file_name" >> "$_output_file_name" 2>&1
        echo "Done"
    else
        PRINT "Needs 'checkbashisms' binary. Skipping this step...\nPlease visit:\n  https://launchpad.net/ubuntu/+source/devscripts/ and look for checkbashisms.pl\n  or install using your favorite package manager" "error"
        return 1
    fi

    # Count occurrences
    # EXTERNAL: grep
    local _num_occurrences=
    _num_occurrences=$(grep -c "possible bashism" "$_output_file_name")
    PRINT "Found $(echo "$_num_occurrences") issues. Read $_output_file_name for details." "warning"
}

_RUN_ALL()
{
    SPACE_CMDDEP="_RUN_CHECKBASHISMS _RUN_SHELLCHECK"

    if [ "$#" -lt 2 ]; then
        PRINT "Missing two parameters: input file name and output file name suffix" "error"
        PRINT "Example: -- \"space\" \"analysis_\"" "error"
        return 1
    fi

    local _file_name=$1
    shift || :
    local _suffix_output_file_name=$1
    shift || :

    local _output_file_name="${_suffix_output_file_name}_shellcheck.txt"
    _RUN_SHELLCHECK "$_file_name" "$_output_file_name"
    _output_file_name="${_suffix_output_file_name}_checkbashisms.txt"
    _RUN_CHECKBASHISMS "$_file_name" "$_output_file_name"
}

_RUN_ALL_RECURSIVELY()
{
    SPACE_CMDDEP="_RUN_CHECKBASHISMS _RUN_SHELLCHECK"

    if [ "$#" -lt 1 ]; then
        PRINT "Missing destination directory parameter" "error"
        PRINT "Example: -- \"./static-analysis-results\"" "error"
        return 1
    fi

    local _output_dir=$1
    shift || :

    # Create output directory if it doesn't exist
    if [ ! -d "$_output_dir" ]; then
        # EXTERNAL: mkdir
        mkdir -p "$_output_dir"
    fi

    # Iterate over all subdirectories looking for .bash or .sh files to analyze
    for dir in ./*; do
        for file in {"$dir"/*.{sh,bash},"$dir"/*/*.{sh,bash}}; do
            if [ -f "$file" ]; then
                PRINT "Performing static analysis on $file..."
                local _file_name=${file//\//_}
                local _file_name=${_file_name//./}
                local _output_file_name="${_output_dir}/${_file_name}_shellcheck.txt"
                _RUN_SHELLCHECK "$file" "$_output_file_name"
                _output_file_name="${_output_dir}/${_file_name}_checkbashisms.txt"
                _RUN_CHECKBASHISMS "$file" "$_output_file_name"
            fi
        done
    done

    # Build summary stats
    # EXTERNAL: grep
    local _num_shellcheck=0
    local _num_checkbashisms=0
    for file in "$_output_dir"/*; do
        local _occurrences=0
        _occurrences=$(grep -c "SC[0-9]" "$file")
        _num_shellcheck=$(($_num_shellcheck + $_occurrences))

        _occurrences=0
        _occurrences=$(grep -c "possible bashism" "$file")
        _num_checkbashisms=$(($_num_checkbashisms + $_occurrences))
    done

    # Summary statistics
    PRINT "----------------"
    PRINT "Summary:"
    PRINT ""
    PRINT "shellcheck issues:      $(echo "$_num_shellcheck")" "warning"
    PRINT "checkbashisms issues:   $(echo "$_num_checkbashisms")" "warning"
    PRINT "----------------"
}

