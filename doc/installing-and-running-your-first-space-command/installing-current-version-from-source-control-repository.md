---
prev: ../installing-from-latest-tarball/
prev_title: "Installing from latest tarball"
next: ../installing-latest-stable-version-from-spacesh-site/
next_title: "Installing latest stable version from space.sh"
title: Installing current version from source control repository
weight: 402
---

# Installing current version from source control repository

Simply clone the repository:  

```sh
git clone https://gitlab.com/space-sh/space
```

{{/* notice note */}}
The _master_ branch is referred as the _current_ version of _Space_. For _stable_ releases, please checkout a specific _Git_ tag (see also: `git tag`).
{{/* /notice */}}

#### Installing from source control
After cloning the repository, from the root directory call _Space_ for installing itself on the system:  

```sh
./space /install/
```