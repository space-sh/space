---
prev: ../writing-your-own-space-module/
prev_title: "Writing your own Space Module"
next: ../spacefile-yaml-reference/
next_title: "Spacefile YAML reference"
title: Space variables
weight: 506
---

# Space variables

There is a handful of variables that have special meaning to _Space_.  
How these variables are set will ultimately decide what is exported.  
The special variables are called _Space_ Variables and they could be set already in the _YAML_ document or using the `-e` switch on command line.  
Later they could be set and altered in module functions headers or in module functions that act as "build time" functions.

Columns explained:

>1.  YAML Variable: Name of the environment variable which is set using `-e` switch and/or in the YAML structure below the `_env` node.  
    None of these variables are inherited from the shell environment.  
2.  Header Variable: Variable could be set in a functions `space header` at build time. Header Variables are inherited from YAML Variables.  
3.  Header Overwritable: "Yes" means that setting the variable in a `space header` will overwrite the current value.  
        "No" means that once it is set it cannot be overridden unless from a `build time` function.  
        "Append" means that new values will be appended.  
4.  Explanation: Brief summary. Look further below for more in detail explanations.  


| YAML Variable   | Header Variable | Headers Overwritable  | Explanation        |
|:----------------|:----------------|:---------------------:|:-------------------|
| RUN⁰¹           | SPACE_FN        |     Yes               | RUN is a function name or shell code snippet to run. If SPACE_FN is declared in the function header then the current function becomes a `build time function` and is evaluated on the spot, which enables it to change build variables in various ways. When SPACE_FN is set, the function that it refers to will replace the current function as being the RUN. The referring RUN function body will be run at this point giving the function very powerful ways of altering the environment variables and Space Header variables. For example, the function body of the chaining command could do "SPACE_REDIR=..." to override a value that is already set, but which could not have been overwritten by simply using the Space Header variables, since SPACE_REDIR is not allowed to be overwritten in that manner. A chained function could chain to another function, etc. All the above variable extraction rules apply. The body of a chaining function is run in a restricted sub shell, but is has access to all included modules and all environment variables by importing them. |
| RUN_ALIAS¹²     | -               |     -                 | Use RUN_ALIAS to point to another node in the YAML structure to load and overlay. |
| SPACE_SILENT²   | -               |     -                 | When SPACE_SILENT is set to "1" the exit status of the script will be ignored, returning 0 in all occasions. Meaning that if this is set in YAML (or using -e) to "1", then the return status of RUN will be ignored. |
| SPACE_EXIT²     | -               |     -                 | If set, it is the expected return status of the script. If the exit status is not equal to SPACE_EXIT then Space will return 1. Could be set in YAML or using –e flag. |
| -               | SPACE_SIGNATURE |     -                 | Defines a function signature describing the expected arguments to help user with validation. _Space_ will exit with error if the signature is not fulfilled. Arguments in brackets are treated as optional. |
| SPACE_REDIR¹    | SPACE_REDIR     |     No                | Redirect in/out files to the command in the export. It is encouraged to not pass files by their file name into external programs, instead, it is preferable to pipe the file into the program via `stdin` instead. This makes the _Space_ Module function become wrap-friendly. That is, it can be wrapped by other Modules and eventually run on different machines such as remote targets, virtual machines or Linux containers. This is only settable from the first level function (not from the wrappers). |
| SPACE_ENV       | SPACE_ENV       |     Yes               | List of variable names to export with the `RUN` function. When a function depends on environment variables it must declare those variables in order to export them with the script. A separate variable name without explicit assignment is implicitly assigned to its build time value. Example: `SPACE_ENV="USER"` is the same as `SPACE_ENV="USER=${USER}"`. It is important to quote default values containing spaces otherwise it will result in a syntax error, e.g. `SPACE_ENV="users=\"\${USERS-spacegal astroboy}\""`. Always escape your default value variable names so that they are not evaluated already in build time, e.g. `SPACE_ENV="USER=\${USER-astro}"` |
| SPACE_ARGS¹     | SPACE_ARGS      |     Yes               | A function can replace or manipulate its arguments using this _Space_ variable. If SPACE_FN is defined then SPACE_ARGS will be the arguments to that next function but not to the build time function defined by the body of the function declaring SPACE_FN (use `SPACE_BUILDARGS="${SPACE_ARGS}"` to pass in the same arguments into the build time function). |
| SPACE_DEP       | SPACE_DEP       |     Yes               | When a function depends on another function in the same module, or any other loaded module, that dependency must be declared using `SPACE_DEP`. This marks functions to be included in the export. E.g. `PRINT` is a function that is provided by _Space_ for export. Each function that is dependent on other functions should always set their SPACE_DEP. All dependency functions and their dependencies will be exported, and also their `SPACE_ENV` will become added to the first function's `SPACE_ENV`.|
| SPACE_WRAP⁴     | SPACE_WRAP      |     Append³           | A function that declares this header variable will be wrapped and executed inside the wrap command. A typical use case is to wrap a command in SSH to run it on a remote server, or to wrap it in a "docker exec" to run it inside a Docker container, or both together to run the command over SSH inside a Docker container. The first name in the list is the innermost wrapper and the last name is the outermost wrapper. Default value is taken from `SPACE_WRAP` variable, which can be set in the YAML or using the -e switch. This variable is not overwritable but new values will get appended to it, meaning that each function could define a wrapper and all wrappers will be used. A function that is a wrapper uses a limited set of Space Headers. Good to know is that wrapper functions do not automatically adopt the arguments of the original function. A wrapper function often refers to another function by the `SPACE_FN` header which will be the function to run. For example `SSH_WRAP` chains to the `SSH` function which has a `SPACE_SIGNATURE` header because it can be used for direct purposes, not only wrapping. So the first wrapper function (the referrer) must then appropriately set up the `SPACE_ARGS` header to match the `SPACE_FN` function's `SPACE_SIGNATURE` that it is referring to. The values that make up the `SPACE_ARGS` will typically be derived from environment variables defined in `SPACE_ENV`. `SPACE_DEP` and `SPACE_ENV` headers are extracted and exported together with the wrapper function. If a function refers to another function using `SPACE_FN` then the function body is evaluated giving the opportunity to manipulate environment variables. The wrappers are evaluated from outermost to innermost, then the actual `RUN` and `SPACE_ENV` commands are evaluated, so that wrappers could have a way of affecting those variables. Multiple entries are space separated. |
| SPACE_WRAPARGS  | SPACE_WRAPARGS  |     Append³           | Arguments to a SPACE_WRAP function. Optional. Multiple entries are newline (\\n) separated. |
| SPACE_OUTER⁵    | SPACE_OUTER     |     No                | Points to a function that is guaranteed to run locally and wrap the main function. Good for loops and iterating over a local file list, for instance. Only settable from the first level function (not from the wrappers).  |
| SPACE_OUTERARGS | SPACE_OUTERARGS |     Yes               | Arguments to the SPACE_OUTER function. |
| SPACE_OUTERENV  | SPACE_OUTERENV  |     Append⁶           | List of env variables to export out to outer scope. Could be exported regardless if SPACE_OUTER is defined. When `SPACE_ENV` and `SPACE_OUTERENV` both export to outer scope the `SPACE_OUTERENV` will be above and the `SPACE_ENV` variables directly after, so there could be multiple declarations of the same variable, this is expected behavior. |
| SPACE_OUTERDEP  | SPACE_OUTERDEP  |     Append⁶           | List of functions to export out to *outer scope*. Could be exported regardless if SPACE_OUTER is defined. |
|                 | SPACE_BUILDENV |     -                 | For a function declaring SPACE_FN, it could also declare which environment variables its function body (if any) will be needing. |
|                 | SPACE_BUILDDEP |     -                 | For a function declaring SPACE_FN, it could also declare which function dependencies its function body (if any) has. |
|                 | SPACE_BUILDARGS|     -                 | For a function declaring SPACE_FN, it could also declare which function arguments its function body (if any) will adopt. |

>⁰ This variable changes name when entering the `build stage`, because it could be a function *or* a shell snippet when defined in YAML or with `-eRUN=`. Also, `RUN` is much shorter to type than `SPACE_FN`...

>¹ These variables will only be parsed and set from the last part of the node path while other variables will get parsed and set from the top down to the deepest node part giving such variables the ability to be inherited downwards in YAML structures.

>² These variables cannot be set from the `space header`, but can instead be set by a `build time function`.

>³ Multiple `SPACE_WRAP` declarations will result in multiple wrappings of the final command. `SPACE_WRAP` and `SPACE_WRAPARGS` must be balanced against each other when manually overriding them using a `build time` function.

>⁴ A wrapper function can itself only use `SPACE_SIGNATURE`, `SPACE_ENV`, `SPACE_DEP`, `SPACE_ARGS` and `SPACE_FN`. If it uses `SPACE_FN` it becomes a `build time` function.

>⁵ An outer function can only define the header variables `SPACE_SIGNATURE`, `SPACE_ENV`, `SPACE_DEP` and `SPACE_ARGS`.
  Inside the outer function these space header variables are known as `SPACE_ENV`, `SPACE_DEP` and `SPACE_ARGS` as in any other function, but they are extracted from the outer functions' header as their official names `SPACE_OUTERENV`, `SPACE_OUTERDEP` and `SPACE_OUTERARGS`.

>⁶ Each time this variable is defined in a space header the values are appended and the export is the aggregation of it all.

>⁷ A dependency function could itself only declare `SPACE_SIGNATURE` (ignored), `SPACE_ENV` and `SPACE_DEP`.


A `space header` variable set in a function header must always be set using double quotes:  
```sh
SPACE_ENV="var1"
```  
This is due to restrictions in _Space's_ own parser. This only applies to header variables set in the header.  

The order of which `space header` variables are set could be significant.
