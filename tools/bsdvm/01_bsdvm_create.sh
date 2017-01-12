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
# Create new VM 
#

if ! command -v VBoxManage >/dev/null; then
    printf "FAIL: VBoxManage program is required\n" 1>&2
    exit 1
fi

_bsd_image_name="FreeBSD-11.0-RELEASE-amd64.vhd"

if [ ! -f "${_bsd_image_name}" ]; then
    printf "Missing ${_bsd_image_name}. Please run \"sh 00_bsdvm_fetch.sh\" first.\n" 1>&2
    exit 1
fi

VBoxManage createvm --name SpaceBSD --ostype FreeBSD_64 --register
VBoxManage modifyvm SpaceBSD --memory 1024
VBoxManage modifyvm SpaceBSD --natpf1 rule1,tcp,,2222,,22
VBoxManage storagectl SpaceBSD --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach SpaceBSD --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ${_bsd_image_name}

