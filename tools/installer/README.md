Space Installer
---------------

Please note that this tool is intended to be used as base template installer for a given version release. All the steps required to build an installer script based on this template can be found on the _Configuration_ section below.

## Configuration

1. Package version must be configured according to release version;
2. Package hashes must be correctly specified according to _Space Packer_ generated _.sha_ and _.sha256_ information;
3. Download base URL must be correctly defined for curl download to work.

## Running

It is possible to run the _install.sh_ script from the _./release/<version>_ folder, after running the _Space Packer_ tool and having generated all the necessary release files.

