---
prev: /space-modules/
prev_title: "Space Modules"
next: /shell-coding-and-style-guidelines/
next_title: "Shell coding and style guidelines"
title: Advanced Space.sh configuration
giturl: gitlab.com/space-sh/space
editurl: /edit/master/doc/advanced-space-sh-configuration/index.md
weight: 600
icon: "<b>6. </b>"
---

# Advanced Space.sh configuration

### Environment variables and possible settings

#### SPACE_LOG_ENABLE_COLORS
Enables colored message output.  
Default: 1  
Set this from cmdline, using the -e flag or from the _YAML_.

#### SPACE_LOG_LEVEL
Set level of logging in interval [0,5] for the final script.  
Default: 4  
Set this from cmdline, using the -e flag or from the _YAML_.

#### SPACE_MODULES_SHARED
The directory for shared resources i.e. modules.  
Default: `~/.space/space_modules`  
Can only be set from the cmd line when invoking _Space_.
