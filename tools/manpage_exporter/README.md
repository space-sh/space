# Man page exporter

This SpaceGal shell module exports Markdown documentation to roff man pages and HTML.

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

