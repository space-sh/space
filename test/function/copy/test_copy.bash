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

_TEST_COPY()
{
    SPACE_DEP="PRINT _copy"
    SPACE_ENV="_YAML_PREFIX _YAML_NAMESPACE"

    local _sg1_0a95somespace_node1_node3_Test0a95nO0a95d3="Passed"
    local _test_storage=
    _copy "_test_storage" "/_somespace/node1/node3/Test_nO_d3"

    if [ ${_test_storage} = "Passed" ]; then
        PRINT "_copy OK!" "ok"
        return 0
    else
        PRINT "_copy failed!" "error"
        return 1
    fi
}

