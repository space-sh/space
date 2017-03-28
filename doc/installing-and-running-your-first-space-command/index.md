---
prev: /how-space-works/
prev_title: "How Space works"
next: ./installing-from-latest-tarball/
next_title: "Installing from latest tarball"
title: Installing and running your first Space command
weight: 400
icon: "<b>4. </b>"
---

# Installing and running your first Space command

Manual install can be performed by downloading the _release tarball_ and using _Space_ itself to install the release files on the system. This process does not perform any file integrity checks, neither does it verify _GPG_ signatures.  

The other method is performing the automatic install process by using the _Space_ installer script, which is automatically generated on every new _Space_ release to match the new version and new file hashes. This method automatically performs file integrity checks (shasum) on the downloaded files to ensure the files were not corrupted or modified before installing.  

Release files are expected to contain at least the following set of items:  
- `space-<version>.tar.gz`: the release tarball  
- `space-<version>.tar.gz.asc`: _GPG_ signature for the release tarball  
- `space-<version>.sha`: _shasum_ hash for the release tarball  
- `space-<version>.sha256`: _shasum_ hash for the release tarball  
- `space-<version>.md5`: _MD5_ hash for the release tarball  
- `install-<version>.sh`: installer script which installs the tarball automatically  
- `space-<version>.md`: auto-generated code documentation  

Default _Space_ installs to `/usr/local/bin` that requires administrator rights in order to succeed.
