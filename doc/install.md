# Space - Install notes

A manual install can be performed by downloading the _release tarball_ and using _Space_ itself to install the release files on the system. Please note, however, this process does not perform any file integrity checks, neither does it verify _GPG_ signatures.

The other method is performing the automatic install process by using the _Space_ installer script, which is automatically generated on every new _Space_ release to match the new version and new file hashes. Note that this method automatically performs file integrity checks (shasum) on the downloaded files to ensure the files were not corrupted or modified before installing.

## Versions

### Stable  
All released versions are marked as _Git tags_ on the [source repository](https://gitlab.com/space-sh/space/tags). Those are referred to as _stable_ versions, which are the ones packaged and distributed on [space.sh](https://space.sh) website. Check the [Downloading](#downloading) section below for download links.

### Current  
The _master_ branch on the repository is expected to regularly change. For this reason, _master_ branch is referred to as the _current_ version. Relevant changes can be followed by reading the [CHANGELOG](CHANGELOG.md).


## Release files

The release files are expected to contain at least the following set of items:  
```
  space-<version>.tar.gz         # The tarball
  space-<version>.tar.gz.asc     # The tarball GPG signature
  install-<version>.sh           # The installer script
  space-<version>.md             # Code documentation
  shasum: space-<version>.sha    # shasum hash
  shasum: space-<version>.sha256 # shasum hash
  space-<version>.md5            # MD5 hash
```


## Downloading

### Latest tarball

Follow the example code below for downloading, extracting, verifying _GPG_ signature and performing file integrity checks.

Using _curl_:
```
curl -O https://space.sh/static/download/space-0.9.0/space-0.9.0.tar.gz
curl -O https://space.sh/static/download/space-0.9.0/space-0.9.0.tar.gz.asc
curl -O https://space.sh/static/download/space-0.9.0/space-0.9.0.sha
curl -O https://space.sh/static/download/space-0.9.0/space-0.9.0.sha256
curl -O https://space.sh/static/download/space-0.9.0/space-0.9.0.md5
curl -O https://space.sh/static/download/space-0.9.0/install-0.9.0.sh
```

Using _wget_:
```
wget https://space.sh/static/download/space-0.9.0/space-0.9.0.tar.gz
wget https://space.sh/static/download/space-0.9.0/space-0.9.0.tar.gz.asc
wget https://space.sh/static/download/space-0.9.0/space-0.9.0.sha
wget https://space.sh/static/download/space-0.9.0/space-0.9.0.sha256
wget https://space.sh/static/download/space-0.9.0/space-0.9.0.md5
wget https://space.sh/static/download/space-0.9.0/install-0.9.0.sh
```

#### Verifying _GPG_ signature (recommended)

Releases are signed either by one of the following keys:

- Thomas Backlund
  - Fingerprint: `CEE9 3024 3EBA C1B1 D08A  B73D 3611 E9C2 4F6C 6E63`
  - Key: [blund-3611E9C24F6C6E63.asc](https://gitlab.com/space-sh/space/snippets/32500/raw)
- Maicon Diniz Filippsen
  - Fingerprint: `295E 7B7B 14D8 8EEC 62E7  FBB1 DC8D 6348 0F72 A139`
  - Key: [filippsen-DC8D63480F72A139.asc](https://gitlab.com/space-sh/space/snippets/32501/raw)


It is then possible to verify the release signatures using the following command:
```
gpg --verify space-0.9.0.tar.gz.asc space-0.9.0.tar.gz
```

#### Performing file integrity check (recommended)

Each release provides more than one way to verify file integrity, along with _GPG_ verification.
Current generated hashes are: _SHA1_, _SHA256_ and _MD5_.

Example checking _SHA256_:
```
$ sha256sum -c space-0.9.0.sha256
space-0.9.0.tar.gz: OK
```

### From source control

Simply clone the repository:
```
git clone https://gitlab.com/space-sh/space
```
Note that the _master_ branch is referred as the _current_ version of _Space_. For _stable_ releases, please checkout a specific Git tag (see also: `git tag`).

### From site

It is possible to download the installer from _space.sh_ site:
```
curl https://get.space.sh > install-space-latest.sh
```

For older versions, _install.sh_ is always available under:
```
curl -O https://space.sh/static/download/space-<version>/install-<version>.sh
```


## Installing

Please note that by default _Space_ installs to `/usr/local/bin` and that requires administrator rights in order to succeed.

### From tarball

After extracting the files use _Space_ for installing itself on the system:
```
./space /install/
```

or use the install-<version>.sh file and manually call it:
```
sh install-<version>.sh
```


### From source control

After cloning the repository, from the root directory call _Space_ for installing itself on the system:
```
./space /install/
```

### From site using install.sh

Download install.sh and pipe into shell:
```
curl https://get.space.sh | sh
```

or use the `install-space-latest.sh` downloaded in the _Downloading_ section and execute it:
```
sh install-space-latest.sh
```

Please note that non-root users might need sudo for default installation. In that case, use the following command: `sudo sh -c "curl https://get.space.sh | sh"`

## Customizing installation parameters

While it is true both the default install parameters and automatic OS/platform detection will handle the vast majority of use cases, there might be special cases.
It is possible to change the default installation directories for the _Space_ program and shell auto completion support.

### install.sh

This script takes two optional parameters. The first one is the _Space_ program path and the second one is the auto completion path, where the customized _Space_ shell completion will get installed to. Paths can be either absolute or relative.

### Space module

The _/install/_ node is defined inside the base Module that comes with _Space_ (Spacefile.yaml,bash). This Module is the actual installer and can read the same optional arguments as _install.sh_, which are the program path and the auto completion path for installing files, respectively.

