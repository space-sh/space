---
prev: ../
prev_title: "Space Modules"
next: ../what-are-space-modules/
next_title: "What are Space Modules"
title: Why Space modules
weight: 501
---

# Why Space modules

One of the first important requirements around the design of _Space_ is to empower programmers to describe complex behaviors using straightforward rules and script code, taking advantage of decades old base technology provided by _UNIX-like_ tools. The idea of creating more power without adding platform constraints or compromises has always been the primary aim when developing _Space_. Also, in the event of external dependencies, _Space_ should always aid the user to install all the requirements without extra work.  

_Space_ is designed to be lean - small in disk size, with few lines of code and most importantly a public _API_ which is as simple as possible without compromising on function. In order to expand core functionality, users describe an extension, called Module, and define its functions via shell code. Modules can contain their own functions and also refer to functions from other modules which they are dependent on. The resulting composition will become exported as a single script file.This strategy makes it possible to create new modules from existing modules, by mixing, matching and composing them. The exported script enables offline usage and code audition, by delivering _POSIX-friendly_ program output.  

Decentralization is one of the core principles of _Space_. For this reason, user created content can exist in any _Git_ repository.
