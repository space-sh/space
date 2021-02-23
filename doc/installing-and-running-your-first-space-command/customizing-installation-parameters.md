---
prev: ../installing-latest-stable-version-from-spacesh-site/
prev_title: "Installing latest stable version from space.sh"
next: ../verifying-installation/
next_title: "Verifying installation"
title: Customizing installation parameters
giturl: github.com/space-sh/space
editurl: /edit/master/doc/installing-and-running-your-first-space-command/customizing-installation-parameters.md
weight: 404
---

# Customizing installation parameters

While it is true that both the default install parameters and automatic OS platform detection will handle the majority of use cases, there might be special cases.
It is possible to change the default installation directories for the _Space_ program and shell auto completion support.

#### Customizing install.sh
This script takes two optional parameters. The first one is the _Space_ program path and the second one is the auto completion path, where the customized _Space_ shell completion will be installed to. Paths can be either absolute or relative.

#### Customizing Space base module
The `/install/` node is defined inside the base Module that comes with _Space_ (Spacefile.yaml,bash). This Module is the actual installer and can read the same optional arguments as `install.sh`, which are the program path and the auto completion path for installing files, respectively.
