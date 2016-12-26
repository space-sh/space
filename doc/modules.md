# Modules

_Space_ modules.

## Module writing and maintenance checklist

1. Perform module static analysis

```
space -m spacechecker /run/ -- .
```

2. Spell checking
```
:set spell
```

3. Document all shell script functions for `spacedoc` export

4. Document all nodes in the configuration file with proper Title and Description

5. Run shell script static code analysis tools: `checkbashisms` and `shellcheck`

6. Generate README file
```
GENERATE_VARIABLES=0 GENERATE_TOC=0 space -f ../space/tools/spacedoc/Spacefile.yaml /module/ -- Spacefile.sh
```

7. Create test directory with testrunner-compatible tests

8. Add continuous integration targets for running tests on external test and build servers

