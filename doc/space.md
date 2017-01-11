space(1) -- automation using Bash
=================================

## SYNOPSIS

`space` [`-f`|`m` namespace [`-M` modules] [`-ep` key=value] [`-c` cmd] [node] [`-a`]] [`-vkKCBX` value] [`-dlShg`] [`--` args]  
`space` [`-hV`]  
`space` `-U` [module]  

## DESCRIPTION
**SpaceGal shell**, also known as **Space**, is a non-intrusive automation tool with a very small footprint, perfect to use with and on constrained environments and devices. It loads and runs YAML and Bash files.  

A YAML file is parsed and may refer to Bash functions loaded from a Bash file. The YAML structure is referred to as "nodes", and a "node" could have Bash variables associated to it. A node could be executed if it has the environment variable CMD set. The CMD variable typically refers to a Bash function, or is a Bash snippet in itself. A node could have many environment variables attached to it. When executing a node that has many levels such as "/a/b/c/", all Bash variables in each level will be loaded, where the deeper levels override their parent levels.  
In short, the YAML structure sets up the environment and then execution is passed on to a Bash function that executes the actual task.  

**Space** only depends on Bash and its exported scripts only depend on POSIX shell, so it runs with any POSIX compliant shell (ash, dash or bash). It provides a built-in YAML parser and preprocessor which are used to build **Space Modules**. *Modules* are exportable user extensions that can include each other to be loaded and run by **Space** in a composable way. The execution can then be exported as a shell script, to be run directly or shared, all in a decentralized manner.  
Behind the scenes, Space Module is a Git repository which contains at least the file Spacefile.yaml, and most often also Spacefile.sh/.bash.  A user creating a YAML structure could clone and include modules into the YAML file, reusing them.

For more complex combinations of modules, there is also the concept of "Dimensions". **Space** can handle up to three dimensions. This is a cuboid X*Y*Z, where X, Y and Z are one or many nodes that will get run in combination.  
An example of that is X could be a list of "things" to operate on, Y could be one or more "operations" to apply to each thing and Z could be one or more "hosts" to where these things exist.  
The Z dimension nodes will typically provide an environment variable named CMDWRAP that would wrap the CMD inside another CMD, for example to run the given CMD on another host over SSH.  
Each Dimension could have its own Namespace or share Namespaces. A Namespace is a loaded YAML structure. **Space** could, from a given first and optional second dimension, fetch the second or third dimension.

When running **Space**, the following steps occur:  
  1. Resolve the target node path. Fetches and combines dimensions for combo nodes, if applicable.  
  2. Perform YAML preprocessing to resolve all the @-directives  
  3. Perform YAML parsing to prepare environment variables to the next stage  
  4. Set up environment variables  
  5. Look up the CMD environment variable and gets the executable string from the given Bash function to execute  


## OPTIONS

  * `-f` [Spacefile.yaml]:
        YAML file to load, relative or absolute path. Both `-f` and `-m` options define namespaces in where to look for nodes, for a given dimension of nodes. There can be maximum three namespaces and three dimensions. One namespace can have more than one dimension. Dimension two and three could be found from namespace one below the node in dimension 1.  
        If only one dimension is given Space looks below `node/_friends/second` for a space separated set of lists that makes up the second dimension.  
        The second dimension then uses second namespace if defined else first namespace.
        If two dimensions are given Space looks below `node/_friends/third` for a space separated list, each list object's "match" node is matched against the node in the second dimension, if match then the list below "nodes" makes up the third dimension.
        The third dimension then uses third namespace if defined else first namespace.  
        Defaults to: ./Spacefile.yaml.

  * `-m` [giturl/][username]/reponame:
        Module to run.  
        Direct access to run nodes in a module.  
        Modules are referenced as protocol://user@domain/username/reponame:commit, for example https://gitlab.com/space-sh/os:master  
        Only the Space specific user gitlab.com/space-sh could be denoted using only reponame, then username is set to space-sh and giturl is set to https://gitlab.com/.  
        All other users must specify domainname/username/reponame, for example ssh://gitlab.com/username/somemodule.  
        The protocol defaults to https.  

  * `-M` [giturl/][username]/reponame:
        Module to load e.g. "gitlab.com/blockie-org/amodule"  
        Clone and load modules. Separate multiple by space within quotes or use multiple -M switches, one for each module.  
        Usually used together with '-m' option to load a needed module for use with CMDWRAP environment variable.  
        Example: space -m dropalot -M ssh -e CMDWRAP=SSH_WRAP -e sshhost=111.222.123.4

  * `-e`  var=value:
        Environment variable to forcefully apply/overwrite before parsing the YAML.  
        Use one -e for each variable.  
        To unset a variable use -evar1='!unset'  

  * `-p` var=value:
        Preprocess variable to set before preprocessing.  
        Use one -p for each variable.  

  * `-c` value:
        Set the CMD environment variable just before running the cmd.  
        Overwrites the CMD variable set in YAML.  
        Could be used together with -m to run a Bash function in the module,
        or to use the environment of a target but swap out the CMD being run.

  * `-v` level:
        Set verbosity level: 0 = off, 1 = error, 2 = warning, 3 = info, 4 = debug.  
        Default level: 2. Outputs to stderr.

  * `-d`:
        Dry run. Will echo the Bash command line computed instead of running it.  

  * `-l`:
        List nodes. Do not run anything, only output the nodes matched.  

  * `-k` mode:
        Check modules against the ban list.  
        Valid modes: 0 = off, 1 = accept unknown modules but not banned modules, 2 = require module to be known and not banned.  
        Default mode: 1.

  * `-K` mode:
        Verify module Git HEAD signature using GPG. 
        Valid modes: 0 = off, 1 = accept moderate trust, 2 = only accept full trust signatures.  
        Default mode: 1.

  * `-S`:
        Allow HTTPS fallback for downloading modules using curl or wget when git is not available.  

  * `-h`:
        Help, show Space usage or help on specific node.  
        Node(s) Pattern of one or many nodes to run.  
        If no node path is given the root node "/" is implied.  
        If node path(s) are given but none matches then Space aborts.  
        A node pattern is defined after a namespace (-f/-m) and then belongs to that namespace.  
        Nodes support regular expressions to run multiple nodes in sequence.  
        Ex: "/west/.*" will match all nodes below /west/,
          "/we.*/ will match /west/ and /web/ nodes.  
        When using asterisk make sure you use quotes so that Bash will not expand that before passing it to Space as arguments.  
        /we{st,b}/ without quotes will get expanded by Bash as two arguments  
        /west/ and /web/ that are passed to Space, which is cool of that is what you meant.

  * `-V`:
        Show Space version information

  * `-a`:
        All. Adds a ".*" to the node it suffixes, to match all it's nodes below.

  * `-C` level:
        Set caching level: 0 = off, 1 = on, 2 = regenerate cache.  
        Default level: 1

  * `-B` mode:
        Set to mode=1 to force to run modules in Bash. Normally Bash dependency depends on module script files ending in .bash instead of .sh.

  * `-U`:
        Update module(s). Performs a Git pull on matched module(s) then quit.  
        Space will update repositories both in local space_modules and also in shared space_modules directories.  
        -U ""    means update all modules.  
        -U "ssh" means update gitlab.com/space-sh/ssh.  
        -U "gitlab.com/blockie-org/ssh" means update gitlab.com/blockie-org/ssh repository.  
        -U "space-sh/.*" means update every module for the space-sh user on gitlab.com.  

  * `-X` mode:
        Outputs debug information.
        Valid modes: 1 = preprocessed YAML result, 2 = YAML parsed to Bash, 3 = YAML loaded from Bash (retransformed), 4 = eval code
        Default mode: none

  * `-g`:
        Enable graphical user interface. 
        Default mode: disabled


## EXIT STATUS
Non zero on failure


## ENVIRONMENT
    The following environment variables are used and can be overwritten before starting **Space**:

### $SPACE_LOG_ENABLE_COLORS
Enables colored message output.
Default: 1

### $SPACE_LOG_LEVEL
Set level of logging in interval [0,5].
Default: 4

### $SPACE_MODULES_SHARED
The directory for shared resources i.e. modules.  
Default: ~/.space/space_modules


## YAML SYNTAX

The YAML syntax supported in Space is a subset of the standard.
Nodes without any value are ignored.
To set a node to an empty string:  

```
       varname: ""
```  

   To unset an "_env" variable use "!unset" (without quotes), as:  

```
       _env:
           - varname: !unset
```  

This will have Bash unset the varname variable.
Node values that are wrapped in single quotes will not be Bash evaluated at the parse stage.
The quotes are automatically removed.

Node values that are wrapped in double quotes will be Bash evaluated at the parse stage, just as values that are unquoted.
The quotes are automatically removed.
When arguments and cmds are wrapped inside other commands, their escape levels of double quotes and dollar signs are automatically increased.

When using variables in YAML always use the full variable notation of ${var}, not the shorthand $var, because **Space** expects the full notation to be able to detect and automatically escape variables.

### QUOTES AND STRINGS
   Double quoted values will be parameter expanded by Bash during parsing, while single quoted and unquoted lines will be treated as raw strings and evaluated later, at run time.  
   The following node's value will be parameter expanded by Bash on YAML parse:  
```
       key: "$(date)"
```  
   Meaning that "key" will immediately be set with the current date given by the `date` executable.

   In the following node the second `$(date)` will not be expanded immediately on YAML parse:
```
       key: "YAML was processed at: $(date), following date was post processed at run time: \$(date)."
```  
   Note the escaped dollar sign, so it does not evaluate on YAML parse already.

   This other example on the other hand will be read as a raw string, since it is either unquoted or single quoted:  
```
       key: $(date)
```  
   It will be processed later at run time.  

   Multi line values must start with a single '>' or '|'. Using a '>' will collapse newlines into spaces, while using a '|' will preserve newlines. If the '>' or '|' is immediately followed by a double quote, then all lines will be parameter expanded by bash at parse time, also then the last line must end with a double quote.  

```
       key: |
          could be BASE64 encoded data
          here. Line breaks conserved.

       key: >
          I like
          you! (will be on the same
          line).

       key: |"
          Right now date is: $(date).
But at observation date would be: \$(date)
          Also line breaks will be conserved"
```  

### ASSOCIATIVE ARRAYS AND LISTS
   A node could have child nodes, and then become an associative array.  

```
   node:
       keya:  aaa
       keybb: bbb
```  

   Space YAML supports a kind of list, it's an associative array with numeric keys. When fetching all keys for a list the key names are guaranteed to come sorted so the order of the list is preserved if keys are numbers.  

```
   node:
      00: first item
      01: second item
```  

### SPECIAL KEYS

All nodes with names beginning with an underscore are treated as hidden nodes and cannot be referenced from command line. They also might have special meaning to Space.

  * `_info`:
   Used purely for information and documentation about a node.

```
   nodes:
       my1:
           _info:
               title: This is my node no 1
               desc: |
                   Let's have a
                   mutli line description
                   about it.
               env: |
                   Optional information about this
                   nodes _env dependencies.
```

  * `_env`:
   List of variables to set below a node. Variables could reference other variables.
   Referenced variables must have been set on a node above or if on the same node then a sub `_env` is necessary for that dependent variable.

```
   nodes:
       _env:
           TEXT: text about something
       my1:
           _env:
               A: some $TEXT
               _env:
                   B: It is $A
```

  * `_run`:
   Set as string or multi line string and refer bash functions as $(BASH_FUNCTION).
   Those BASH_FUNCTION's are expanded by bash into runnable bash snippets.

```
   nodes:
       my1:
           _run: $(SSH)
```

## YAML PREPROCESSOR
Preprocessing variable assignments, usage and directives:

* `@{DIR}`: 
The current processed YAML files directory.

* `@{CWD}`: 
The directory from where Space was invoked.

* `@{PARENT}`:
The current parent node name.

* `@{PARENTPATH}`:
The full current parent node path.

* `@varname`: 
Some value Set preprocess variable "var1".

* `@varname`: 
No value nor trailing space will unset variable "var1".

* `@varname:-`:
Value Set preprocess variable "var1" only if "var1" lacks value or is unset.

* `@varname:+`: 
Value Set preprocess variable "var1" only if "var1" has value.

* `${varname-default value if unset}` or `${varname:-default value if empty}`:
Use ${varname} anywhere to have that substituted with the value of the variable.
Default value could be another variable from the preprocessor such as @{var2}.
Note that values of preprocessed variables are evaluated, meaning that you could use Bash variables and commands as ${USER}, $(cat value.txt), etc.

### PREPROCESSOR KEYWORDS
The following keywords are functions and cannot be used as preprocess variables:

  * `@assert: nonempty $variable|@variable`:
       Do nonempty assertion of Bash environment variable or space preprocess variable.

  * `@prompt: var1 Text to prompt user with`:
       Will output the text and read input from stdin which will be stored in preprocess variable "var1".
       Use @prompt:- to only prompt if var1 is unset or empty.

  * `@clone: space-sh/ssh space-sh/docker`:
       Clone those modules

  * `@debug: varname is: ${varname}`:
       Output using "_debug" during preprocess stage.

  * `@include: path/ssh.yaml|/some/node/(arg1 arg2)`:
       Include the ssh.yaml file and filter on /some/node, also assign the preprocess variables @{1} and @{2} to values arg1 resp arg2. The arguments are space separated and optional.  
       The filter is also optional.  
       To include from within the same file leave out the filename, as: `@include |/filter/.`  
       Absolute paths are also allowed.  
       Anything that is indented below the @include is treated as a subdoc that will get injected below every direct child node from the @include. Like a for loop.  
       For each server, include all services:  

```
       @include: servers.yaml
           server: This is server @{PARENT}
           @include: services.yaml
```
  * `@include:- file.yaml`:  
        Adding the dash will ignore a missing YAML file. Also it's subdoc will be ignored.

  * `@include: [username/]repo`:  
        Instead of including filenames you could name a module then Space will search for the right module and YAML file to include.

## INTERNAL VARIABLES

  * `CWD`:
        The directory from where the user invoked space.
  * `DIR`:
    The directory of where the sourced Bash file is located.
    Use this as "_source ${DIR}/somefile.bash" in the module bash file header.

## CMD VARIABLES
These are set from the YAML structure and modules Bash files or with command line switches. They are NOT inherited from the Bash environment and are initially unset.

  * `CMD`:
        `Function/binary arg1 arg2 -- replaceable_arg3 replaceable_arg4`
        CMD is always cleared for every node being evaluated, meaning it is not inherited downwards.  
        To use more complicated CMD's always use a Bash function for that, since A=1 B=1 echo something will treat A=1 as the command and the rest as arguments.  
        Set in YAML or using -c switch.

  * `CMDARGS`:
        Positional arguments to be added to the end of the CMD arguments list, but before any command line arguments.  
        Set in YAML or using -eARGS= switch.

  * `ALIAS`:
        If set to a node name space will reinvoke running that node instead. Arguments will get passed on just like the would on command line using --.  
        Not inherited between nodes, just as CMD.  
        ALIAS shadows CMD.

  * `CMDREDIR`:
        If set in modules Bash function or YAML will be appended to the final generated Bash string for redirection purposes.  
        Not inherited between nodes, just as ALIAS and CMD.

  * `CMDOUTER`:
        Use to have $CMD wrapped inside a for loop or similar. $CMD is substituted with _CMD_.  
        Set from modules Bash functions.  
        Not inherited.

  * `CMDWRAP`:
        Set to FUNC that takes $CMD as argument, often used for ssh wrapping.  
        Will be inherited downwards on nodes.

  * `CMDENV`:
        Space separated list of variable names to export with the CMD function.

  * `CMDEXIT`:
        If this is set in YAML (or using -e) to "1", then the return status of CMD must be equal to CMDEXIT or else it's regarded as an error and will return 1.

  * `CMDSILENT`:
        If this is set in YAML (or using -e) to "1", then the return status of CMD will be ignored.

When CMD points to a function name, that function will be parsed for Space header variables, which are on the format "SPACE_xyz=value". Header variables must be at the absolute top of the function to be considered header variables. These are the header variables available to be put at the top of your module functions to which CMD refers to.

  * `SPACE_SIGNATURE="arg1 arg2 [optarg1 optarg2]"`:
        Describes the number of arguments that the function is expecting. Space
        will exit with error if not fulfilled. Bracketed arguments are optional.

  * `SPACE_CMDDEP="FUNC2 PRINT"`:
       A space separated list of names of other function that this function depends
       on. All those functions will be exported together with the referring function.
       Those function modules must have been cloned (and automatically included)
       by issuing "clone mod1 mod2" in the referrings modules script file.
       PRINT is a function that is provided by Space for export for outputting text.
       Always overwritten by the space header if present, and each function that
       is dependant on other functions should always set their own SPACE_CMDDEP.
       All dependency functions and their dependencies will be exported, also their
       SPACE_CMDENV will get added to the first functions SPACE_CMDENV.

  * `SPACE_CMDENV="SUDO var1=\${othervar-} var2"`:
       A space separated list of variables to export out together with the functions.
       These variables will be evaluated at build time to reflect values set in
       the YAML or present for other reasons. "var=\${var-defaultvalue}" means
       Default value taken from CMDENV variable. Which could be set in the YAML.
       Always overwritten by the space header if present, and each function that
       is dependant on environment variables should always set their own SPACE_CMDENV.
       It is important not to introduce spaces in values inside the SPACE_CMDENV
       variable, because it will result in syntax error. Always escape default
       value variable names so that there not evaluated too early.

  * `SPACE_CMDREDIR`:
       Default value taken from CMDREDIR variable. Which could be set in the YAML.
       Only read from space header if not already set in the environment when building.
       Only settable from the first level function (not from the wrappers).

  * `SPACE_CMDOUTER`:
       Default value taken from CMDOUTER variable. Which could be set in the YAML.
       Only read from space header if not already set in the environment when building.
       Only settable from the first level function (not from the wrappers).

  * `SPACE_CMDARGS`:
       Default value taken from CMDARGS variable. Which could be set in the YAML.
       Always overwritten by the space header if present.

  * `SPACE_CMD`:
       If this variable is set, the function that it refers to will replace the
       current function as being the CMD.
       The referring CMD functions body will be run at this point giving the
       function very powerful ways of altering the environment variables and space
       header variables.
       For example the function body of the chaining command could do "SPACE_CMDREDIR=..."
       to override a value that is already set, but which could not have been overwritten
       simply using the space header variables, since SPACE_CMDREDIR is not allowed
       to be overwritten in that manner.
       A chained function could chain to another function, etc. All the above variable
       extraction rules apply.
       The body of a chaining function is run in Space's own context, meaning that
       it has access to all included modules and all environment variables, meaning
       that SPACE_CMDENV and SPACE_CMDDEP headers must *not* be used in a chaining
       function.

  * `SPACE_CMDWRAP="WRAPFN1 WRAPFN2"`:
       A space separated list of function names that will wrap this function.
       Typical use case is to wrap a command in SSH to run it on a remote server,
       or to wrap it in a "docker exec" to run it inside a Docker container, or both together
       to run the command over SSH inside a Docker container.
       The first name in the list is the innermost wrapper and the last name is
       the outermost wrapper.
       Default value taken from CMDWRAP variable. Which could be set in the YAML.
       Always prepended by the space header if present, meaning that each function
       could define a wrapper and all wrappers will be used.  
       A function that is a wrapper uses a limited set of the space headers.
       Good to know is that wrapper functions do not get the arguments that the
       original function gets, meaning that a wrapper function should not use the
       SPACE_SIGNATURE header. However the wrapper function often refers to another.
       function by SPACE_CMD header which is the function to run. For example SSH_WRAP
       chains to the SSH function, and the SSH function does have a SPACE_SIGNATURE header
       because it could be used for direct purposes, not only wrapping.
       So the first wrapper function (the referrer) must then appropriately set up the
       SPACE_CMDARGS header to match the SPACE_CMD functions SPACE_SIGNATURE that it
       is referring to. The values that make up the SPACE_ARGS will typically be
       derived from environment variables defined in SPACE_ENV.
       SPACE_CMDDEP and SPACE_CMDENV headers are extracted and exported together with the
       wrapper function.
       If a function refers to another function using SPACE_CMD then the function
       body is evaluated giving the opportunity to manipulate environment variables.
       The wrappers are evaluated from outermost to innermost, then the actual CMD's
       SPACE_ENV's are evaluated, so that wrappers could have a way of affecting
       those variables.


## NOTES
**Space** is made to work with Bash version 3.2 and later.  
**Space** uses some external programs for certain tasks, mostly coupled to tasks that involve disk and/or network access. These external programs are not all POSIX 1003.1 compliant but have been tested to work in a variety of platforms. For more information, search for the word EXTERNAL in the **Space** program and see how they are applied and used.  
Optional programs that are used when available for improving user experience include: **curl**, **git**, **shasum**, **sha1sum**, **sha256sum**, **tput** and **wget**.

## EXAMPLE

`space -f Spacefile.yaml /first/ -d`

### Spacefile.yaml:  

```
_info:
    title: This is my first module
    desc: |
        This module prints some stuff to the screen.
        That's about it.
first:
    _info:
        title: Print FIRST to screen.
        desc: |
            Really, that's it!
            Or wait, you could override the msg either
            By setting the variable txt, or by 
            providing a positional argument.
    _env:
        - txt: ${txt-FIRST}
        - CMD: MYMOD1_FIRST -- ${txt}
```

### Spacefile.sh:  

```
MYMOD1_FIRST ()
{
     SPACE_SIGNATURE="txt”
     SPACE_CMDDEP="MYMOD1_PRINT"


    local txt="${1}"
    shift


    MYMOD1_PRINT "${txt}"
}


# Helper function to print the message to stdout.
MYMOD1_PRINT ()
{
    local msg="${1}"
     shift


    printf "%s\n" "${msg}"
}
```



## AUTHORS
Thomas Backlund (blund@blockie.org).  
Maicon Filippsen (filippsen@blockie.org).

## REPORTING BUGS
Please refer to the official source code repository for filing issues: https://gitlab.com/space-sh/space/issues

## COPYRIGHT
Copyright 2016 Blockie AB Blockie.org

## SEE ALSO
ash(1), dash(1), bash(1), sh(1)  

Visit https://space.sh for up to date news, information and tutorials.

