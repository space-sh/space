# Space - Change log

## [current]

## [0.10.0] - 2016-12-14

+ Add spacedoc under ./tools as a _Space_ module for exporting code comments to formatted Markdown and HTML files.

+ Add code documentation as part of the release files list (packer module)

+ Add support for hostnames (without punctuation) to be specified as a module Git URL

+ Add undocumented command switches -S, -V and -X to help usage text (-h switch)

+ Add an extra check when updating modules for skipping the ones which are in "detached HEAD" state i.e. custom commit hashes or tags. Modules with a custom branch set are still updated like regular modules.

+ Add auto-generated _Space_ man page as part of the release package (packer module)

+ Add _Space_ man page as part of the install process

+ Add man page to the list of installed files to remove when running /uninstall/ base _Space_ module

* Change packer module file to be recognized as shell instead of Bash

* Change base _Space_ module file to be recognized as shell instead of Bash

* Fix a bug that causes `space -U <module>` to return exit status code 1

* Change error messages when loading modules to be more descriptive

* Fix an issue that causes the wrong module being cloned when the protocol is set as part of a malformed Git URL

* Fix an issue that causes `space -U <expression>` not to work under BSD

* Fix a bug that prevents from specifying commit hashes and branch/tag names when cloning a module

* Change module repo names to be stored as `<module>` instead of `<module>.git` when the ".git" extension is provided as part of the Git URL

* Fix an issue that causes cloning a repository without explicitly providing ".git" as part of the repo name to fail in some circumstances


## [0.9.0] - 2016-11-30

First public version

