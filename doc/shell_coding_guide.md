# Shell coding and style guidelines

Ash, dash, bash and ksh compatible guide.

Code is expected to be presented in the following order:
1. Header
2. Global state and constants
3. Functions
4. Main entrypoint function, when applicable


## Formatting
General rules for file and code formatting.

### File name
File name should have the ".sh" extension for POSIX-compliant shell scripts (dash compatible code) and ".bash" for Bash-only shell scripts.

### Executable permissions
All shell script programs should have executable permissions set, except for libraries and modules, which are expected not to have a program entrypoint, main or code outside of functions.

### Column size
Maximum line length is encouraged to be around 80 and 100 characters. No hard limit.

### Indentation
Four spaces.

Vim settings:  
```
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
```

### Trailing spaces
Avoid adding unneeded spaces at the end of line.

Vim settings:
```
set list
set listchars=tab:▸\ ,trail:.
```

### Conditional and loops
Do `if [...]; then` and `; do` on the same line as the initial conditional.
Multiple conditional statements should be distributed in multiple lines for clarity.


## Organization
A given script is expected to have a presentation header and a set of variables followed by a set of functions.

### Header
A header is expected to always provide a shebang line and a presentation comment block.

#### Shebang line
Expected to be the first line of any given script.
Always prefer `#!/usr/bin/env <shellname>` for cross-platform support.
Use `#!/usr/bin/env sh` for POSIX-compliant scripts or `#!/usr/bin/env bash` for Bash-only scripts.

#### Copyright notice and license terms
This section is optional and usually include a list of authors, copyright holders and general license terms.

#### Program comments
General program description is advised, with optional usage and instructions information.

### Variables
Global variables are referred to the ones that are not declared inside a function.

#### Naming
Always start with an underscore and split words with subsequent underscores. Variables should be lower case, except for global variables and constants.

#### Comments
Always add comments for global variables and constants.
Examples:
```
# Set to "1" to allow this and that
# and also that other thing
_GLOBAL_LIKE_THIS="1"

_DONT_GLOBAL_LIKE_THIS="1" # Don't do this for globals

_my_function()
{
    _all_good_here="abc" # good "scoped" variable comment

    # another good "scoped" variable comment
    _another_example="1"
    ...
}

```

#### Constants
Use the `readonly` modifier for constant data.

#### Variable expansion
Always quote strings.

#### Environment variables
Never starts with an underscore. Always upper case, using underscores for splitting words.

#### Default values
Whenever relevant, have default values set. Example: `_HOST_PORT=${_HOST_PORT-80}`

#### Arithmetic expressions
Use `_count=$(( _count + 1 ))`.

### Functions

#### Naming
Function names should always be lower case. Private functions should start with an underscore.
Do not use "function" as it is an unneeded flourish.
Example:
```
example()
{
    #...
}

_example_usage()
{
    #...
}
```

#### Comments
Function description should be straight to the point, with optional usage instructions.
Implementation details should be closer to the implementation choices instead.
Example, parameters, expected environment variable and return values must be described whenever applicable.

```
###################
# FUNCTION_NAME
#
# This is a function description
# long description, multiple lines
#
# Example:
#   some data in here
#
# Parameters:
#   $1: user name
#   $2: a second parameter (optional)
#
# Expects:
#   PATH: an environment variable
#   TERM: expects that global term has been set to known value X or Y
#   GLOBAL_VAR: some global variable
#
# Returns:
#   0: on success
#   1: on file read error
#   2: no write permissions
#   128: unknown state
#
###################
```

#### Parameters
Use the `shift` keyword for accessing arguments. Using `shift` is less error-prone on function signature changes and mixes well when handling variable arguments i.e. `$@`.
As an added bonus, calling `shift` when accessing a missing parameter causes an error because `$# <= 0`. That catches missing arguments and malformed function calls.

#### Error checking and reporting
Error reporting and general user messages should always go to `stderr` (i.e. `>&2`), accompanied by relevant information and available state.
`:` can be used instead of true or as a style to set exit status code to 0.

#### Conditions
Avoid usage of `&& ||` construct as if it was `if then else`.
Always check for exit status code using `$?`, where applicable.
Use shorthand operators for testing string and conditions in general.
Example:
```
ìf [ -z "${my_str}" ]; then
    _strlen_is_zero
fi
```

#### Silence
Avoid polluting `stdout`. Prefer the default mode to be lean and add the ability to control a debug or verbose option in case the user wants more information. In that case, always send user-relevant information to `stderr`.

## Commands

### Command substitution
Use `$(command)` instead of \`command\` and always separate declaration from assignment.
Example:
```
_output=
_output=$(mycommand arg1 arg2)
```

### Pipelining
Prefer single line pipelines whenever possible. Consider splitting complex one-liners for the benefit of clarity.
Consider setting `set -o pipefail` whenever possible.

### printf versus echo
Prefer printf instead of echo for portability.

### command versus which
Use `command -v` instead of `which` for checking for a given program availability.

### . (a period) versus source
Use `.` instead of `source` for sourcing a file.

### eval
Use it with care.

### set
Useful `set -o` options:
- errexit: exit when a pipeline or compound command fails
- nounset: catches unset variables and parameters as errors during parameter expansion

### trap
Use with care.
Relevant traps for controlling exit: `SIGINT SIGTERM EXIT ERR`

## Bash-only language constructs

### local

### Arrays

### Regex

## Static analysis
Always perform static analysis of code on a regular basis.

### Checkbashisms
Run:
```
checkbashisms myprogram.sh
```

#### Download
https://launchpad.net/ubuntu/+source/devscripts/

### Shellcheck
Analysis against POSIX rules:
```
shellcheck --shell=sh myprogram.sh
```

Analysis against Bash-specific constructs:
```
shellcheck --shell=bash myprogram.bash
```

#### Download
https://shellcheck.net


## Testing
Testing is strongly encouraged and should always be provided in separate files inside a subdirectory (e.g. test/test_all.sh).


## Debugging
Bashdb can be used as a gdb-like debugger.

### Download
```
http://bashdb.sourceforge.net/
```

