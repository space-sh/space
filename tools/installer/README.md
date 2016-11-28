Space Installer
---------------

Please note that this tool is intended to be used as base template installer for a given version release. All the steps required to build an installer script based on this template can be found on the _Configuration_ section below.

## Configuration

1. Package version must be configured according to release version
2. Package hashes must be correctly specified according to Packer generated .sha and .sha256 information
3. Download base URL must be correctly defined for curl download to work

## Running

It is possible to run the install.sh script from the ./release/<version> folder, after running the Space Packer tool and having generated all the necessary release files.

