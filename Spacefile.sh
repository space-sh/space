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


# Disable warning about indirectly checking exit code
# shellcheck disable=2181

SPACE_INSTALL_BIN()
{
    command install -m 755 "${_bin_file_name}" "${_bindest}"
    if [ "$?" -gt 0 ]; then
        if [ "$(id -u)" != 0 ]; then
            PRINT "This program must be run as root in order to install ${_bin_file_name} to ${_bindest}. If performing the manual install, please run: \"sudo ./space /install/\". Otherwise just run the automated install again using 'sudo sh -c \"curl https://get.space.sh\"' instead." "error"
        fi
        PRINT "[${_bin_full_path}]  FAILED" "error"
        return 1
    fi
    PRINT "[${_bin_full_path}]  OK" "ok"
}

SPACE_DEP_INSTALL()
{
    SPACE_DEP="PRINT"

    # This is a lighter variant of a dep_installer,
    # since the full variant depends on the OS module,
    # and we don't want that dependency here.
    if ! command -v git >/dev/null; then
        PRINT "Git is not installed, you will have to install it using your package manager." "error"
        return 1
    else
        PRINT "Dependencies found." "ok"
    fi
}

SPACE_BUILD()
{
    SPACE_DEP="PRINT"

    if ! command -v docker >/dev/null; then
        PRINT "Docker is not installed. Failed to build container image." "error"
        return 1
    fi

    if [ ! -f "./space" ]; then
       PRINT "Build must be performed from Space root development directory" "error"
       exit 1
    fi

    IMAGE_VERSION=$(./space -V 2>&1);
    for version_part in $IMAGE_VERSION; do
        IMAGE_VERSION=$version_part;
    done;

    docker build --build-arg VERSION=$IMAGE_VERSION -t registry.gitlab.com/space-sh/space -f ./build/Dockerfile .
}


# Disable warning about indirectly checking exit code
# shellcheck disable=2181

SPACE_INSTALL()
{
    SPACE_DEP="PRINT SPACE_INSTALL_BIN"
    SPACE_ENV="AC_PREFIX BIN_PREFIX"

    PRINT "Installing..."

    local _binprefix="${1-}"
    local _acprefix="${2-}"

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
    local _mandest=${_binprefix}/share/man/man1
    local _bin_file_name="space"
    local _ac_file_name="init_autocompletion.sh"
    local _man_file_name="space.1"
    local _ac_file_path="./completion/${_ac_file_name}"
    local _man_file_path="./${_man_file_name}"
    local _bin_full_path=${_bindest}/${_bin_file_name}

    #
    # Install program

    # Existing installation
    if [ -f "${_bin_full_path}" ]; then
        local _dest_file_size=
        _dest_file_size=$(wc -c < "${_bin_full_path}" )

        local _dest_file_version=
        _dest_file_version=$($_bin_full_path -V 2>&1)

        local _src_file_size=
        _src_file_size=$(wc -c < "${_bin_file_name}" )

        local _src_file_version=
        _src_file_version=$(${_bin_file_name} -V 2>&1)

        PRINT "Space is already installed on ${_bin_full_path}" "warning"
        if [ "${_dest_file_size}" -eq "${_src_file_size}" ]; then
            PRINT "Source file size is the same as destination: ${_src_file_size} bytes long." "warning"
        else
            PRINT "Source file is ${_src_file_size} bytes long, while destination file is ${_dest_file_size} bytes." "warning"
        fi

        PRINT "Replacing current installed version [${_dest_file_version}] with [${_src_file_version}]" "warning"

        # Sleep for 5 before proceeding
        PRINT "Grace time: 5 seconds before proceeding..." "warning"
        sleep 5

        # In case of existing old installs (0.9.0 and earlier), they likely
        # won't have man pages installed and the destination dir might not exist.
        # Make sure destination exists, otherwise we just create it
        mkdir -p "$_mandest"

        # Install!
        SPACE_INSTALL_BIN
        if [ "$?" -gt 0 ]; then
            return 1
        fi
    else
        # Often times PREFIX exists but not /bin or /man/{man1}
        # Make sure destination exists, otherwise we just create it
        mkdir -p "$_bindest"
        mkdir -p "$_mandest"

        # Install!
        SPACE_INSTALL_BIN
        if [ "$?" -gt 0 ]; then
            return 1
        fi
    fi

    # Install man page
    # Check source file is present
    if [ ! -f $_man_file_path ]; then
        PRINT "[${_mandest}/${_man_file_name}]  FAILED to find man page: $_man_file_path. Skipping..." "warning"
    else
        if [ -d "${_mandest}" ]; then
            command install -m 644 "${_man_file_path}" "${_mandest}"
            if [ "$?" -gt 0 ]; then
                PRINT "[${_mandest}/${_man_file_name}]  FAILED to install man page. Skipping..." "warning"
            else
                PRINT "[${_mandest}/${_man_file_name}]  OK" "ok"
            fi
        else
            PRINT "[${_mandest}/${_man_file_name}]  FAILED to find destination directory: $_mandest. Skipping..." "warning"
        fi
    fi

    # Install auto completion
    # Check source file is present
    if [ ! -f $_ac_file_path ]; then
        PRINT "[${_acdest}/${_ac_file_name}]  FAILED" "warning"
        PRINT "Auto completion will not work because the completion script could not be located at ${_ac_file_path}" "warning"
    else
        if [ -d "${_acdest}" ]; then
            command install -m 644 "$_ac_file_path" "${_acdest}/space"
            if [ "$?" -gt 0 ]; then
                PRINT "[${_acdest}/space]  FAILED" "warning"
                PRINT "Auto completion will not work because destination doesn't exist: [${_acdest}]. Make sure the destination directory is valid and bash-completion is installed. After that, repeat the installation process if bash completion is desired." "warning"
            else
                PRINT "[${_acdest}/space]  OK" "ok"
                PRINT "You might want to re-login into bash to get the bash completion loaded."
            fi
        else
            PRINT "[${_acdest}/space]  FAILED" "warning"
            PRINT "Auto completion will not work because destination doesn't exist: [${_acdest}]. Make sure the destination directory is valid and bash-completion is installed. After that, repeat the installation process if bash completion is desired." "warning"

            local _uname_s=
            _uname_s=$(uname -s)
            if [ "$_uname_s" = "Darwin" ]; then
                PRINT "Ah! I noticed you are running on Darwin. Take the following hint:"
                PRINT "brew install bash-completion && ./space /install/ -- \"/usr/local\" \"/usr/local/etc/bash_completion.d\""
                PRINT "Now relog on the terminal in order to have the new auto completion loaded."
            fi
        fi
    fi
}


# Disable warning about indirectly checking exit code
# shellcheck disable=2181

SPACE_UNINSTALL()
{
    # External
    # shellcheck disable=2034
    SPACE_DEP="PRINT"
    # shellcheck disable=2034
    SPACE_ENV="AC_PREFIX BIN_PREFIX"

    local _find_space=
    _find_space=$(which space 2>&1)
    if [ -z "${_find_space}" ]; then
        PRINT "Failed to find Space installed on the system. Either not installed or missing on PATH." "warning"
    else
        local _uname_s=
        _uname_s=$(uname -s)
        local _find_ac=${AC_PREFIX}
        local _find_man=
        _find_man=$(man -w space 2>&1)

        # If man didn't work, look for known locations
        if [ "$?" -gt 0 ]; then
            local _man_file_name="space.1"
            _find_man=${BIN_PREFIX}/share/man/man1/${_man_file_name}
            if [ ! -f "$_find_man" ]; then
                _find_man=${PREFIX-}/share/man/man1/${_man_file_name}
                if [ ! -f "$_find_man" ]; then
                    PRINT "Failed to retrieve man page location for \"$_man_file_name\"" "warning"
                    _find_man="$_man_file_name"
                fi
            fi
        fi

        if [ "$_uname_s" = "Darwin" ]; then
            _find_ac="/usr/local/etc/bash_completion.d"
        fi
        PRINT "In order to uninstall Space, remove the following files: \"${_find_space}\" \"${_find_ac}/space\" \"${_find_man}\""
    fi
}

