---
prev: ../what-are-space-modules/
prev_title: "What are Space Modules"
next: ../how-space-modules-work/
next_title: "How Space Modules work"
title: Running a Space module
weight: 503
---

# Running a Space module

_Space_ Modules are run following the command format:

```sh
space -m [reponame] /[nodename]/ -- [arguments]  
```

The following example describes a new module that runs a shell script function when called.  
Before running the module, create the following files: `Spacefile.yaml` and `Spacefile.sh`.

Spacefile.yaml:  

```yaml
_env:  
  - RUN: MY_FUNCTION  
```

Spacefile.sh:  

```yaml
MY_FUNCTION()  
{  
    printf "Hello from MY_FUNCTION\n"  
}
```

Now run `space -f Spacefile.yaml`. This is the same as running `space` without specifying a YAML file because `Spacefile.yaml` is the default file name (implicit module loading). _Space_ will then look for the accompanied `.sh` or `.bash` file, in this case `Spacefile.sh`, for loading the code 


#### Where to look for existing Space Modules?
Official core Modules are located at [https://gitlab.com/space-sh](https://gitlab.com/space-sh).


#### Downloading and running a Space Module
Let's run the core Module named `os`, located at [https://gitlab.com/space-sh/os](https://gitlab.com/space-sh/os). Its description says:  

>SpaceGal shell module to handle operating system tasks such as user processes, packages and services management

Now run:  

```sh
space -m os /info/
```

The previous command reads as follows:  

>Tell Space program to run module named `os` and run node named `info`

Nodes are the units in which the Module hierarchy are laid out. Whenever creating a new Module function, a YAML node will be required for exposing public functionality.  

Module hierarchy, nodes and more are explained in depth in section _How Space Modules work_ 
