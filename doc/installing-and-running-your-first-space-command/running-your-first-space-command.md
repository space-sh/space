---
prev: ../verifying-installation/
prev_title: "Verifying installation"
next: /space-modules/
next_title: "Space Modules"
title: Running your first Space command
weight: 406
---

# Running your first Space command

With the _Space_ program available on the system, it is now possible to run the most basic command.  
Create a new file named `Spacefile.yaml` and add the following contents to it:  

```yaml
_env:  
    - RUN: printf "Hello World\n"  
```

Now run `space` and it should output `Hello World` to the console `stdout`.

Next section describes what _Space_ modules are. For jumping right into more code, see _Running a Space module_ section.
