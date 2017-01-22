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
# Space install script
#

# Definitions
_current_directory="$PWD"
_program_name="space"
_version="0.11.0"
_package_base="${_program_name}-${_version}"
_package_name="${_package_base}.tar.gz"
_package_sha1='7d02f16bf3f086ccb2885885cf118605ff8355d1'
_package_sha256='7f6283e8805bfa392f8a091f5f6b54fad1328f4b831aba35281ab20032a514c2'
_package_hash=''
_download_base_url="https://space.sh/static/download"
_download_url="${_download_base_url}/${_package_base}/${_package_name}"

# shasum binary
if command -v sha256sum >/dev/null; then
    _SHASUMBIN=sha256sum
    _package_hash="$_package_sha256"
elif command -v shasum >/dev/null; then
    _SHASUMBIN="shasum -a 256"
    _package_hash="$_package_sha256"
elif command -v sha1sum >/dev/null; then
    _SHASUMBIN=sha1sum
    _package_hash="$_package_sha1"
else
    printf "Missing required sha256 or shasum binaries. Exiting...\n"
    exit 1
fi

# Check if package hasn't been downloaded yet
if [ ! -f "$_package_name" ]; then
    printf "Package %s not found locally. Downloading...\n" "$_package_name"
    curl -L --remote-name "${_download_url}"
else
    printf "Found local package %s.\n" "$_package_name"
fi

# Verify package integrity
printf "Verifying package integrity...\t"
printf "%s  %s" $_package_hash $_package_name | $_SHASUMBIN -c
if [ "$?" -ne 0 ]; then
    printf "Package download is invalid or corrupted. Please remove it and re-run the installation process\n"
    exit 1
fi

# Create temporary directory
_tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t ${_package_name})
if [ $? -ne 0 ]; then
    printf "Could not create temp directory. Exiting..."
    exit 1
fi

# Extract package
printf "Extracting package %s to TMPDIR...\n" "$_package_name"
tar xzf "$_package_name" -C "$_tmp_dir"

#
# Enter directory
printf "Starting install procedure...\n"
cd "$_tmp_dir"

# Change shebang line according to environment
_bash_path=$(which bash)
sed -i.bak -E "1 s@^#\!(.*)/bin/(.*)@#\!${_bash_path}@" ./space

# Install
if [ -n "$1" ]; then
    _bin_path=$1
    # Append PWD from where it was called to relative path
    if [ "$_bin_path" = "${_bin_path#/}" ]; then
        _bin_path=${_current_directory}/${_bin_path}
    fi
    if [ -n "$2" ]; then
        _completion_path=$2
        if [ "$_completion_path" = "${_completion_path#/}" ]; then
            _completion_path=${_current_directory}/${_completion_path}
        fi
        ./space /install/ -- "$_bin_path" "$_completion_path"
    else
        ./space /install/ -- "$_bin_path" ""
    fi
else
    ./space /install/
fi

