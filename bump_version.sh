#!/usr/bin/env sh
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
# Bump Space version
#

set -o errexit
set -o nounset


#
# Check arguments
if [ "$#" -lt 1 ]; then
    printf "Missing version name. Example: $0 1.0.0\n" >&2
fi

#
# Check requirements
if ! command -v sed >/dev/null; then
    printf "Missing sed program. Exiting...\n" >&2
    exit 1
fi

#
# Data
_current_version_name=$(./space -V 2>&1)
for token in $_current_version_name; do  # Get only version numbert
    _current_version_name=$token
done
_version_name="$1"
_version_date=$(date "+%Y-%m-%d")

#
# Files to change
_changelog_file="./CHANGELOG.md"
_readme_file="./README.md"
_docinstall_file="./doc/install.md"
_space_file="./space"
_installsh_file="./tools/installer/install.sh"

# Update files
sed -i.bak "s/\[current\]/\[${_version_name} - ${_version_date}\]/" "$_changelog_file"
sed -i.bak "s/${_current_version_name}/${_version_name}/g" "$_readme_file"
sed -i.bak "s/${_current_version_name}/${_version_name}/g" "$_docinstall_file"
sed -i.bak "s/readonly \_VERSION\=\"${_current_version_name}\"/readonly \_VERSION\=\"${_version_name}\"/g" "$_space_file"
sed -i.bak "s/\_version\=\"${_current_version_name}\"/\_version\=\"${_version_name}\"/g" "$_installsh_file"

#
# Cleanup temporary files
if [ -f "$_changelog_file" ]; then
    rm "${_changelog_file}.bak"
fi

if [ -f "$_readme_file" ]; then
    rm "${_readme_file}.bak"
fi

if [ -f "$_docinstall_file" ]; then
    rm "${_docinstall_file}.bak"
fi

if [ -f "$_space_file" ]; then
    rm "${_space_file}.bak"
fi

if [ -f "$_installsh_file" ]; then
    rm "${_installsh_file}.bak"
fi


