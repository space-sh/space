
# Space | [![build status](https://github.com/space-sh/space/actions/workflows/main.yml/badge.svg)](https://github.com/space-sh/space/commits/master) [![latest stable version](https://img.shields.io/badge/latest%20stable-1.5.0-blue.svg?style=flat)](https://github.com/space-sh/space/releases/tag/1.5.0) [![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/blockie-org/space.sh)

![Space.sh](https://space.sh/static/img/logo.png)

Welcome to Space!

This tool is not for the faint of heart, but here we go!

The _Space.sh_ is a single file program, referred to as _Space_, that relies only on _Bash version 3.2 or later_ as dependency for loading and running configuration files and invoking programs in a structured manner.  

_Space_ assembles shell script applications built out of reusable modules and it also provides automation features.

One could say "it's like Ansible but written in Bash".

_Space_ provides the notion of _Modules_, which in essence are _Git_ repositories filled with user content defined as _Space_ descriptions and operations. _Modules_ can also point to other modules, so it is possible to create content on top of other users' work.  

_Space_ is part of _Space.sh_ and can be found at [https://space.sh](https://space.sh).  


## Dependencies

_Space_ requires _Bash_ version 3.2 or later.

Some external programs related to I/O operations are not _POSIX 1003.1_ compliant. Non-standard programs have been tested to work with:  
- GNU/Linux  
- BusyBox/Linux (Android)  
- MacOS 10+  


## Quick start

Please choose one of the methods below for installing _Space_ or read the [installation documents](manuals/install.md) in the /doc directory for the complete guide.


### Automated install

Install the latest stable version of _Space_ from terminal:

```
curl https://get.space.sh/ | sh
```

### Manual install via tarball
Download, extract and install the latest stable version of _Space_:

```
mkdir space
curl https://space.sh/static/download/space-1.5.0/space-1.5.0.tar.gz | tar xvfz - -C ./space && cd ./space && ./space /install/
```
Note: this exact method does not check for the integrity of the downloaded .tar.gz file. It is possible to do so while still performing a manual install, please refer to the [install documentation](manuals/install.md).


### First steps
_Space_ is now installed. Run `space -h` anywhere to read the help instructions.  
For a simple module example, please refer to EXAMPLE section in the [user manual page](manuals/space.md). For more advanced modules, check out the [Spacefile.yaml](Spacefile.yaml) and [Spacefile.sh](Spacefile.sh) files and the core modules located at [https://github.com/space-sh](https://github.com/space-sh).  

For more information, please refer to the documentation files located in the `doc` directory or the man pages.  
For the latest news and online reference, please visit [https://space.sh](https://space.sh).

Further questions can be asked via the [GitHub Issues](https://github.com/space-sh/space/issues) page.


## Community

* Chat on _Gitter_: https://gitter.im/blockie-org/space.sh


## Contributing

Code contributions are welcome via [GitHub pull requests](https://github.com/space-sh/space/pulls). More information and details on how to do it can be found in the [CONTRIBUTING](CONTRIBUTING.md) document.


## Issues

Bug reports and suggestions can be filed at the project [GitHub Issues](https://github.com/space-sh/space/issues) page.


## Authors

Copyright 2016-2017 Blockie AB [Blockie.org](https://blockie.org)


## License

>This program is free software: you can redistribute it and/or modify
>it under the terms of the GNU General Public License as published by
>the Free Software Foundation version 3 of the License.

>This program is distributed in the hope that it will be useful,
>but WITHOUT ANY WARRANTY; without even the implied warranty of
>MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>GNU General Public License for more details.

>You should have received a copy of the GNU General Public License
>along with this program.  If not, see <http://www.gnu.org/licenses/>.

