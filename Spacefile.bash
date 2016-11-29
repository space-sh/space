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

SPACE_INSTALL_BIN()
{
    command install -m 755 ${_bin_file_name} ${_bindest}
    if [ "$?" -gt 0 ]; then
        if [ "$(id -u)" != 0 ]; then
            PRINT "This program must be run as root in order to install ${_bin_file_name} to ${_bindest}. Please run as: \"curl https://get.space.sh > install.sh; sudo sh install.sh\" or \"curl https://get.space.sh | sudo sh\" instead." "error"
        fi
        PRINT "[${_bin_full_path}]  FAILED" "error"
        return 1
    fi
    PRINT "[${_bin_full_path}]  OK" "success"
}

SPACE_DEP_INSTALL()
{
    SPACE_CMDDEP="PRINT"

    # This is a lighter variant of a dep_installer,
    # since the full variant depends on the OS module,
    # and we don't want that dependency here.
    if ! command -v git >/dev/null; then
        PRINT "Git is not installed, you will have to install it using your package manager." "error"
        return 1
    else
        PRINT "Dependencies found." "success"
    fi
}

SPACE_INSTALL()
{
    SPACE_CMDDEP="_to_lower PRINT SPACE_INSTALL_BIN"
    SPACE_CMDENV="AC_PREFIX BIN_PREFIX"

    PRINT "Installing..."

    local _binprefix="${1-}"
    shift
    local _acprefix="${1-}"
    shift

    # Check if to auto detect installation paths.
    if [ -z "${_binprefix}" ]; then
        PRINT "No bin prefix provided on cmd line, attempting auto detect." "debug"
        if [ -n "${PREFIX-}" ]; then
            PRINT "Auto detected bin prefix: \${PREFIX}=${PREFIX}." "debug"
            _binprefix="${PREFIX}"
        else
            PRINT "Did not auto detect bin prefix \${PREFIX}. Using default: ${BIN_PREFIX}. 'export env PREFIX' to override." "debug"
            _binprefix="${BIN_PREFIX}"
        fi
    fi

    if [ -z "${_acprefix}" ]; then
        PRINT "No auto completion prefix provided on cmd line, attempting auto detect." "debug"
        if [ -n "${PREFIX-}" ]; then
            PRINT "Auto detected auto completion prefix: \${PREFIX}=${PREFIX}." "debug"
            PRINT "Looking for destinations..." "debug"
            local _acdests="etc/bash_completion.d usr/share/bash-completion/completions"
            for _acdir in ${_acdests}; do
                local _dir="${PREFIX}/${_acdir}"
                PRINT "Trying: ${_dir}." "debug"
                if [ -d "${_dir}" ]; then
                    PRINT "Auto detected auto completion destination: ${_dir}."
                    _acprefix="${_dir}"
                    break
                fi
            done
        fi
    fi
    if [ -z "${_acprefix}" ]; then
        PRINT "Did not auto detect auto completion prefix \${PREFIX}. Using default: ${AC_PREFIX}. 'export env PREFIX' to override." "debug"
        _acprefix="${AC_PREFIX}"
    fi

    local _bindest=${_binprefix}/bin
    local _acdest=${_acprefix}
    local _bin_file_name="space"
    local _ac_file_name="init_autocompletion.sh"
    local _ac_file_path="./completion/${_ac_file_name}"
    local _bin_full_path=${_bindest}/${_bin_file_name}

    #
    # Install program

    # Existing installation
    if [ -f ${_bin_full_path} ]; then
        local _dest_file_size=$(wc -c < ${_bin_full_path})
        local _dest_file_version=$($_bin_full_path -V 2>&1)
        local _src_file_size=$(wc -c < ${_bin_file_name})
        local _src_file_version=$(${_bin_file_name} -V 2>&1)

        PRINT "Space is already installed on ${_bin_full_path}" "warning"
        if [ ${_dest_file_size} -eq ${_src_file_size} ]; then
            PRINT "Source file size is the same as destination: ${_src_file_size} bytes long." "warning"
        else
            PRINT "Source file is ${_src_file_size} bytes long, while destination file is ${_dest_file_size} bytes." "warning"
        fi

        PRINT "Replacing current installed version [${_dest_file_version}] with [${_src_file_version}]" "warning"

        # Sleep for 5 before proceeding
        PRINT "Grace time: 5 seconds before proceeding..." "warning"
        sleep 5

        # Install!
        SPACE_INSTALL_BIN
        if [ "$?" -gt 0 ]; then
            return 1
        fi
    else
        # Often times PREFIX exists but not /bin
        # Make sure destination exists, otherwise we just create it
        mkdir -p "$_bindest"

        # Install!
        SPACE_INSTALL_BIN
        if [ "$?" -gt 0 ]; then
            return 1
        fi
    fi

    # Install auto completion
    # Check source file is present
    if [ ! -f $_ac_file_path ]; then
        PRINT "[${_acdest}/${_ac_file_name}]  FAILED" "error"
        PRINT "Auto completion will not work because the completion script could not be located at ${_ac_file_path}" "warning"
    else
        if [ -d ${_acdest} ]; then
            command install -m 644 $_ac_file_path ${_acdest}/space
            if [ "$?" -gt 0 ]; then
                PRINT "[${_acdest}/space]  FAILED" "error"
                PRINT "Auto completion will not work because destination doesn't exist: [${_acdest}]. Make sure the destination directory is valid and bash-completion is installed. After that, repeat the installation process if bash completion is desired." "warning"
            else
                PRINT "[${_acdest}/space]  OK" "success"
                PRINT "You might want to re-login into bash to get the bash completion loaded."
            fi
        else
            PRINT "[${_acdest}/space]  FAILED" "error"
            PRINT "Auto completion will not work because destination doesn't exist: [${_acdest}]. Make sure the destination directory is valid and bash-completion is installed. After that, repeat the installation process if bash completion is desired." "warning"

            local _uname_s=$(uname -s)
            if [ $_uname_s == "Darwin" ]; then
                PRINT $'Ah! I noticed you are running on Darwin. Take this hint:\n\tbrew install bash-completion\n\t./space /install/ -- \"/usr/local\" \"/usr/local/etc/bash_completion.d\"\n\t# now relog on the terminal in order to have completions reloaded.'
            fi
        fi
    fi
}

SPACE_UNINSTALL()
{
    # External
    SPACE_CMDDEP="PRINT"
    SPACE_CMDENV="AC_PREFIX"

    local _find_space=$(which space 2>&1)
    if [ -z "${_find_space}" ]; then
        PRINT "Failed to find Space installed on the system. Either not installed or missing on PATH." "warning"
    else
        local _uname_s=$(uname -s)
        local _find_ac=${AC_PREFIX}
        if [ $_uname_s == "Darwin" ]; then
            _find_ac="/usr/local/etc/bash_completion.d"
        fi
        PRINT "In order to uninstall Space, remove the following files: #1 ${_find_space} #2 ${_find_ac}/space"
    fi
}

