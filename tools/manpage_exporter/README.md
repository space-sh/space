# Man page exporter

This Space.sh module exports Markdown documentation to roff man pages and HTML.

## Dependencies
Depends on `ronn` which can be downloaded from: [https://github.com/rtomayko/ronn/blob/master/INSTALLING](https://github.com/rtomayko/ronn/blob/master/INSTALLING).

## Usage

Export man page for some `input_file`:
```
space -f ./tools/manpage_exporter/Spacefile.yaml /man/ -- <input_file>
```

Export HTML documentation page for some `input_file`:
```
space -f ./tools/manpage_exporter/Spacefile.yaml /html/ -- <input_file>
```

## Known issues

### "`split': invalid byte sequence in US-ASCII (ArgumentError)"

`ronn` might throw an error due to missing locale settings. Make sure UTF-8 encoding is set:
```
$ export LC_ALL=en_US.UTF-8
$ export LANG=en_US.UTF-8
```

