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

_TEST_SORT_PAD_SINGLE_DIGIT()
{
    SPACE_CMDDEP="PRINT _sort_pad"

    local _value="2"
    local _padded_value=

    _sort_pad "_padded_value" "$_value"
    if [ "$_padded_value" = "0000000002" ]; then
        PRINT "_sort_pad OK!" "ok"
        return 0
    else
        PRINT "_sort_pad failed!" "error"
        return 1
    fi
}

_TEST_SORT_PAD_SINGLE_CHARACTER()
{
    SPACE_CMDDEP="PRINT _sort_pad"

    local _value="k"
    local _padded_value=

    _sort_pad "_padded_value" "$_value"
    if [ "$_padded_value" = "k" ]; then
        PRINT "_sort_pad OK!" "ok"
        return 0
    else
        PRINT "_sort_pad failed!" "error"
        return 1
    fi
}

_TEST_SORT_PAD_10_DIGITS()
{
    SPACE_CMDDEP="PRINT _sort_pad"

    local _value="0000000002"
    local _padded_value=

    _sort_pad "_padded_value" "$_value"
    if [ "$_padded_value" = "0000000002" ]; then
        PRINT "_sort_pad OK!" "ok"
        return 0
    else
        PRINT "_sort_pad failed!" "error"
        return 1
    fi
}

_TEST_SORT_PAD_10_CHARACTERS()
{
    SPACE_CMDDEP="PRINT _sort_pad"

    local _value="abeOPuzMvk"
    local _padded_value=

    _sort_pad "_padded_value" "$_value"
    if [ "$_padded_value" = "abeOPuzMvk" ]; then
        PRINT "_sort_pad OK!" "ok"
        return 0
    else
        PRINT "_sort_pad failed!" "error"
        return 1
    fi
}

_TEST_SORT_PAD_20_DIGITS()
{
    SPACE_CMDDEP="PRINT _sort_pad"

    local _value="00000000000000000002"
    local _padded_value=

    _sort_pad "_padded_value" "$_value"
    if [ "$_padded_value" = "0000000002" ]; then
        PRINT "_sort_pad OK!" "ok"
        return 0
    else
        PRINT "_sort_pad failed!" "error"
        return 1
    fi
}

_TEST_SORT_PAD_20_CHARACTERS()
{
    SPACE_CMDDEP="PRINT _sort_pad"

    local _value="abeOPuzMvkUOPQWEZADs"
    local _padded_value=

    _sort_pad "_padded_value" "$_value"
    if [ "$_padded_value" = "abeOPuzMvkUOPQWEZADs" ]; then
        PRINT "_sort_pad OK!" "ok"
        return 0
    else
        PRINT "_sort_pad failed!" "error"
        return 1
    fi
}
