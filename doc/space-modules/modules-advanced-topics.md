---
prev: ../modules-best-practices/
prev_title: "Modules best practices"
next: /advanced-spacegal-shell-configuration/
next_title: "Advanced SpaceGal shell configuration"
title: Modules advanced topics
giturl: gitlab.com/space-sh/space
editurl: /edit/master/doc/space-modules/modules-advanced-topics.md
weight: 510
---

# Modules advanced topics

#### Wrappers and outer functions
Outer functions is a mechanism of using existing module functions in a given iteration.  

In the event where a module or function is to be run in a remote target, it is possible to leverage the _wrapping_ mechanism provided by _Space_. This _wrapping_ mechanism will wrap any command and run it inside some other context, for instance, a remote shell over _SSH_, a _container_ or a combination of the two.  

##### Writing your own Space Module wrappers
1. Make your own wrapper.
2. Wrapping to be run inside a docker container.
3. Wrapping to be run over SSH.
4. Wrapping to be run inside a docker container over SSH.
5. Run outer functions locally

[[ to be written ]]

