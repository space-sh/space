---
prev: ../installing-current-version-from-source-control-repository/
prev_title: "Installing current version from source control repository"
next: ../customizing-installation-parameters/
next_title: "Customizing installation parameters"
title: Installing latest stable version from Space.sh site
giturl: github.com/space-sh/space
editurl: /edit/master/doc/installing-and-running-your-first-space-command/installing-latest-stable-version-from-spacesh-site.md
weight: 403
---

# Installing latest stable version from Space.sh site

It is possible to download the installer from _space.sh_ site:  

```sh
curl https://get.space.sh > install-space-latest.sh
```

For older versions, `install.sh` is available under:  

```sh
curl -O https://space.sh/static/download/space-<version>/install-<version>.sh
```

#### Installing from Space.sh

Download `install.sh` and pipe into shell:  

```sh
curl https://get.space.sh | sh
```

or use the `install-space-latest.sh` downloaded in the _Downloading_ section and execute it:  

```sh
sh install-space-latest.sh
```

Non-root users might need `sudo` for default installation. In that case, use the following command:  

```sh
sudo sh -c "curl https://get.space.sh | sh"
```
