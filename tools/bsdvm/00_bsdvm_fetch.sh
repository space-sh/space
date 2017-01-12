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
# Download and extract BSD VM image
#

#
# Check required programs
if ! command -v curl >/dev/null; then
    printf "FAIL: curl program is required\n" 1>&2
    exit 1
fi

if ! command -v xz >/dev/null; then
    printf "FAIL: xz program is required\n" 1>&2
    exit 1
fi

#
# Setup URL and file name
_bsd_image_base_url="ftp://ftp.freebsd.org/pub/FreeBSD/releases/VM-IMAGES/11.0-RELEASE/amd64/Latest/"
_bsd_image_name="FreeBSD-11.0-RELEASE-amd64.vhd"
_bsd_image_name_compressed="${_bsd_image_name}.xz"

#
# Check file is available and download it if needed
if [ ! -f "./${_bsd_image_name_compressed}" ]; then
    printf "Image file ${_bsd_image_name_compressed} was not found. Downloading from ${_bsd_image_base_url}...\n" 1>&2
    curl -O "${_bsd_image_base_url}${_bsd_image_name_compressed}"
    _exit_code="$?"
    if [ "$_exit_code" -ne 0 ]; then
        printf "Failed to curl ${_bsd_image_name_compressed} from ${_bsd_image_base_url}. Returned "$_exit_code"\n" 1>&2
        exit "$_exit_code"
    fi
fi


#
# FIXME: missing file integrity check around here


#
# Extract file image
xz --verbose --decompress "${_bsd_image_name_compressed}"
_exit_code="$?"
if [ "$?" -ne 0 ]; then
    printf "Failed to extract ${_bsd_image_name_compressed}. Returned "$_exit_code"\n" 1>&2
    exit "$_exit_code"
else
    if [ -f "${_bsd_image_name}" ]; then
        printf "${_bsd_image_name}\n"
        exit 0
    fi
fi

