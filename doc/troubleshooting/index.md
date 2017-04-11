---
title: Trouble shooting
weight: 1100
icon: "<b>11. </b>"
---

# Trouble shooting

Error:  
```sh
bash: line 51: cannot create temp file for here-document: No space left on device
```
Why:  
This is likely due to that the remote machine has no space left on disk and Bash does create and use temporary files.

Solution:  
SSH into the machine using the `ssh` module and delete old log files, etc
to free up some space.  
For example:  
```sh
$ space -m ssh /wrap/ -e SSHHOST=1.2.3.4\ 1.2.3.5 -e SSHUSER=user1\ user2 -e SSHKEYFILE=id_rsa.machine1\ id_rsa.machine2 -m os /shell/
```
