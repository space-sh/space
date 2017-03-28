---
title: How Space works
prev: /why-space/
prev_title: "Why Space"
next: /installing-and-running-your-first-space-command/
next_title: "Installing and running your first Space command"
weight: 300
icon: "<b>3. </b>"
---

# How Space works

_Space_ is a single file program that runs in _Bash_ command line shell version 3.2 or later. General output results can be expected to be sent over to `stdout`, while user diagnostics can be caught on `stderr`.  

_Space_ uses some external programs for certain tasks, mostly coupled to tasks that involve disk and/or network access. These external programs are not all _POSIX 1003.1_ compliant but have been tested to work on a variety of platforms. For more information, search for the word EXTERNAL in the _Space_ source code and see how they are applied and used.  
Optional programs that are used when available for improving user experience include: _curl_, _git_, _shasum_, _sha1sum_, _sha256sum_ and _wget_.

When performing installation, if `man` program is available, _Space_ installs the manual page file. _Bash_ tab completion is also installed if the current _Bash_ install supports such feature.  
_Space_ revolves around Modules, covered in its own section - [Space Modules](../space-modules).
