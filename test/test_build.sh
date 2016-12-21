#!/usr/bin/env bash
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

#======================
# Test Space build node
#
# Test Space base module 
# and make sure build process works
#
#======================

set -o nounset
set -o pipefail

if ! command -v docker >/dev/null; then
    printf "\033[35mDocker command is not available.\033[0m\n"
    exit 1
else
    printf "\033[35mDocker command is available.\033[0m\n"
fi

CI_REGISTRY_IMAGE="registry.gitlab.com/space-sh/space"
IMAGE_VERSION="latest"

cat ./test/build/check_base_binaries.sh | docker run --rm -i $CI_REGISTRY_IMAGE:$IMAGE_VERSION /bin/bash
if [ "$?" -eq 0 ]; then
    printf "\033[32m[OK] Base binaries\033[0m\n"
else
    printf "\033[31m[OK] Base binaries\033[0m\n"
    exit 1
fi

cat ./test/build/check_base_libraries.sh | docker run --rm -i $CI_REGISTRY_IMAGE:$IMAGE_VERSION /bin/bash
if [ "$?" -eq 0 ]; then
    printf "\033[32m[OK] Base libraries\033[0m\n"
else
    printf "\033[31m[ERROR] Base libraries\033[0m\n"
    exit 1
fi

cat ./test/build/check_lua_binaries.sh | docker run --rm -i $CI_REGISTRY_IMAGE:$IMAGE_VERSION /bin/bash
if [ "$?" -eq 0 ]; then
    printf "\033[32m[OK] Lua binaries\033[0m\n"
else
    printf "\033[31m[ERROR] Lua binaries\033[0m\n"
    exit 1
fi

cat ./test/build/check_lua_libraries.sh | docker run --rm -i $CI_REGISTRY_IMAGE:$IMAGE_VERSION /bin/bash
if [ "$?" -eq 0 ]; then
    printf "\033[32m[OK] Lua libraries\033[0m\n"
else
    printf "\033[31m[ERROR] Lua libraries\033[0m\n"
    exit 1
fi

