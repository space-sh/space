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

#
# manpage_exporter - Exports Markdown files to roff and HTML
#

_EXPORT_MAN()
{
    SPACE_CMDDEP="PRINT"
    SPACE_CMDENV="DATE_NOW MAN_NAME ORGANIZATION_NAME"

    if [ "$#" -eq 0 ]; then
        PRINT "missing input file to generate man page from" "error"
        return 1
    fi

    local _doc_file_path="$1"
    local _doc_file_name=
    _doc_file_name=$(basename "$_doc_file_path")
    local _doc_export_path=
    _doc_export_path="$(pwd)/${_doc_file_name%.*}.1"

    # Check if file exists
    if [ ! -f "$_doc_file_path" ]; then
        PRINT "Failed to load $_doc_file_path" "error"
        return 1
    fi

    # Check if ronn is available
    if ! command -v ronn >/dev/null; then
        PRINT "ronn program not found. Please check the README file for instructions on how to install it" "error"
        exit 1
    fi

    ronn --roff --date="$DATE_NOW" --manual="$MAN_NAME" --organization="$ORGANIZATION_NAME" --pipe "$_doc_file_path" > "$_doc_export_path"

    if [ $? -ne 0 ]; then
        PRINT "Failed to generate man page for $_doc_file_name" "error"
        return 1
    else
        PRINT "Man page exported to $_doc_export_path"
    fi
}

_EXPORT_HTML()
{
    SPACE_CMDDEP="PRINT"
    SPACE_CMDENV="DATE_NOW MAN_NAME ORGANIZATION_NAME"

    if [ "$#" -eq 0 ]; then
        PRINT "missing input file to generate man page from" "error"
        return 1
    fi

    local _doc_file_path="$1"
    local _doc_file_name=
    _doc_file_name=$(basename "$_doc_file_path")
    local _doc_export_path=
    _doc_export_path="$(pwd)/${_doc_file_name%.*}.html"

    # Check if file exists
    if [ ! -f "$_doc_file_path" ]; then
        PRINT "Failed to load $_doc_file_path" "error"
        return 1
    fi

    # Check if ronn is available
    if ! command -v ronn >/dev/null; then
        PRINT "ronn program not found. Please check the README file for instructions on how to install it" "error"
        exit 1
    fi

    ronn --html --date="$DATE_NOW" --manual="$MAN_NAME" --organization="$ORGANIZATION_NAME" --pipe "$_doc_file_path" > "$_doc_export_path"

    if [ $? -ne 0 ]; then
        PRINT "Failed to generate HTML page for $_doc_file_name" "error"
        return 1
    else
        PRINT "HTML page exported to $_doc_export_path"
    fi
}

