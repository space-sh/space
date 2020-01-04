# Space - Change log

## [current]

+ Add runtime variable `${CWDNAME}` as top level directory from where _Space_ was invoked

* Improve documentation formatting

* Improve command line arguments security by adding `_filter` step

* Improve quicksort call to contain fixed locale setting to guarantee traditional sort order

* Change default log settings to disable colors when `stderr` is not terminal

* Change `_dimensions_fill` from `0-3` to `2-3`

* Change "Compiling app..." output to only appear when debug level is set

* Change preprocess variable `@{CWD}` to `@{DIR}`

* Change default log settings to only report success on debug level for when exiting _Space_ apps

* Change `PRINT` to mute function name in output

* Fix typo in documentation

* Fix bug when returning error `>1` always exiting as `1`

* Update textual header comments

* Update copyright information

- Remove special notice tag from documentation

- Remove runtime variable `${DIR}`


## [1.2.1 - 2018-01-19]

- Remove test case for installer script


## [1.2.0 - 2018-01-19]

+ Add `-L` option

+ Add additional error checking to installer

+ Add `$@` arguments when calling main function of exported script

* Update default _gitlab.com_ list to include _web3-sh_

* Optimize `match_node` for speed

* Update installer to remove downloaded _Space_ package

* Change installer shebang line replacement to work on simpler `sed` implementations

* Change regular expressions to expand Bash compatibility (includes SailfishOS support)

* Update debug output

* Change cache behavior to better handle file permissions

* Change install warning messages to explicitly mention auto completion feature is optional

- Remove constraint that prevents `RUN` to be set together with `RUN_ALIAS`


## [1.1.0 - 2017-10-04]

+ Add `${DIRNAME}` variable to _YAML_ preprocess step

+ Add `${RUN_ALIAS}` to be inherited in _YAML_ structure

+ Add maximum number of `RUN_ALIAS` iterations to `exec_dimensions`

+ Add empty default value for `RUN` variable (fixes a case of undeclared variable)

+ Add ability to set preprocess UPPER CASE variables from nested scopes

* Update man pages

* Update `-h` options list

* Update `-h` options description

* Fix bug about trailing comma on `-s "sudo,"` case

* Update `-s` help text

* Change `${value}` to `${_value}` to prevent collision with user variables

* Fix bug about two dimensions

* Fix bug in `PRINT` that would access unbound variable in anonymous functions

* Fix unbound variable error for `-E` option

* Update documentation

* Update cache format

* Improve `@include` path searching

* Improve `-m` path searching

* Update error messages to be more descriptive

* Fix a bug in variable escaping during execution


## [1.0.0 - 2017-08-28]

+ Release major version


## [0.15.0 - 2017-08-11]

* Fix bug about wrongly entering shebang mode when the second argument happens to also be an existing filename

* Fix bug about missing to escape variable names given on cmd line as arguments

## [0.14.0 - 2017-06-11]

+ Add support for arguments constraints in `SPACE_SIGNATURE`

+ Add `-E` flag for loading environment files

+ Add `completion_cache` level to dynamic completion

+ Add a wrapper to output script in `main` function to defer execution until last line

+ Add namespaces support for functions `_push` and `_pop`

+ Add `SPACE_SUDO` for turning `su` and `sudo` into wrappers

+ Add ability to inherit `RUN` in _YAML_

+ Add ability to inherit `SPACE_REDIR` in _YAML_

+ Add ability to inherit `SPACE_ARGS` in _YAML_

+ Add control for storing sub shell `PID` to properly terminate _Space_ when killed while in background

+ Add install check for GUI before executing

* Update packer module man page exporter to use environment variables for customization instead of command substitution

* Fix auto completion cache file to have owner only permissions

* Fix miscellaneous bugs in completion script

* Fix erroneous return value in `get_module_latest_stable_version`

* Fix erroneous return value in `check_minimum_requirements`

* Fix bug appending `SPACE_WRAP` == `!unset`

* Fix miscellaneous access to unbound variable data

* Change `update_module` function to continue after version checkout failure

* Fix bug about `SPACE_SIGNATURE` missing validation for wrapper functions

* Make `SPACE_SIGNATURE` mandatory arguments defaultto `:min=1`

* Rewrite `_escape` function to support infinite levels of escaping

* Change dumped scripts to use `/usr/bin/env` as _shebang_

* Change `PRINT` function to not use subshells when `stderr` is not a terminal

* Change `PRINT` function to not use colors when `stderr` is not a terminal

* Change _Space_ status print after script completion to only use colors when outputting to a terminal

* Fix a bug in exit status error when redirecting stderr to non-tty

* Change `_RUN_` substitution tag prefix to allow for sub processing

* Update list of friendly shellcheck warnings

* Split up single-line local variables declaration to prevent masking return values

* Adapt command data wrapping to work on Bash 3.2.x

* Update export header

* Update build process to use Alpine 3.6

- Remove unused function: `_runinfo`

- Remove local cloning of modules which has been superseded by modules versioning

- Remove unnecessary `$` for variables in arithmetic operations

- Remove exit traps and wait process when exporting


## [0.13.0 - 2017-04-13]

+ Add node dimensions order

+ Add preprocess `@include` functionality from within multilines

+ Add automatic injection of default namespaces when no namespaces are provided

+ Add `_dimensions_fill` functionality

+ Add `_filter` function

+ Add a check to protect against using reserved `EOF` tag

+ Add a check before piping HTTPS modules into `tar` command

+ Add notion of minimum requirements for modules

+ Add _Space_ option `-Z` for ignoring requirement checks

+ Add `/manuals` directory for manual pages

+ Add new documentation to `/doc` directory

+ Add _Space_ version to module ban server check

+ Add `@dotdot` preprocessor directive

+ Add condition to disallow inline list and object declaration in _YAML_ files

+ Add `urlencode` pass for `wget` _POST_ data in banlist function

+ Add escaping for special characters in `split_args` function

+ Add `-|` token for `SPACE_ARGS` to mute command line arguments

+ Add `-u` option for updating

+ Add `-Q` option for querying _SpaceGal_ service status

+ Add `-h` info for dimensions two and three

+ Add MODULE_REQUIREMENT and MODULE_STABLE file name definitions

* Rename `push` to `_push`

* Rename `pop` to `_pop`

* Change preprocess output to include a divider between multiple namespaces

* Fix duplicated node combo bug

* Update help usage string to not list old `-c` option

* Change `_namespaces` from array to object keys: `second` and `third`

* Bump `_CACHE_FORMAT`

* Fix a bug for when `RUN` is followed by undeclared variable

* Fix preprocess stage to reset `@include` argument variables properly

* Fix to allow better preprocess variable substitution

* Fix to allow more complex preprocess `-p` variables to be set

* Change node listing output to be more descriptive

* Change `-S` option to force fallback to HTTPS modules

* Fix a bug when escaping quoted variables

* Fix bug that causes unparsable arguments not to exit properly

* Change stable.txt format to consider major _Space_ version

* Fix wrong warning message during _Space_ replacement installation

* Fix bug about trailing spaces for quoted _YAML_ environment variables

* Fix bug about extracting functions from modules

* Improve balancing of `SPACE_WRAPARGS`

* Change `SPACE_OUTER` to work as `SPACE_WRAP`

* Bump cache format version

* Fix bug that would cause `SPACE_SIGNATURE` to not allow trailing comments

* Improve auto completion

* Fix bug when referencing hidden sub nodes from command line

* Change empty environment node variables to be implicitly set to itself

* Change `-M` loading to happen after `-m`

* Change `SPACE_EXIT` to `SPACE_ASSERT_EXIT`

* Change `SPACE_SILENT` to `SPACE_MUTE_EXIT`

* Change `requirement.txt` to `space-requirement.txt`

* Change `stable.txt` to `space-module.txt`

* Fix `SPACE_WRAP` to handle correctly when defined in _YAML_ multiple times

* Update `-U` switch to continue to the next module on error

- Remove spacedoc `/module/` node

- Remove `SPACE_OUTERENV`

- Remove `SPACE_OUTERDEP`


## [0.12.0 - 2017-01-26]

+ Add trap for `_split_args` to catch syntax errors

+ Add `_BASHBIN` global

+ Add `SPACE_BUILD_{ENV,DEP,ARGS}` Space headers

+ Add `YIELD` function

+ Add better error handling for `_split_args`

+ Add `SPACE_BUILD` variables to wrapper functions

+ Add slashes constraint for preprocessing node filters

+ Add `@source` functionality to preprocessing

+ Add better help for `-M` option

+ Add support for multiple `@clone` on same node

+ Add support for multiple `@source` on same node

* Change `printf` subshells to `printf -v` instead

* Fix a bug in `_cmd_export_vars`

* Change build functions to run in restricted Bash subshells

* Rename `clone` to `_clone`

* Change _YAML_ parser to read and count empty lines

* Change source module file behaviour to not source file at all

* Change all printf calls for color and style to go to stderr

* Change `_transform_to_yaml` to output proper multilines instead of `\n\n`

* Change `SPACE` header variables to be evaluated one at a time

- Remove `_split_quoted` function

- Remove `@assert`

- Remove `@assign`


## [0.11.0 - 2017-01-22]

+ Add build node to base _Space_ module

+ Add build step for generating _Space_ Docker container image

+ Add support for accessing CMDENV in wrapper functions

+ Optimize overhead caused by PRINT in export status check code

+ Add a break on error when chaining commands evaluate, during `cmd_extract`

+ Add SPACE_CMDOUTERARGS

+ Add support for modules cloning and updating latest stable version by default

+ Add SPACE_LOG_ENABLE_COLORS environment variable setting

+ Add SPACE_LOG_LEVEL environment variable setting

+ Add more descriptive update messages (-U switch)

+ Add `#!` shebang line support

+ Add `SPACE_WRAPARGS` variable

+ Add support for isolating variables when applying environment variables

+ Add escaping for variables passed to `-e` option

+ Add SPACE_OUTERENV to the list of Space header variables

+ Add SPACE_OUTERDEP to the list of Space header variables

+ Add a check to force SPACE_ variables to always wrap values inside double quotes

* Fix a bug that causes sourced files not to quit on syntax error

* Change error messages around SPACE header variables to be more descriptive

* Fix bugs in dependency inclusion of functions

* Fix reponame splitting for every dot, which causes module versions that include a dot not do be properly identified

* Change `SPACE_FNNAME` to `_SPACE_NAME`

* Change `SPACE_CMDOUTERENV` to `SPACE_OUTERENV`

* Change `SPACE_CMDOUTERDEP` to `SPACE_OUTERDEP`

* Change `SPACE_CMDOUTERARGS` to `SPACE_OUTERARGS`

* Change `SPACE_CMDOUTER` to `SPACE_OUTER`

* Change `SPACE_CMDENV` to `SPACE_ENV`

* Change `SPACE_CMDDEP` to `SPACE_DEP`

* Change `SPACE_CMDARGS` to `SPACE_ARGS`

* Change `SPACE_CMDWRAP` to `SPACE_WRAP`

* Change `SPACE_CMDREDIR` to `SPACE_REDIR`

* Change `SPACE_CMD` to `SPACE_FN`

* Change SPACE_DEP to inherit its value from YAML

* Change SPACE_ENV to inherit its value from YAML

* Change variable `CMD` to `RUN`

* Change variable `CMDREDIR` to `SPACE_REDIR`

* Change variable `CMDOUTER` to `SPACE_OUTER`

* Change variable `CMDDEP` to `SPACE_DEP`

* Change variable `CMDWRAP` to `SPACE_WRAP`

* Change variable `CMDOUTERARGS` to `SPACE_OUTERARGS`

* Change variable `ALIAS` to `RUN_ALIAS`

* Change variable `CMDEXIT` to `SPACE_EXIT`

* Change variable `CMDSILENT` to `SPACE_SILENT`

* Change variable `CMDARGS` to `SPACE_ARGS`

* Rename `_friends` functionality to `_dimensions`

* Fix bug that prevents SPACE_ENV to be unset

* Fix bug about bash3 referencing empty arrays

- Remove `tput` program usage

- Remove `SUBST` function in favor of the string module

- Remove `-c` option `CMDOVERRIDE`


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

