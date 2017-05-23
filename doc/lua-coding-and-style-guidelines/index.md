---
prev: /shell-coding-and-style-guidelines/
prev_title: "Shell coding and style guidelines"
next: /glossary/
next_title: "Glossary"
title: Lua coding and style guidelines
weight: 800
giturl: gitlab.com/space-sh/space
editurl: /edit/master/doc/lua-coding-and-style-guidelines/index.md
icon: "<b>8. </b>"
---

# Lua coding and style guidelines
Some of the _Space_ native modules also have a Lua script inside of them. Here are the guidelines for writing Lua code.

## Formatting
General rules for file and code formatting.

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

## Organization
A given script is expected to have a presentation header, a list of required libraries and a set of global variables followed by a set of functions.

### Header
A header is expected to always provide a presentation comment block.

#### Copyright notice and license terms
This section is optional and usually include a list of authors, copyright holders and general license terms.

#### Program comments
General program description is advised, with optional usage and instructions information.

### Variables
Global variables are referred to the ones that are not declared inside a function.
Prefer local variables whenever possible.

#### Naming
Split words with underscores. Variables should be lower case, except for global variables and constants, which should always be all upper case.

#### Comments
Always add comments for global variables and constants.
Examples:
```lua
-- Set to 1 to allow this and that
-- and also that other thing
GLOBAL_LIKE_THIS = 1

DONT_GLOBAL_LIKE_THIS = 1 -- Don't do this for globals

function my_function()
{
    local all_good_here = "abc" -- good "scoped" variable comment

    -- another good "scoped" variable comment
    another_example = 1
    ...
}
```

#### Default values
Always initialize variables.

#### Binary operators
Add a single space between assignment, comparison and arithmetic operators. Example:
```lua
var1 = 1
var2 = var1 + 1
```

#### Tables
Prefer describing a table using the constructor syntax. Example:
```lua
local my_table =
{
    name = some_name,
    info = an_info,
    desc = another_field
}
```

#### Fields
Prefer accessing fields using the dot operator:
```lua
local name = my_table.name
local info = my_table.info
local desc = my_table.desc
```

### Functions

#### Naming
Function names should always be lower case. Private functions should start with an underscore.
Example:
```lua
function example()
{
    -- ...
}

function _example_usage()
{
    -- ...
}
```

#### Comments
Function description should be straight to the point, with optional usage instructions.
Implementation details should be closer to the implementation choices instead.
Example, parameters, expected global variables and return values must be described whenever applicable.

```lua
--[[
  function_name

  This is a function description
  long description, multiple lines

  Example:
    some data in here

  Parameters:
    1: user name
    2: a second parameter (optional)

  Expects:
    PATH: an environment variable
    TERM: expects that global term has been set to known value X or Y
    GLOBAL_VAR: some global variable

  Returns:
    0: on success
    1: on file read error
    2: no write permissions
    128: unknown state

--]]
```

#### Parameters and the stack

#### Error checking and reporting
Error reporting and general user messages should always go to `stderr`, accompanied by relevant information and available state.

#### Conditions
Always check for exit status code of other functions and programs.

#### Silence
Avoid polluting `stdout`. Prefer the default mode to be lean and add the ability to control a debug or verbose option in case the user wants more information. In that case, always send user-relevant information to `stderr`.

## Commands

### eval
Use it with care.

## Static analysis
Always perform static analysis of code on a regular basis.

### lglob
Detects undefined variables. Works for _Lua_ 5.1 and 5.2.

#### Download
https://github.com/stevedonovan/lglob

### strict.lua
Checks for undeclared global variables.

#### Download
This ships with Lua source code in `etc/strict.lua`.

## Testing
Testing is strongly encouraged and should always be provided in separate files inside a subdirectory (e.g. `test/test_all.lua` or `test_all.sh`).
