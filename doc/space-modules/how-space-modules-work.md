---
prev: ../running-a-space-module/
prev_title: "Running a Space Module"
next: ../writing-your-own-space-module/
next_title: "Writing your own Space Module"
title: How Space modules work
toc: true
weight: 504
---

# How Space modules work

The following steps occur when running a _Space_ module:  

1. Bash will run the `space` shell script and then `space` will perform the _init stage_:  
1.1.  Initialize the _script context_.  
1.2.  Load given _YAML_ file(s) into namespace(s).  
1.3.  Fill up to three namespaces, if applicable.  
1.4.  Expand given node dimensions.  
1.5.  Fill up to three dimensions, if applicable.  
1.6.  Setup _node combo_ iteration, save state and hand over to the _build stage_.  
  
2. After the _init stage_ _Space_ enters the _build stage_.  
2.1.  Load node(s) in the node combo.  
2.2.  Assemble the script for export.  
2.3.  Run script or print it to stdout.  

#### 1. Space Module init stage

##### 1.1 Initialize the _script context_
_Space_ will first unset all the _Space_ variables to not inherit them from the shell environment.  
After that, all variables defined with `-e` on the command line will be set to the _Space_ context. These could include _Space_ variables.

##### 1.2 Load _YAML_ files into namespaces
All _YAML_ files and _Space_ modules _YAML_ files that were stated on the command line (using `-f/-m` switches) will be preprocessed and loaded into their respective namespace.  

##### 1.3 Fill up namespaces
If less than three namespaces were loaded, _Space_ will look into the _YAML_ of the first namespace after the special node `/_namespaces/` and load files/modules defined there.  
Normally, only one namespace is used. Further explanation can be found in _Namespaces_ subsection.

##### 1.4 Expand node dimensions
During this step, command line node targets are expanded for wild cards and regular expressions against their respective namespace.

##### 1.5 Fill up dimensions
If less than three dimensions were given on the command line, _Space_ will look into the _YAML_ of the first namespace after the special node `/_dimensions/` and, if matched, fill up dimensions 2 and 3 with node targets in their respective namespace.  
Usually, only one dimension is used. Further explanation can be found in _Dimensions_ subsection.

##### 1.6 Setup `node combo` iteration
Depending on how many dimensions are specified, the node combination will result in a matrix of size `X * Y * Z`. The resulting size will be the number of node combinations to run.  
After that, the `script context`s state is saved and ready to be handed over to the build stage. 
Normally, there is only one dimension with single target node, so there is no iteration involved. Whenever multiple iterations occur, state is reset before proceeding to the next iteration.


#### 2. Space Module build stage

##### 2.1 Load node combo
The build process will be handed one _node combo_, which could consist of one, two or three
node targets e.g. `/mysite/ /myserver/ /deploy/`.  
Each node target is loaded from the _YAML_ structure. If more than one node is present then they are
loaded left to right and the resulting environment variables will override from left to right.  

Analyzing the following _node combo_:  
`/node1/ /node2/ /node3/`  

Before passing over execution to the _build stage_, the `init stage` has setup a `script context`. This context contains the environment variables that are inherited from the shell and those which were defined on the command line using the `-e` switch. Also some other internal variables have been defined, such as `_VERSION`.  

The build process will load each node in series, starting with `/node1/`. After that, the _YAML_ document is read and all environment variables defined are extracted and applied onto the _script context_. A variable defined in the YAML document will overwrite a variable with the same name already existing in the _script context_ (i.e. set using the -e switch or set by prior node target), if not the _YAML_ respects the original value as default value, as:  
```yaml
node1:  
    _env:  
        var1: ${var1-The value}  
```  
Then `/node2/` and `/node3/` are loaded in the same way, each with the ability to override variables already defined before it.

##### 2.2 Assemble export
Now that the _script context_ is setup particularly for the _node combo_, _Space_ will assemble the parts that will build up the final output - the exported script.  
_Space_ looks for the `RUN` variable. If it refers to a shell function that has not been loaded from a known module, that is, it is anonymous, then `RUN` will be put inside a function named `_anonymous`.  
A module function could have a _Space_ header. These are the first lines that set the special `SPACE` Header variables. The `SPACE` Header variables are always evaluated during the build step and affect the export.


#### 2.3 Spacefile YAML description
The _YAML_ structure sets up the environment and then execution is passed on to a shell script function that executes the actual task.  

A _YAML_ file is parsed and may refer to shell script functions loaded from a shell script file. The _YAML_ structure is referred to as "nodes", and a "node" can have shell variables associated to it.  

A node can be executed if it has the environment variable `RUN` set. The `RUN` variable typically refers to a shell script function, or is a shell script snippet in itself. A node could have many environment variables attached to it (using the `_env` sub node). When executing a node that has many levels such as `/a/b/c/`, all shell script variables in each level will be loaded, where the deeper levels override their parent levels (except for the variables RUN, SPACE_REDIR, RUN_ALIAS, SPACE_OUTER and SPACE_ARGS which are not inherited).  

#### Namespaces
A namespace is where a _YAML_ document is loaded. Each document has its own namespace to prevent conflicts.  

When referring to _YAML_ files directly (using `-f`) or indirectly (using `-m`) on the command line each document is loaded into its own namespace. There can be a maximum of three namespaces, and therefore a maximum of three `-f/-m` switches on the same command line.  

There can also be a maximum of three `node dimensions` defined.  

The following table presents how many dimensions are loaded in relation to how many namespaces are defined.  

| # Namespaces | Dimension 1 | Dimension 2 | Dimension 3|
|--------------|:-----------:|:-----------:|:----------:|
| 1 namespace  |     1       |      1      |      1     |
| 2 namespaces |     1       |      2      |      1     |
| 3 namespaces |     1       |      2      |      3     |


Given the following example:  
```sh
$ space -f a.yaml /node1/ /node2/ -f b.yaml /node3/
```  
Both `node1` and `node3` are expected to be defined in `a.yaml` and they will be associated with that same _YAML_ file. On the other hand, `node2` will be associated with `b.yaml`.  
The order of namespaces in which nodes are presented is irrelevant, thus:  
```sh
$ space -f a.yaml -f b.yaml /node1/ /node2/ /node3/
```
will give the exact same result as the first example.

However, when defining nodes before namespaces as:
```sh
space /node1/ -f b.yaml /node2/
```
`b.yaml` will become the second namespace and the default namespace will be loaded by automatically injecting `-f Spacefile.yaml in front of `/node1/`.
```sh
space -f Spacefile.yaml /node1/ -f b.yaml /node2/
```

##### Automatic loading of namespaces 2 and 3
If less than three namespaces have been loaded using `-f/-m` switches, _Space_ will look into the first namespace's _YAML_ structure after the special node `/_namespaces/`. If that node is present, then more namespaces could be loaded automatically.  

In the following example, only one namespace is loaded on the command line, so _Space_ will automatically load the module named `somemodule` into namespace 2, and then, since only 2 namespaces are loaded, it will load the file `b.yaml` into namespace 3.  
```yaml
_namespaces:  
    second:  
        module: somemodule  
    third:  
        file: b.yaml  
```  
When defining two namespaces on the command line only the third namespace will be automatically loaded, in this case the file b.yaml (not somemodule).

#### Dimensions
For more complex combinations of modules, there is also the concept of dimensions. _Space_ can handle up to three dimensions. This is a cuboid X*Y*Z, where X, Y and Z are one or more nodes that will be run in combination.  

An example of that is X could be a list of things to operate on, Y could be one or more operations to apply to each thing and Z could be one or more "hosts" where these things exist.  

The Z dimension nodes will typically provide an environment variable named `SPACE_WRAP` that would wrap the `RUN` inside another `RUN`, for example to run the given `RUN` on another host over `SSH`.  

Each Dimension could have its own namespace or share namespaces. A namespace is a loaded _YAML_ structure. _Space_ could, from a given first and optional second dimension, fetch the second or third dimension.

A _node dimension_ is a list of one or more node targets in a _YAML_ file. _Space_ supports up to three node dimensions together.  
A `node dimension` can be described either from command line or from the `_dimensions` node in the first dimensions _YAML_ file.

##### Node dimensions on the command line
Consider the following _YAML_ file `a.yaml`:
```yaml
# a.yaml
servers:
    alpha:
        _env:
            - ADDRESS: 192.168.0.1
            - RUN: SERVER_UP
    beta:
        _env:
            - ADDRESS: 192.168.0.2
            - RUN: SERVER_UP
```

Running _Space_ with the `-l` switch to list the nodes result in `dimension 1` having a single item in its list of node targets:
```sh
$ space -f a.yaml /servers/alpha/ -l
/servers/alpha/
```

However, running with a wildcard for node target result in `dimension 1` having a list composed of two node targets:  
```sh
$ space -f a.yaml "/servers/.*/" -l
/servers/alpha/
/servers/beta/
```
Note the quotes around the node targets, that is because your shell should not start globbing on the `*`.  

Consider having a second YAML file (dimension) named `b.yaml`:  
```yaml
# b.yaml
tasks:
    ping:
        _env:
            - RUN: SERVER_PING
    status:
        _env:
            - RUN: SERVER_STATUS
```

Running _Space_ referring to nodes both in `a.yaml` and `b.yaml` results in two node dimensions, that is, two columns, each with one node target in it:  
```sh
$ space -f a.yaml /servers/alpha/ -f b.yaml /tasks/ping/ -l
/servers/alpha/ /tasks/ping/
```

The wildcard can be also be used:  
```sh
$ space -f a.yaml /servers/alpha/ -f b.yaml "/tasks/.*/" -l
/servers/alpha/ /tasks/ping/
/servers/alpha/ /tasks/status/
```

Wildcards also work for multiple dimensions at the same time:
```sh
$ space -f a.yaml "/servers/.*/" -f b.yaml "/tasks/.*/" -l
/servers/alpha/ /tasks/ping/
/servers/alpha/ /tasks/status/
/servers/beta/ /tasks/ping/
/servers/beta/ /tasks/status/
```  
In this hypothetical example we run the targets of two YAML files against each other to first ping a server and then to query its status, for the two servers `alpha` and `beta`.

You are welcome to try it with the `-d` switch to see the exported script:
```sh
$ space -f a.yaml "/servers/.*/" -f b.yaml "/tasks/.*/" -d
```

Until now, examples only took advantage of two out of three possible dimensions defined by the two node targets.
One could refer to a module instead of a file by using the `-m` switch:  
```sh
$ space -f a.yaml "/servers/.*/" -f b.yaml "/tasks/.*/" -m ssh /wrap/ -eSSHHOST="1.2.3.4" -l
/servers/alpha/ /tasks/ping/ /wrap/
/servers/alpha/ /tasks/status/ /wrap/
/servers/beta/ /tasks/ping/ /wrap/
/servers/beta/ /tasks/status/ /wrap/
```  
Each column above is a node dimension and each row is called a node combo.
Node combos are simply separate nodes that are loaded together and having their environment variables merged into the `script context`.
Dimension 2 overrides variables in dimension 1. Dimension 3 overrides variables in dimension 2.

Dimensions could also refer to node targets within the same _YAML_ file or module:
```sh
$ space -f a.yaml /servers/alpha/ /servers/beta/ -l
/servers/alpha/ /servers/beta/
```  
In this case there is one `node combo` to run, which might not be what was originally intended. If one wants to run those two node targets separately, then it is necessary to use wildcards and regular expressions to fill out one dimension with targets.  
The following example shows one dimension with two targets:  
```sh
$ space -f a.yaml "/servers/(alpha|beta)/" -l
/servers/alpha/
/servers/beta/
```
Regular expressions are _Bash_ regular expressions.  
Wildcards and regular expressions must always be contained inside double quotes.


##### Automatically adding dimensions using `friend` nodes

Just as namespaces can be automatically filled by defining the special node `/_namespaces/`, the same happens with _Space_ dimensions.  

If _Space_ has less than three node dimensions, it will look into the first namespace's YAML after the specific node `/_dimensions/`.  
What the `_dimensions` node does is that it defines auto-fill for dimensions two and three, where applicable.  
If it has one dimension then it will match an entry which has a `first` and `second` object.  

In the following example, _Space_ will automatically add the second dimension if it is not defined and when the first dimension matches any of the nodes defined.  
```yaml
_dimensions:
    - first: /node1/ /node1b/ /node1c/.*/
      second: /node2/ /node2b/*/
```

A third auto population could also be added, like so:  
```yaml
_dimensions:
    - first: /node1/ /node1b/ /node1c/.*/
      second: /node2/ /node2b/*/
      third: /node3/.*/
```

When matched and dimension filled, Space will not evaluate any further fill objects. Meaning that if `first` and `second` matches, `third` will be filled, and any next object of `first/second/third` will not be evaluated.

##### Ordering
When using more than one dimension it is possible to set another order for nodes to be loaded into the environment.
```yaml
_dimensions_order: 3 1 2
```
The above will cause environment variables from dimension 1 to override those in dimension 3, and those in 2 override both others.  
It could be very useful to have the node with the `RUN` variable be loaded last, so it has access to all other environment variables when it is evaluated.

##### Filling
To auto fill dimensions we must set `_dimensions_fill` to "2" or "3".  
If `_dimensions_fill: 2` is set then we fill for dimension two and three.  
If `_dimensions_fill: 3` is set then we fill only dimension three.  

When filling a dimension, hidden nodes are only included when explicitly listed in the object's pattern.
That is, if any node part begins with an underscore:  
```yaml
_dimensions:
    - first: /.*/_.*/.*/
      second: /.*/
```

##### Example
Given a file `a.yaml` defined by:
```yaml
node1:
    sub1:
        _env:
            - A: 1-1 value
    sub1b:
        _env:
            - A: 1-1b value

node2:
    sub2:
        _env:
            - A: 2-2 value
    sub2b:
        _env:
            - A: 2-2b value

node3:
    sub3:
        _env:
            - A: 3-3 value
    sub3b:
        _env:
            - A: 3-3b value

_dimensions:
    - first: /node1/
      second: /node2/.*/

    - first: /node1/
      second: /node2/sub2/
      third: /node3/sub3/

    - first: /node1/
      second: /node2/sub2b/
      third: /node3/sub3b/

    - first: /node1/.*/
      second: /node2/.*/
      third: /node3/.*/
```

Run `a.yaml`:  
```sh
$ space -f a.yaml /node1/ -l
/node1/ /node2/sub2/ /node3/sub3/
/node1/ /node2/sub2b/ /node3/sub3b/
```

Run `a.yaml` with `-l` acting as a wildcard `/.*/`:  
```sh
$ space -f a.yaml /node1/ -a -l
/node1/sub1/ /node2/sub2/ /node3/sub3/
/node1/sub1/ /node2/sub2/ /node3/sub3b/
/node1/sub1/ /node2/sub2b/ /node3/sub3/
/node1/sub1/ /node2/sub2b/ /node3/sub3b/
/node1/sub1b/ /node2/sub2/ /node3/sub3/
/node1/sub1b/ /node2/sub2/ /node3/sub3b/
/node1/sub1b/ /node2/sub2b/ /node3/sub3/
/node1/sub1b/ /node2/sub2b/ /node3/sub3b/
```
Above is the same as running:
```sh
$ space -f a.yaml "/node1/.*" -l
```

Multiple objects under `/_dimensions/` is always a possibility.  
Whenever defining `_dimensions` in namespace 1, extra dimensions will be implicitly added according to `_dimensions_fill` and if matches are made.
