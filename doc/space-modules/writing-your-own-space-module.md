---
prev: ../how-space-modules-work/
prev_title: "How Space Modules work"
next: ../space-variables/
next_title: "Space variables"
title: Writing your own Space module
toc: true
weight: 505
---

# Writing your own Space module

#### Spacefile.yaml
```yaml
_env:
    - RUN: FUN
```

#### Spacefile.sh
```sh
FUN()
{
    echo "Hello, args are: $*"
}
```

#### Understanding and improving the first Module

With the `Spacefiles` ready, use the `-d` switch to dump the script to output instead of running it.
```sh
space -d
#!/bin/env sh
# Script exported by:
#   ____  ____   __    ___  ____  ___   __   __
#  / ___)(  _ \ / _\  / __)(  __)/ __) / _\ (  )
#  \___ \ ) __//    \( (__  ) _)( (_ \/    \/ (_/\
#  (____/(__)  \_/\_/ \___)(____)\___/\_/\_/\____/
#                                         space.sh
# Node: /

set -u  # Will not allow for unset variables being used.
FUN()
{
    local _SPACE_NAME="FUN"
    echo "Hello, args are: $*"
}

FUN

# Space shows error message, if non clear exit.
_status="$?"; if [ "0" -eq 0 ] && [ "${_status}" -ne "0" ]; then
    [ "1" = "1" ] && printf "\033[31m"; printf "%s\n" "[ERROR] Script exited with status: ${_status}." >&2; [ "1" = "1" ] && printf "\033[0m"
    exit "$(( ${_status} > 0 ? ${_status} : 1 ))"
fi
```

At first, looks like a lot of cruft for a simple example. However, it is possible to identify the `FUN()` has been exported.
The added code is _Space_ automatically handling exit status code.

First lesson is to always remember the `space -d` option is helpful not only for exporting a program but also for analyzing, studying and understanding code. Exported scripts are standalone and runnable even without Space!

Let's provide some default arguments for our function in `Spacefile.yaml`:
```yaml
_env:
    - RUN: FUN Greetings World!
```

Running it again:  
```sh
space
Hello, args are: Greetings World!
```

Now, overriding the default arguments from the command line:  
```sh
space -- Hello World!
Hello, args are: Greetings World! Hello World!
```

Oops, that doesn't look right. The reason is that the arguments were not specified as available to be overridden.

In order to fix that, let's state that the arguments from the second argument are overridable by adding a `--` switch in front of it:
```yaml
_env:
    - RUN: FUN Greetings -- World!
```

Running it one more time:
```sh
space
Hello, args are: Greetings World!

space -- Universe!
Hello, args are: Greetings Universe!
```

#### Understanding dynamic configuration
Now we will introduce a slightly more advanced notion: dynamic configuration.  

_Space_ headers are always evaluated when the function body is read. With this concept we could have the _Space_ header change the values of special _Space_ variables. Consider the example in this modified `Spacefile.sh`:  
```sh
FUN()
{
    SPACE_ARGS="Hi $2"
    echo "Hello, args are: $*"
}
```

When running this modified Module it is possible to see that data was changed during the build step:
```sh
space
Hello, args are: Hi World!
```

The *header* of the function is considered to be all the top lines that start with defining a so called
_Space_ header variable, as such:  
```sh
FUN()
{
    SPACE_ARGS="arg1 arg2"
    # Comments are ok, they won't break the header.
    SPACE_ENV="USER"
    # The line below breaks the header and is considered the function body.
    echo "Args are $*"
    echo "User is $USER"
}
```

#### More on build time functions
The most powerful way to dynamically change the build configuration in build time is to use the _Space_ header `SPACE_FN`.  
This is a variable that points to another module function by name. What this does is that _Space_ will first evaluate the `space headers` letting the build time function manipulate them if necessary, then it will be forwarded to extract that other function (pointed to by `SPACE_FN`) as the function to export. Not only that, it also means that the function body of the function declaring `SPACE_FN` will be evaluated on the spot in a restricted subshell giving it advanced possibilities to modify variables and then `YIELD` them out again to affect the build.  

In the following case, function `FUN()` will turn into a "build time" function because it has `SPACE_FN` in its header. As with all functions, the _Space_ header of the "build time" function is first evaluated and those variables are set. After that, the function body of the "build time" function is evaluated giving the function a chance to modify and change the _Space_ header and other relevant variables.  
A build time function body must always call `YIELD varname` to export the value of a variable, which must already have been declared in the outside environment. This is due to the fact that the code runs - for security reasons - in a restricted subshell and cannot directly interact with the environment.  

If the build time function besides `SPACE_FN` also declares `SPACE_BUILDENV` or `SPACE_BUILDDEP`, then these will stand for the build time function, just like `SPACE_ENV` and `SPACE_DEP` are for the exported function. That goes for `SPACE_BUILDARGS` as well, which are the arguments for the build time function.  

After the body of `FUN()` have been evaluated, _Space_ will be pointed to `FUN2()` where it will perform the normal evaluation of _SPACE_ Headers, exporting the function body afterwards.

```sh
FUN()
{
    SPACE_FN="FUN2"
    SPACE_BUILDENV="USER HOME"
    SPACE_BUILDDEP="PRINT"
    SPACE_BUILDARGS="${SPACE_ARGS}"

    # Above is the header, below is the body.

    PRINT "Build time args are: $*"
    # Here we alter the function arguments for the coming function: FUN2.
    SPACE_ARGS="$* Adding some more args for $USER"

    YIELD "SPACE_ARGS"
}

FUN2()
{
    echo "Final arguments: $*"
}
```
