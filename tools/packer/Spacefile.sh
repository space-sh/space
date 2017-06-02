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
# Space Packer tool
#

# Check if command is available
SPACE_PACKER_CHECK_AVAILABLE()
{
    local _cmd="$1"
    if ! command -v "$_cmd" >/dev/null; then
        PRINT "Command [%s] is missing! " "$_cmd" "warning"
        return 1
    else
        return 0
    fi
}

SPACE_PACKER_MAKE()
{
    # shellcheck disable=2034
    SPACE_DEP="PRINT SPACE_PACKER_CHECK_AVAILABLE _EXPORT_MARKDOWN _EXPORT_MAN"
    # shellcheck disable=2034
    SPACE_ENV="RELEASE_FILES"

    local _files=''
    local _version=''
    local _package_name=''
    local _release_name=''
    local _release_dir=''
    local _has_gnu_md5=-1
    local _has_gnu_sha1sum=-1
    local _has_gnu_sha256sum=-1

    #
    # Check dependencies
    SPACE_PACKER_CHECK_AVAILABLE "gpg" || exit 0

    SPACE_PACKER_CHECK_AVAILABLE "md5sum"
    if [ "$?" -eq 0 ]; then
        _has_gnu_md5=1 
    else
        PRINT "Falling back to non-GNU md5" "warning"
        _has_gnu_md5=0
    fi

    SPACE_PACKER_CHECK_AVAILABLE "sha1sum"
    if [ "$?" -eq 0 ]; then
        _has_gnu_sha1sum=1 
    else
        PRINT "Falling back to non-GNU shasum" "warning"
        _has_gnu_sha1sum=0
    fi

    SPACE_PACKER_CHECK_AVAILABLE "sha256sum"
    if [ "$?" -eq 0 ]; then
        _has_gnu_sha256sum=1
    else
        PRINT "Falling back to non-GNU shasum" "warning"
        _has_gnu_sha256sum=0
    fi

    SPACE_PACKER_CHECK_AVAILABLE "tar" || exit 0

    #
    # List files to tar
    _files="$RELEASE_FILES"

    #
    # Define version
    _version=$(./space -V 2>&1)

    #
    # Get only the version number
    for token in $_version; do
        _version=$token
    done

    #
    # Generate man page on current directory
    local _space_man_input_file_path="${PWD}/manuals/space.md"
    local _space_man_expected_output_file_path="${PWD}/space.1"
    # shellcheck disable=2034
    ORGANIZATION_NAME=$(space -V 2>&1)
    # shellcheck disable=2034
    DATE_NOW=$(date +%Y-%m-%d)
    _EXPORT_MAN "$_space_man_input_file_path"

    #
    #Build package name
    _release_name="space-${_version}"
    _package_name="${_release_name}.tar.gz"

    #
    # Make release dir
    _release_dir="./release/${_release_name}"
    mkdir -pv "$_release_dir"

    #
    # Generate compressed tar
    # shellcheck disable=SC2086
    tar cvzf "${_release_dir}/${_package_name}" $_files
    if [ "$?" -gt 0 ]; then
        PRINT "Failed to create tar file: $_package_name" "error"
        exit 1
    fi

    #
    # Generate hashes
    # Note: make sure we change dir to release before generating hashes
    cd "$_release_dir"

    # SHA1
    if [ "$_has_gnu_sha1sum" -eq 1 ]; then
        sha1sum "${_package_name}" > "${_release_name}.sha"
    else
        shasum -a 1 "${_package_name}" > "${_release_name}.sha"
    fi

    # SHA256
    if [ "$_has_gnu_sha256sum" -eq 1 ]; then
        sha256sum "${_package_name}" > "${_release_name}.sha256"
    else
        shasum -a 256 "${_package_name}" > "${_release_name}.sha256"
    fi

    # MD5
    if [ "$_has_gnu_md5" -eq 1 ]; then
        md5sum "${_package_name}" > "${_release_name}.md5"
    else
        md5 "${_package_name}" > "${_release_name}.md5"
    fi

    # Generate customized version installation file
    sed "/^_version=/s/=.*/=\'${_version}\'/" "../../tools/installer/install.sh" > "install-${_version}.sh"
    sed -i.bak "/^_package_sha1=/s/=.*/=\'$(cat "${_release_name}.sha" | cut -d ' ' -f 1)\'/" "install-${_version}.sh"
    sed -i.bak "/^_package_sha256=/s/=.*/=\'$(cat "${_release_name}.sha256" | cut -d ' ' -f 1)\'/" "install-${_version}.sh"
    rm "install-${_version}.sh.bak"

    #
    # Generate code documentation
    local _space_file_path="${PWD}/../../space"
    local _doc_expected_output_name="space_doc.md"
    local _doc_output_name="space-${_version}.md"

    # Export space_doc.md
    # shellcheck disable=2034
    GENERATE_TOC=1
    _EXPORT_MARKDOWN "$_space_file_path"
    if [ ! -f "$_doc_expected_output_name" ]; then
        PRINT "Failed to generate documentation for $_space_file_path" "error"
        exit 1
    fi

    # Change the very first line of text
    local _first_line="# Code documentation for Space ${_version}"
    sed -i.bak "1s/.*/$_first_line/" "$_doc_expected_output_name"

    # Rename documentation
    PRINT "Renaming documentation to $_doc_output_name"
    mv "$_doc_expected_output_name" "$_doc_output_name"

    # Cleanup
    if [ -f "./${_doc_expected_output_name}.bak" ]; then
        rm "./${_doc_expected_output_name}.bak"
    fi

    # Cleanup generated man page
    if [ -f "${_space_man_expected_output_file_path}" ]; then
        rm "${_space_man_expected_output_file_path}"
    fi

    #
    # Sign package
    gpg --armor --output "${_package_name}.asc" --detach-sig "$_package_name"


    #
    # Ready
    if [ "$?" -eq 0 ]; then
        PRINT "Release package has been created at $_release_dir" "ok"
    else
        PRINT "Failed to sign the package. Generated files can still be found at $_release_dir" "error"
    fi

}
