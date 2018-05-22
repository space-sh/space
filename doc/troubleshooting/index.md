---
title: Troubleshooting
prev: /contributing/
prev_title: "Contributing"
weight: 1300
giturl: gitlab.com/space-sh/space
editurl: /edit/master/doc/troubleshooting/index.md
icon: "<b>13. </b>"
---

# Troubleshooting

### Error #1  
```sh
bash: line 51: cannot create temp file for here-document: No space left on device
```  

#### Reason  
Disk is likely to be full on remote machine.  

#### Explanation  
SSH connects to the SSH daemon on the remote machine which invokes the users login shell (in this case Bash) and then SSH streams the script to be run on the remote machine by the login shell. The login shell might need to create temporary files to interpret and handle the script.  
If the disk is full the shell cannot create temporary files at all.

#### Solution  
SSH into the machine using the `ssh` module and delete old log files, etc
to free up some space.  
For example:  
```sh
space -m ssh /ssh/ -- 1.2.3.4,1.2.3.5 user1,user2 id_rsa.machine1,id_rsa.machine2
```  

