# static_analysis

Helper module for running static analysis on a given file or directory structure recursively.


## Dependencies

Depends on `command` and `grep`.
Optionally requires `shellcheck` or `checkbashisms` for running the analysis.


## Usage

For running Shellcheck:
```
./space -f ./tools/static_analysis/Spacefile.yaml /shellcheck/ -- "space" "shellchecks.txt"
```


Checkbashisms:
```
./space -f ./tools/static_analysis/Spacefile.yaml /checkbashisms/ -- "space" "bashisms.txt"
```


Running all tests:
```
./space -f ./tools/static_analysis/Spacefile.yaml /all/ -- "space" "analysis_"
```
Note that on the ALL test, the output parameter is just a suffix. The final file name will be suffix+program_name.txt.


Running all tests recursively:
```
./space -f ./tools/static_analysis/Spacefile.yaml /all_recursively/ -- "results"
```
Instead of /all/, there is also all_recursively, which scans all the shell script files, starting from the current directory and outputs all results to a separate directory.

