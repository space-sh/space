---
prev: ../why-space-modules/
prev_title: "Why Space Modules"
next: ../running-a-space-module/
next_title: "Running a Space Module"
title: What are Space modules
giturl: github.com/space-sh/space
editurl: /edit/master/doc/space-modules/what-are-space-modules.md
weight: 502
---

# What are Space modules

Modules are exportable user extensions that can include each other to be loaded and run by _Space_ in a composable way. The execution can then be exported as a shell script, to be run directly or shared, all in a decentralized manner.  

Behind the scenes, _Space_ module is a directory on disk (often a _Git_ repository) which contains at least a _YAML_ description file (commonly named `Spacefile.yaml`) and most often also `Spacefile.sh/.bash` shell scripts. Modules are often located under `~/.space/space_modules/[reponame]`.  

  A user creating a _YAML_ structure can clone and include modules into the _YAML_ file, reusing them.  
_Space_ modules exported scripts only depend on a POSIX-compliant shell, so they run with _Ash_, _Dash_ and _Bash_.  

However _Space_ modules which explicitly defines a __Bash__ file as `Spacefile.bash` will export _Bash_ compliant scripts.  
_Space.sh_ provides by default a module ban list server for checking modules that might be broken or flagged as inappropriate.
