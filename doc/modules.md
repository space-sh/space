# Modules

_Space_ modules.

## Versions

### Stable
All released versions are expected to be marked as _Git tags_ on the repository. Those are referred to as _stable_ versions.  
The last known stable version name is marked in the `stable.txt` file, expected to be in the module root directory.  
Stable version modules can be fetched either implicitly with `space -m <module-name>` or, preferably, by including the tag version name with `space -m <module-name>:<version>`.  
It is strongly advised to explicitly state the module version, in particular when using it as a dependency of some other module or program.

### Current
The _master_ branch on the repository is expected to regularly change. For this reason, _master_ branch is referred to as the _current_ version.  
Relevant changes can be followed by reading the [CHANGELOG](CHANGELOG.md).  
Current version module can be fetched with `space -m <module-name>:master`.


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

