---
prev: ../
prev_title: "Installing and running your first Space command"
next: ../installing-current-version-from-source-control-repository/
next_title: "Installing current version from source control repository"
title: Installing from latest tarball
toc: true
giturl: gitlab.com/space-sh/space
editurl: /edit/master/doc/installing-and-running-your-first-space-command/installing-from-latest-tarball.md
weight: 401
---

# Installing from latest tarball

Follow the example code below for downloading, extracting, verifying _GPG_ signature and performing file integrity checks.  

```sh
curl -O https://space.sh/static/download/space-0.12.0/space-0.12.0.tar.gz  
curl -O https://space.sh/static/download/space-0.12.0/space-0.12.0.tar.gz.asc  
curl -O https://space.sh/static/download/space-0.12.0/space-0.12.0.sha  
curl -O https://space.sh/static/download/space-0.12.0/space-0.12.0.sha256  
curl -O https://space.sh/static/download/space-0.12.0/space-0.12.0.md5  
curl -O https://space.sh/static/download/space-0.12.0/install-0.12.0.sh  
```

#### Verifying package _GPG_ signature
This step is not required for installing _Space_, hence it is optional.  
Releases are signed either by one of the following keys:

- Thomas Backlund
  - **Fingerprint**: `CEE9 3024 3EBA C1B1 D08A  B73D 3611 E9C2 4F6C 6E63`
  - **Key**: [blund-3611E9C24F6C6E63.asc](https://gitlab.com/space-sh/space/snippets/32500/raw)
- Maicon Diniz Filippsen
  - **Fingerprint**: `295E 7B7B 14D8 8EEC 62E7  FBB1 DC8D 6348 0F72 A139`
  - **Key**: [filippsen-DC8D63480F72A139.asc](https://gitlab.com/space-sh/space/snippets/32501/raw)


It is then possible to verify the release signatures using the following command:  

```sh
gpg --verify space-0.12.0.tar.gz.asc space-0.12.0.tar.gz
```

#### Performing package integrity check.
This step is not required for installing _Space_, hence it is optional.  
Each release provides more than one way to verify file integrity, along with _GPG_ verification.
Current generated hashes are: _SHA1_, _SHA256_ and _MD5_.

Example checking _SHA256_:  

```sh
sha256sum -c space-0.12.0.sha256
space-0.12.0.tar.gz: OK
```

#### Installing from tarball
After extracting the files use _Space_ for installing itself on the system:  

```sh
./space /install/
```

or use the `install-<version>.sh` file and manually call it:  

```sh
sh install-<version>.sh
```
