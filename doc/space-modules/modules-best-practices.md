---
prev: ../modules-versioning/
prev_title: "Modules versioning"
next: ../modules-advanced-topics/
next_title: "Modules advanced topics"
title: Modules best practices
giturl: gitlab.com/space-sh/space
editurl: /edit/master/doc/space-modules/modules-best-practices.md
weight: 509
---

# Modules best practices


Checklist:  

1. Perform module static analysis  
```sh
space -m spacechecker /run/ -- .
```

2. Spell checking  
```sh
:set spell
```

3. Document all shell script functions for `spacedoc` export

4. Document all nodes in the configuration file with proper Title and Description i.e. `_info/title` and `_info/desc`

5. Run shell script static code analysis tools: `checkbashisms` and `shellcheck`

6. Generate README file  
```sh
GENERATE_VARIABLES=0 GENERATE_TOC=0 space -f ../space/tools/spacedoc/Spacefile.yaml /module/ -- Spacefile.sh
```

7. Create test directory with testrunner-compatible tests

8. Add continuous integration targets for running tests on external test and build servers

9. Always take careful action when making decisions based on data gathered, be it locally or remotely, because data could be tampered, misdirected or turned malicious by a compromised remote server.

10. Make sure build time module functions specify `SPACE_FN` header variable at the beginning of the function scope for clarity. Preferably in the very first line or the second line if first line is `SPACE_SIGNATURE=""`.
