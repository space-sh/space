# Space - Change log

## [current]

+ Add spacedoc under ./tools as a _Space_ module for exporting code comments to formatted Markdown and HTML files.

+ Add support for hostnames (without punctuation) to be specified as a module Git URL

+ Add undocumented command switches -S, -V and -X to help usage text (-h switch)

+ Add an extra check when updating modules for skipping the ones which are in "detached HEAD" state i.e. custom commit hashes or tags. Modules with a custom branch set are still updated like regular modules.

* Update packer to include code documentation as part of the release files.

* Change packer module file to be recognized as shell instead of Bash

* Change base _Space_ module file to be recognized as shell instead of Bash

* Fix a bug that causes `space -U <module>` to return exit status code 1

* Change error messages when loading modules to be more descriptive

* Fix an issue that causes the wrong module being cloned when the protocol is set as part of a malformed Git URL

* Fix an issue that causes `space -U <expression>` not to work under BSD

* Fix a bug that prevents from specifying commit hashes and branch/tag names when cloning a module

## [0.9.0] - 2016-30-11

First public version

