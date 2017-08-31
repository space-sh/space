space(1) -- automation using Bash
=================================

## SYNOPSIS

`space` [`-f`|`m` namespace [`-M` modules] [`-ep` key=value] [node] [`-a`]] [`-vkKCXEs` value] [`-dlShgZB`] [`--` args]  
`space` [`-hVQu`]  
`space` `-U` [module]  


## DESCRIPTION
**Space.sh**, also known as **Space**, is a non-intrusive automation tool with a very small footprint, perfect to use with and on constrained environments and devices. It loads and runs YAML and Bash files.  

A YAML file is parsed and may refer to Bash functions loaded from a Bash file. The YAML structure is referred to as "nodes", and a "node" could have Bash variables associated to it. A node could be executed if it has the environment variable RUN set. The RUN variable typically refers to a Bash function, or is a Bash snippet in itself. A node could have many environment variables attached to it. When executing a node that has many levels such as "/a/b/c/", all Bash variables in each level will be loaded, where the deeper levels override their parent levels.  
In short, the YAML structure sets up the environment and then execution is passed on to a Bash function that executes the actual task.  

**Space** only depends on Bash and its exported scripts only depend on POSIX shell, so it runs with any POSIX compliant shell (ash, dash or bash). It provides a built-in YAML parser and preprocessor which are used to build **Space Modules**. *Modules* are exportable user extensions that can include each other to be loaded and run by **Space** in a composable way. The execution can then be exported as a shell script, to be run directly or shared, all in a decentralized manner.  
Behind the scenes, Space Module is a Git repository which contains at least the file Spacefile.yaml, and most often also Spacefile.sh/.bash.  A user creating a YAML structure could clone and include modules into the YAML file, reusing them.

For more complex combinations of modules, there is also the concept of "Dimensions". **Space** can handle up to three dimensions. This is a cuboid X*Y*Z, where X, Y and Z are one or many nodes that will get run in combination.  
An example of that is X could be a list of "things" to operate on, Y could be one or more "operations" to apply to each thing and Z could be one or more "hosts" to where these things exist.  
The Z dimension nodes will typically provide an environment variable named SPACE_WRAP that would wrap the RUN inside another RUN, for example to run the given RUN on another host over SSH.  
Each Dimension could have its own Namespace or share Namespaces. A Namespace is a loaded YAML structure. **Space** could, from a given first and optional second dimension, fetch the second or third dimension.

When running **Space**, the following steps occur:  
  1. Resolve the target node path. Fetches and combines dimensions for combo nodes, if applicable.  
  2. Perform YAML preprocessing to resolve all the @-directives  
  3. Perform YAML parsing to prepare environment variables to the next stage  
  4. Set up environment variables  
  5. Look up the RUN environment variable and gets the executable string from the given Bash function to execute  


## OPTIONS

  * `-f` [Spacefile.yaml]:
        YAML file to load, relative or absolute path. Both `-f` and `-m` options define namespaces in where to look for nodes, for a given dimension of nodes. There can be maximum three namespaces and three dimensions. One namespace can have more than one dimension. Dimension two and three could be found from namespace one below the node in dimension 1.  
        If only one dimension is given, **Space** looks below `node/_dimensions/second` for a space separated set of lists that makes up the second dimension.  
        The second dimension then uses second namespace if defined else first namespace.
        If two dimensions are given **Space** looks below `node/_dimensions/third` for a space separated list, each list object's "match" node is matched against the node in the second dimension, if match then the list below "nodes" makes up the third dimension.
        The third dimension then uses third namespace if defined else first namespace.  
        Defaults to: ./Spacefile.yaml.

  * `-m` [giturl/][username]/reponame:
        Module to run.  
        Direct access to run nodes in a module.  
        Modules are referenced as protocol://user@domain/username/reponame:commit, for example https://gitlab.com/space-sh/os:master  
        Only the Space specific user gitlab.com/space-sh could be denoted using only reponame, then username is set to `space-sh` and giturl is set to https://gitlab.com/.  
        All other users must specify domainname/username/reponame, for example ssh://gitlab.com/username/somemodule.  
        The protocol defaults to https.  

  * `-M` [giturl/][username]/reponame:
        Module to load e.g. "gitlab.com/blockie-org/amodule"  
        Clone and load modules. Separate multiple by space within quotes or use multiple -M switches, one for each module.  
        Usually used together with '-m' option to load a needed module for use with SPACE_WRAP environment variable. `-M` module shell scripts are loaded after `-m` module shell scripts and can override functions.  
        Example: space -m dropalot -M ssh -e SPACE_WRAP=SSH_WRAP -e sshhost=111.222.123.4  
        If any of the module script functions loaded using this switch depends on other modules, they must be provided using the same switch (`-M`).  

  * `-E` filename:
        Reads a shell file with variable definitions to apply.  
        Example: `var1=value`  
        This setting is applied before the `-e` variables.  
        Comments with `#` and the `export` keyword are ignored.  

  * `-e`  var=value:
        Environment variable to forcefully apply/overwrite before parsing the YAML.  
        Use one -e for each variable.  
        To unset a variable use -evar1='!unset'  

  * `-p` var=value:
        Preprocess variable to set before preprocessing.  
        Use one -p for each variable.  

  * `-s`:
        Set `SUDO` or `su` to run the command as.  
        `-s sudo` wraps the command in `sudo`.  
        `-s sudo:root` runs the command as root issuing `su` with `sudo`: `sudo su root`.   
        -s :root will issue: `su root`.  
        When working with wrapped commands and/or "outer" commands, it is possible to apply levels of `sudo` to run each wrapper as a specific user or `sudo`.  
        Example: `-s sudo:admin,sudo:root,sudo:sysadmin`  
        The rightmost `sudo` is for the innermost wrapped command (the actual command).

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
        Set HTTPS fallback for downloading modules using curl or wget.  

  * `-h`:
        Help, show **Space** usage or help on specific node.  
        Node(s) Pattern of one or many nodes to run.  
        If no node path is given the root node "/" is implied.  
        If node path(s) are given but none matches then **Space** aborts.  
        A node pattern is defined after a namespace (-f/-m) and then belongs to that namespace.  
        Nodes support regular expressions to run multiple nodes in sequence.  
        Ex: "/west/.*" will match all nodes below /west/,
          "/we.*/ will match /west/ and /web/ nodes.  
        When using asterisk make sure you use quotes so that Bash will not expand that before passing it to **Space** as arguments.  
        /we{st,b}/ without quotes will get expanded by Bash as two arguments  
        /west/ and /web/ that are passed to **Space**, which is cool of that is what you meant.

  * `-V`:
        Show **Space** version information

  * `-a`:
        All. Adds a ".*" to the node it suffixes, to match all it's nodes below.

  * `-C` level:
        Set caching level: 0 = off, 1 = on, 2 = regenerate cache.  
        Default level: 1

  * `-B` mode:
        Set to mode=1 to force to run modules in Bash. Normally Bash dependency depends on module script files ending in .bash instead of .sh.

  * `-Q`:
        Queries updates and general state of the Space.sh services.  

  * `-u`:
        Update current Space install to the latest version.  

  * `-U`:
        Update module(s). Performs a Git pull on matched module(s) then quit.  
        **Space** will update repositories both in local Space_Modules and also in shared Space_Modules directories.  
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

  * `-Z`:
        Skips checking modules version compatibility against current Space ver


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
        - RUN: MYMOD1_FIRST -- ${txt}
```

### Spacefile.sh:  

```
MYMOD1_FIRST ()
{
    SPACE_SIGNATURE="txt”
    SPACE_DEP="MYMOD1_PRINT"

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
Copyright 2016-2017 Blockie AB Blockie.org


## SEE ALSO
ash(1), dash(1), bash(1), sh(1)  

Visit https://space.sh for up to date news, information and tutorials.
