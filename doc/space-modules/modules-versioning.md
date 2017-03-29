---
prev: ../spacefile-yaml-reference/
prev_title: "Spacefile YAML reference"
next: ../modules-best-practices/
next_title: "Modules best practices"
title: Modules versioning
weight: 508
---

# Modules versioning

#### Stable version
All released versions are expected to be marked as _Git tags_ in the repository. Those are referred to as _stable_ versions.  

The last known stable version name is marked in the `stable.txt` file, expected to be in the module root directory.  
Stable version modules can be fetched either implicitly with `space -m <module-name>` or, preferably, by including the tag version name with `space -m <module-name>:<version>`.  

It is strongly advised to explicitly state the module version, in particular when using it as a dependency of some other module or program.

#### Current version
The _master_ branch on the repository is expected to regularly change. For this reason, the _master_ branch is referred to as the _current_ version.  

Relevant changes can be followed by reading the changelog file.

The current version module can be fetched with `space -m <module-name>:master`.
