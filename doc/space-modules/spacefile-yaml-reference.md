---
prev: ../space-variables/
prev_title: "Space variables"
next: ../modules-versioning/
next_title: "Modules versioning"
title: Spacefile YAML reference
toc: true
weight: 507
---

# Spacefile YAML reference

The _YAML_ syntax supported by _Space_ is a subset of the standard. A node without any value is ignored, except for `_env` variables which then are treated as empty (re)declarations of the variable.  
Nodes right below an `_env` node are subject to special treatment and their values are evaluated by Bash,  
while other nodes are not evaluated with variable substitution, etc.  

To set a node to an empty string:  

```yaml
   _env:  
       - varname: ""  
```  
however, the following:  
```yaml
   _env:  
       - varname:  
```  
Will implicitly result in:  

```yaml
   _env:  
       - varname: ${varname-}  
```  
which is useful for making sure that the variable is declared,  
but also not overwriting it.

To unset an `_env` variable use `!unset`:  

```
   _env:  
       - varname: !unset  
```  

This will have _Bash_ unset the `varname` variable.  

One can also provide meta data for the variable by doing:  

```yaml
   _env:  
       - varname:  
            value: Some value  
            title: This is a special variable  
            desc: |  
                It has such meaning, I can't even begin  
                to explain its importance.  
```  

Using the object definition of an environment variable gives you
abilities to attach meta data to the variable for describing it.
Also this is useful for auto completion, more on that later.  
If `value:` node is left out, the variable will implicitly be
assigned it self as default value, as:  

```yaml
   _env:  
       - varname:  
            value: ${varname-}  
```

Node environment variables which are wrapped in single quotes will not be _Bash_ evaluated at the parse stage.
The quotes are automatically removed.

Node environment variables which are wrapped in double quotes will be _Bash_ evaluated at the parse stage, just as values that are unquoted.
The quotes are automatically removed.
When arguments and commands are wrapped inside other commands, their escape levels of double quotes and dollar signs are automatically increased.

Using environment variables in _YAML_ will be properly substituted, if not escaped. However subshells `$(...)` are not allowed and will be filtered out.

#### Strings and quoting
Unquoted and double quoted values will be parameter expanded by _Bash_ during parsing, while single quoted lines will be treated as raw strings and evaluated later, at run time.  

The following node's value will be parameter expanded by _Bash_ during _YAML_ parsing:  

```yaml
_env:
     - key: "$USER"
```  

Meaning that `key` will immediately be set with the current username given by the environment.  
In the following node the second `$USER` will not be expanded immediately during _YAML_ parsing:  

```yaml
_env:
     - key: "YAML was processed by: $USER, following user at run time is: \$USER."
```  

Note the escaped dollar sign, so it does not evaluate during _YAML_ parsing step.

This other example on the other hand will be read as a raw string, since it is single quoted:  

```yaml
_env
     - key: '$USER'
```  

It will be processed later at run time.  

Other examples:  
```yaml
_env:
    - key1: Regular string can do ${USER}  
    - key2: "Escaped Regular string can do ${USER} and \"${USER}\""  
    - key3: 'Single escaped string will not expand ${USER}'  
```

Multiline values must start with a single `>` or `|`. Using a `>` will collapse newlines into spaces, while using a `|` will preserve newlines. If the `>` or `|` is immediately followed by a `-`, then there will be no trailing newline after the last row.

If the first line begins with a single quote `'`, then the last line must also end with a single quote, and then variables will not get expanded by _Bash_ while parsing.

```yaml
_env:
     - key1: |  
             Multiline  
             string,  
             with new lines kept.  
             Also last line ends with \n  
  
     - key2: |-  
             Multiline  
             string,  
             with new lines kept.  
             Thanks to '-' this line does not end with \n  
  
     - key3: >  
             These lines  
             will be one  
             one long line,  
             where each line will be  
             space separated. Also the single line will have \n  
  
     - key4: >-  
             These lines  
             will be one  
             one long line,  
             where each line will be  
             space separated. But the single line will not have \n thanks to '-'  
  
     - key5: !nospace >  
             Now these lines  
             will be joined  
             but with no spaces in between!  
             But line will end with \n  
  
     - key6: !nospace >-  
             And these lines  
             will be joined  
             also with no spaces in between!  
             But line will not end with \n thanks to the '-'.  
  
     - key7: |  
             ${another_key}Another line  
             Yet another line here.  
   
     - key8: |  
          Right now user is: $USER.  
          But at run time user would be: \$USER  
```  

Multilines can also do variable expansion just as regular lines.  
They can also start and end with single (or double but that is same as no) quotes.  

```yaml
_env:
    str: |  
        'Multiline  
        within single  
        quotes does not expand $USER at parse time.'  
```

To add empty lines within a multiline string we must have spaces as indentation (here shown with dots), this is necessary
due to restrictions in the _Space_ YAML parser.  

```
_env:
    str: |  
        Multiline  
........  
        With some empty lines  
        Thanks to the spaces  
........  
........  
        Thanks!  
```


#### Lists and associative arrays
Note that nodes and their values that or not `environment variables`, that is, not right below an `_env` node
are not evaluated, stripped of quotes etc.

A node can have child nodes, and then it becomes an associative array.  

```yaml
   node:  
       keya: aaa  
       keyb: bbb  
```  

_Space_ YAML supports a kind of list, it is an associative array with numeric keys. When fetching all keys for a list the key names are guaranteed to come sorted so the order of the list is preserved if keys are numbers.  

```yaml
   node:  
      0: first item  
      1: second item  
```  

Which is the same as:
```yaml
   node:  
      - first item  
      - second item  
```  

_Space_ does not support inline lists or objects, such as:  
```yaml
    node: [1,2,3,4]
    node: {"a":1, "b":2}
```
Such an entry will throw an error and _Space_ will exit.

#### Special keys
All nodes with names beginning with an underscore are treated as hidden nodes and cannot autocomplete from the command line. They also might have special meaning to _Space_.  
Also when doing regular expressions on node targets, underscored target names are ignored, if the regular expression pattern does not use underscore.  

This will ignore node names beginning with underscore:
```sh
$ space "/.*/"
```  

This will include node names beginning with underscore or no underscore:
```sh
$ space "/_?.*/"
```  


* `_info`:
    Used purely for information and documentation about a node.

```yaml
   nodes:  
       my1:  
           _info:  
               title: This is my node no 1  
               desc: |  
                   Let's have a  
                   multiline description  
                   about it.  
```

* `_env`:
    List of variables to set below a node. Variables could reference other variables.
    Referenced variables must have been set on a node above or if on the same node then a sub `_env` is necessary for that dependent variable.

```yaml
   nodes:  
       _env:  
           - TEXT: text about something  
       my1:  
           _env:  
               - A: some $TEXT  
               - B: A is: $A  
```


#### Preprocessor
Preprocessing variable assignments, usage and directives:

* `@{DIR}`:  
Variable containing the current processed _YAML_ files directory.

* `@{CWD}`  
Variable containing the directory from where _Space_ was invoked.

* `@{PARENT}`  
Variable containing the current parent node name.
For list items, it is the list objects parent node name.

* `@{PARENTPATH}`  
Variable containing the full current parent node path.
For list items, it is the list objects parent node path.

* `@{varname}`  
User defined variable.

* `@varname`:  
If any value is defined, it will set `varname`.  
If followed by a trailing space variable will be set to empty.  
If no value is defined nor is it followed by a trailing space it will unset `varname`

* `@varname:-`  
Any value will set `varname` only if it the variable is unset or empty

* `@varname:+`  
Append to `varname` if it already contains data

* `@{varname-default value if unset}` or `@{varname:-default value if empty}`:
Use `@{varname}` anywhere to have it substituted with the value of the variable.
Default value could be another variable from the preprocessor such as `@{var2}`.
Ex: `@{var1-@{var2}}`

##### Preprocessor keywords
The following keywords are functions and cannot be used as preprocessor variables:

* `@assert: nonempty @{variable}`:
Do nonempty assertion of space preprocessor variable expression.

* `@prompt: var1 Text to prompt user with`:
This will output the text and read input from `stdin` which will be stored in preprocess variable "var1".  
Use `@prompt:-` to only prompt if var1 is unset or empty.  
One exception happens when using `prompt` in the preprocessor: whenever preprocess output is cached, so will the prompted value be. The next time it runs the user will not be prompted because _Space_ will be running a cached version.  
Please refer to the caching options for controlling that behavior from the command line: `-C` option.  
A note of warning is that tab auto completion and `@prompt` shoudl generally not be used together since the prompt will get in the way of the completion process because it outputs to terminal and reads from stdin.

* `@cache: {0,1,2}`:
Force the caching behaviour of this YAML file. Could be useful to turn off caching when using `@prompt`, since prompted values are cached.  
A note of warning dough is that you should not turn off caching when using tab auto completion because the performance and responsiveness
will suffer greatly.

* `@clone: space-sh/ssh space-sh/docker`:
The clone directive exists for using another module.  
The `@clone:` keyword can be defined anywhere in the YAML structure. When using the `include` filters this feature can be leveraged to only clone modules as needed.
It is possible to specify multiple arguments in a single `@clone:` statement.  
Internally `@clone` translates to `_clone_source` in preprocessed _YAML_ and points to shell files to be sourced when the _YAML_ node is parsed.  
When cloning, one could specify a module version to use. For example:  
`@clone: mymodule:1.2.3` or `@clone: mymodule:master`  
If no version is specified, _Space_ will try to figure out what version to use according to _Space's_ own version.

* `@source: @{DIR}/file.sh @{DIR}/file2.sh`
Internally, this translates to `_source: ...` in preprocessed _YAML_ and will trigger the source action when the parsed node is loaded.

* `@debug: varname is: @{varname}`:
Output using "_debug" during preprocess stage, you need to use the -v4 flag to see the debug output.

* `@include: path/ssh.yaml|/some/node/(arg1 arg2)`:
Include the ssh.yaml file and filter on `/some/node`, also assign the preprocess variables `@{1}` and `@{2}` the values arg1 resp arg2. The arguments are space separated and optional. This is a very powerful construct and can turn configuration more dynamic.
The filter is also optional.  
To include from within the same file leave out the file name, as: `@include |/filter/.`  
Absolute paths are also allowed.  
Anything that is indented below the @include is treated as a sub-document that will get injected below every direct child node from the @include. Like a for loop.  

* `@dotdot: variable`:
Perform the equivalent of `cd ..` on the variable containing a node path.  

For each server, include all services:  
```yaml
@include: servers.yaml
	server: This is server @{PARENT}
	@include: services.yaml
```

A filter is ended with slash if the filter is for everything below that node, if the filter does not end with slash it means: **get the content of the node and below**. The most useful aspect of this is to dynamically build multiline strings. Examples:

Get the string value:  
```yaml
a: a string
A: >-
    @include: |/a
```

Get a list of strings using `.*`:  
```yaml
a:
    - a string
    - another string
A: >-
    @include: |/a/.*
```

* `@include:- file.yaml`:  
Adding the dash will ignore a missing _YAML_ file. Also its sub-document will be ignored.

* `@include: [username/]repo`:  
Instead of including file names you could name a module, then _Space_ will search for the right module and _YAML_ file to include.

* setting default values for unset/empty or unset:  
```yaml
@C: Is: @{var:-unset or empty}
@D: Is: @{var-unset}
```

* setting default value options if set:  
```yaml
@E: Is: @{t-@b}
```

* setting default value options if not unset or empty:  
```yaml
@E: Is: @{t:-@b}
```

* setting variables via the command line:  
It is also possible to set any preprocessor variables using `-pvarname=` via the command line.
These variables are saved with the cache and if they change or are not provided, the cache will be invalidated.

#### Internal environment variables 

* `CWD`:
The directory from where the user invoked _Space_.

* `DIR`:
The directory of where the sourced Bash file is located.
Use this as `_source ${DIR}/somefile.bash` in the module bash file header.

#### Examples

The following shows some Space variables in practice.

##### Setup a test Module
For `Spacefile.yaml`:  
```yaml
1:
    _env:
        - RUN: echo Hello World!

2:
    _env:
        - RUN_ALIAS: /1/

3:
    _env:
        - SPACE_MUTE_EXIT: 1
        - RUN: return 1

4:
    _env:
        - SPACE_ASSERT_EXIT: 1
        - RUN: return 1

5:
    _env:
        - SPACE_REDIR: "<somefile.txt"
        - RUN: wc -l

6:
    _env:
        - SPACE_ENV: "USER HOME=\${HOME}"
        - RUN: echo \$USER \$HOME

7:
    _env:
        - SPACE_ARGS: Hello -- Galaxy!
        - RUN_ALIAS: /1/

8:
    _env:

        - RUN: FUN1 -- going places

9:
    _env:

        - RUN: FUN2

10:
    _env:

        - SPACE_WRAP: FUN_WR
        - RUN: FUN1

11:
    _env:

        - SPACE_OUTER: FUN_OUT
        - SPACE_OUTERARGS: 3
        - RUN: FUN1 -- Hej!
```

and `Spacefile.sh`:
```sh
FUN1()
{
    echo "$@"
}

FUN2()
{
    SPACE_DEP="FUN3"

    FUN3 "Greetings from FUN2."
}

FUN3()
{
    echo "FUN3 saying: $*"
}

FUN_WR()
{
    SPACE_FN="FUN_WR_IMPL"
}

FUN_WR_IMPL()
{
    echo "I am a wrapped function. This is the number of bytes in the wrapped command:"
    echo "${RUN}" | wc -c
    echo "And this is the wrapped command I would run:"
    echo "${RUN}"
}

FUN_OUT()
{
    local n="${1}"
    echo "This outer function will run the same command ${n} times:"
    for i in $(seq 1 ${n}); do
        _RUN_
    done
}
```

##### Experimenting with the test nodes

Now it is possible to experiment with the test Module nodes. Experiment with the `-d` switch and observe how the exported code changes on each node, in particular in cases where external parameters affect code output.  
Some tests require extra steps. Check the following subsections for extra notes on tests that require extra steps.

###### SPACE_ENV
In the following example, "builduser" is the user name of the user who built the script and "mutable" signals that the HOME variable was evaluated in runtime.  

```sh
$ space -f Spacefile.yaml /6/ -d | USER=immutable HOME=mutable sh
builduser mutable
```  

When assigning values in build time, one should always quote the value, if it might contain any spaces, to prevent bad word expansion. The next example illustrates that `var3` might contain spaces, so it is quoted.  
```sh
SPACE_ENV="var1=nospaces var2=\"has spaces\" var3=\"${var3}\" var4=\"\${var4}\""
```  
An unescaped variable name will be evaluated on the spot in build time. However, it is possible to defer the evaluation until run time by escaping it as shown in `$var4` above.

In case automatic assignment is wanted, simply list the variable names:
```sh
SPACE_ENV="var1 var2"
```
These variables will be evaluated and assigned values after all modules have been parsed, so a variable that is `exported` early in this way will still get the value the variable has at the last stage.  
To force the evaluation directly assign the variable to itself as such:
```sh
SPACE_ENV="var1=\"${var1}\""
```
To avoid errors about undeclared variables and providing a default value, do:
```sh
SPACE_ENV="var1=\"${var1-${var2}}\""
```

###### SPACE_ARGS
Argument passing works as regular functions:
```sh
$ space /7/
Hello Galaxy!
$ space /7/ -- Universe!
Hello Universe!
```

###### SPACE_FN
In this example, `RUN` points to an actual module function.
```sh
$ space /8/ -d
...

$ space /8/
going places

$ space /8/ -- Going Places!
Going Places!
```

#### Bash auto completion
_Space_ supports the Bash auto completion implementation.  
To allow environment variables to be auto completed use the following definition:   

```yaml
_env: 
    - var1:
        value: ${var1-default value}
        values:
            - Value1
            - Value2
            - Value3
```

This will make it so that `space -e[tab]` will expand to `space -e var1=` and
`space -e var1=[tab][tab]` will list the three values provided.

Also auto completion on positional arguments is supported:   

```yaml
_env: 
    - SPACE_ARGS:
        value: -- ${SPACE_ARGS-default value}
        arguments:
            -
                values:
                    - A
                    - B
                    - Aaa
                    - AAa
                    - Ba
            -
                values:
                    - Arg2ThisIs
                    - Arg2ItIs
```

#### Bash dynamic auto completion
_Space_ has a very advanced auto completion system.  
Properly configured it can fetch auto complete alternatives from a Docker Engine
running on a machine behind a firewall that you need three SSH hops to reach. Really!

```yaml
_env: 
    - var1:
        value: ${var1-default value}
        completion: /list_all/
    - var2:
        completion: G
```

_env: 
    - SPACE_ARGS:
        value: -- ${SPACE_ARGS-default value}
        arguments:
            -
                completion: /list_all/
            -
                completion: /list_some/
```

Add the `completion` node which is the named of a node in the same namespace that
is to fetch the list of options. See the examples section for some nice examples.  
If `completion` is set to `G` then _Space_ will complete using file globbing.
