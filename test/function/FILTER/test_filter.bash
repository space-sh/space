#!/usr/bin/env bash
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

_RUN_CHECK_SUBST()
{
    local _varname=$1

    # Expected output
    local _expected_output=
    eval "_expected_output=\${_varname}"

    # Assert varname is different than expected output
    eval "[ \"${_expected_output}\" = \"\$${_varname}\" ] && printf '\033[31m[ERROR] ${_varname} has already been subst\033[0m\n' && exit 1"

    # Run
    _filter "$_varname"

    eval "[ \"\${_expected_output}\" = \"\${_varname}\" ] && \
        printf '\033[32m[OK] ${_varname}\033[0m\n' && return 0 || \
        printf '\033[31m[ERROR] ${_varname} does not match expected output: %s. Value: %s\033[0m\n' \"${_expected_output}\" \"\$${_varname}\" && exit 1"
}

_SUBST_SINGLE()
{
    local __var=$1
    printf "IN: %s\n" "$__var"
    _filter "__var"
    printf "OUT: %s\n\n" "$__var"
}

_SUBST_SINGLE_WITH_CHECK()
{
    local __var=$1
    printf "IN: %s\n" "$__var"
    _RUN_CHECK_SUBST "__var"
    printf "OUT: %s\n\n" "$__var"
}

# Disable warning about argument references
# shellcheck disable=SC2120
# Disable warning about single quote not expanding
# shellcheck disable=SC2016
# Disable warning about local
# shellcheck disable=SC2039

_TEST_FILTER()
{
    SPACE_DEP="_SUBST_SINGLE _SUBST_SINGLE_WITH_CHECK _RUN_CHECK_SUBST _filter"

    local _test_value="abcdefghZWVYX321"
    local _test_pattern="abcd"
    local _test_string="_test_value"
    local _test_offset="1"
    local _test_length="6"

    # Base
    local _base='$_test_value'
    local _base_with_string='Hello $_test_value'
    local _base_with_command='Hello $_test_value $(ls)'
    local _base_with_friendly_command='Hello (shhhhhh) $_test_value $(ls)'
    local _base_with_escaped_command='Hello $_test_value \$(ls)'
    local _base_all_escaped_command='Hello $_test_value \$\(ls\)'
    local _base_with_command_tick='Hello $_test_value `(ls)`'
    local _base_with_escaped_command_tick='Hello $_test_value \`(ls)\`'
    local _base_with_arithmetic='Hello $_test_value $((1+2))'
    local _base_double_with_string='Hello $_test_value $_test_string'
    local _base_braces='${_test_value}'

    # Substring
    local _substring_hash_single='${_test_value#${_test_pattern}}'
    local _substring_hash_double='${_test_value##${_test_pattern}}'
    local _substring_percent_single='${_test_value%${_test_pattern}}'
    local _substring_percent_double='${_test_value%%${_test_pattern}}'

    # Substring expansion
    local _substring_exp_base='${_test_value:${_test_offset}}'
    local _substring_exp_length='${_test_value:${_test_offset}:${_test_length}}'

    # Find and replace
    local _find_and_replace_1='${_test_value/${_test_pattern}/${_test_string}}'
    local _find_and_replace_2='${_test_value//${_test_pattern}/${_test_string}}'
    local _find_and_replace_3='${_test_value/${_test_pattern}}'
    local _find_and_replace_4='${_test_value//${_test_pattern}}'

    # Length
    local _length='${#_test_value}'

    # Default value
    local _default_all='${_test_value:-${_test_string}}'
    local _default_when_unset='${_test_value-${_test_string}}'

    # Default value with assignment
    local _default_assign_all='${_test_value:=${_test_string}}'
    local _default_assign_when_unset='${_test_value=${_test_string}}'

    # Alternative default
    local _default_alt_all='${_test_value:+${_test_string}}'
    local _default_alt_when_unset='${_test_value+${_test_string}}'

    # Reference (indirection)
    local _indirection='${!_test_string}'

    # Name expansion
    local _name_exp_star='${!_test_value*}'
    local _name_exp_at='${!_test_value@}'

    #
    # Bash 4+ only
    # Error checking for empty or unset
    #local _error_all='${_test_value:?}'
    #local _error_when_unset='${_test_value:?}'
    # (undoc?) Case modification
    #local _comma_single='${_test_value,}'
    #local _comma_double='${_test_value,,}'
    #local _exponent_single='${_test_value^}'
    #local _exponent_double='${_test_value^^}'
    #local _tilde_single='${_test_value~}'
    #local _tilde_double='${_test_value~~}'

    #
    # Perform tests
    printf "=================\n"
    printf "Reference values\n"
    printf "\$_test_value=%s\n" "$_test_value"
    printf "\$_test_pattern=%s\n" "$_test_pattern"
    printf "\$_test_string=%s\n" "$_test_string"
    printf "\$_test_offset=%s\n" "$_test_offset"
    printf "\$_test_length=%s\n" "$_test_length"
    printf "=================\n"

    _SUBST_SINGLE_WITH_CHECK $_base
    _SUBST_SINGLE_WITH_CHECK "$_base_with_string"
    _SUBST_SINGLE_WITH_CHECK "$_base_double_with_string"
    _SUBST_SINGLE_WITH_CHECK $_base_braces

    _SUBST_SINGLE_WITH_CHECK $_substring_hash_single
    _SUBST_SINGLE_WITH_CHECK $_substring_hash_double
    _SUBST_SINGLE_WITH_CHECK $_substring_percent_single
    _SUBST_SINGLE_WITH_CHECK $_substring_percent_double

    _SUBST_SINGLE_WITH_CHECK $_substring_exp_base
    _SUBST_SINGLE_WITH_CHECK $_substring_exp_length

    _SUBST_SINGLE_WITH_CHECK $_find_and_replace_1
    _SUBST_SINGLE_WITH_CHECK $_find_and_replace_2
    _SUBST_SINGLE_WITH_CHECK $_find_and_replace_3
    _SUBST_SINGLE_WITH_CHECK $_find_and_replace_4

    _SUBST_SINGLE_WITH_CHECK $_length

    _SUBST_SINGLE_WITH_CHECK $_default_all
    _SUBST_SINGLE_WITH_CHECK $_default_when_unset

    _SUBST_SINGLE_WITH_CHECK $_default_assign_all
    _SUBST_SINGLE_WITH_CHECK $_default_assign_when_unset

    _SUBST_SINGLE_WITH_CHECK $_default_alt_all
    _SUBST_SINGLE_WITH_CHECK $_default_alt_when_unset

    _SUBST_SINGLE_WITH_CHECK $_indirection

    _SUBST_SINGLE_WITH_CHECK "$_name_exp_star"
    _SUBST_SINGLE_WITH_CHECK $_name_exp_at

    _SUBST_SINGLE "$_base_with_command"
    _SUBST_SINGLE "$_base_with_friendly_command"
    _SUBST_SINGLE "$_base_with_escaped_command"
    _SUBST_SINGLE "$_base_all_escaped_command"
    _SUBST_SINGLE "$_base_with_command_tick"
    _SUBST_SINGLE "$_base_with_escaped_command_tick"
    _SUBST_SINGLE "$_base_with_arithmetic"

    # Test output
    local _base_out=
    printf "[_filter \"_base\"]\n"
    printf "before filter: in=%s out=%s\n" "$_base" "$_base_out"
    _filter "_base"
    printf "after filter: in=%s out=%s\n" "$_base" "$_base_out"

    printf "[_filter \"_base\" \"_base_out\"]\n"
    _base='$_test_value'
    printf "before filter: in=%s out=%s\n" "$_base" "$_base_out"
    _filter "_base" "_base_out"
    printf "after filter: in=%s out=%s\n" "$_base" "$_base_out"
}
