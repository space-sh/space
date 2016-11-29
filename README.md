
# Space

![SpaceGal](https://space.sh/static/img/logo.png)

The _SpaceGal shell_ is a single file program, referred to as _Space_, that relies only on _Bash version 3.2 or later_ as dependency for loading and running configuration files and invoking programs in a structured manner.  
_Space_ is aimed to be run in constrained environments, embedded systems and devices geared towards the _Internet of Things (IoT)_. It also serves as a general purpose automation tool for structuring, setting up, deploying and executing commands, complex programs or replicating complete environments in an easy way.  
_Space_ provides the notion of _Modules_, which in essence are _Git_ repositories filled with user content defined as _Space_ descriptions and operations. _Modules_ can also point to other modules, so it is possible to create content on top of other users' work.  

_Space_ is part of _Spacegal.com_ and can be found at [https://space.sh](https://space.sh).  
_SpaceGal_ is a suite of services for _IoT_ automation, aimed to provide small footprint automation for _IoT_ devices, servers and digital life in general.  


## Dependencies

_Space_ requires _Bash_ version 3.2 or later.

Some external programs related to I/O operations are not _POSIX 1003.1_ compliant. Non-standard programs have been tested to work with:  
- GNU/Linux  
- BusyBox  
- MacOS 10+  


## Quick start

Please choose one of the methods below for installing _Space_ or read the [installation documents](doc/install.md) in the /doc directory for the complete guide.

### Manual install via tarball
Download, extract and install the _Space_:

```
mkdir space
curl -sL https://space.sh/static/download/space-0.9.0/space-0.9.0.tar.gz | tar xvf - -C ./space && cd ./space && /space /install/
```

### Automated install

Install _Space_ from terminal:

```
curl -sL https://get.space.sh/ | sh
```

### First steps
_Space_ is now installed. Run `space -h` anywhere to read the help instructions.
For more information, please refer to the documentation files located in the `doc` directory or the man pages.  
For the latest news and online reference, please visit [https://space.sh](https://space.sh).


## Authors

Copyright 2016 Blockie AB [Blockie.org](https://blockie.org)

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

