# Spacedoc

Spacedoc is a module for SpaceGal shell that generates Markdown and HTML documentation based on code comments surrounding global variables and procedures in shell scripts.


## Dependencies
Bash, cat, date, echo and rm.

Optionally requires `Markdown.pl` for exporting the HTML documentation, which can be downloaded from: [http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip](http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip)


## Usage

It is possible to generate a complete Table of Contents (TOC) automatically by setting the environment variable GENERATE_TOC=1 when running the command.
```
GENERATE_TOC=1 space /markdown/ -- <input_file>
```

Generate Markdown documentation for some `input_file`:
```
space -f ./tools/spacedoc/Spacefile.yaml /markdown/ -- <input_file>
```

Generate Markdown and HTML documentation for some `input_file`:
```
space -f ./tools/spacedoc/Spacefile.yaml /html/ -- <input_file>
```

It is also possible to use the short implicit form when calling from the spacedoc directory:
```
space /markdown/ -- <input_file>
```


