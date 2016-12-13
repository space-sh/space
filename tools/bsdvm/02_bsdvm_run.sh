#!/usr/bin/env sh
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
# Run VM
#

if ! command -v VBoxManage >/dev/null; then
    printf "FAIL: VBoxManage program is required\n" 1>&2
    exit 1
fi

VBoxManage startvm SpaceBSD
if [ "$?" -ne 0 ]; then
    exit 1
fi

printf "\n===== INSTRUCTIONS =====\n\n Inside SpaceBSD (Guest):
 > login: root
 >
 # passwd
 # dhclient em0
 # pkg update
 # pkg install bash curl git
 # printf \"fdesc\\\t/dev/fd\\\\tfdescfs\\\trw\\\t0\\\t0\\\n\" >> /etc/fstab
 # echo sshd_enable=\\\"YES\\\" > /etc/rc.conf
 # echo ifconfig_em0=\\\"DHCP\\\" >> /etc/rc.conf
 # echo \"PasswordAuthentication yes\" >> /etc/ssh/sshd_config
 # echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config
 # service sshd start
 # service sshd enable
 # shutdown -h now

 On host:
 $ VBoxManage startvm SpaceBSD --type headless
 $ ssh -p 2222 -o PubkeyAuthentication=no root@127.0.0.1
 \n"

