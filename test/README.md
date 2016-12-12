# Tests
This directory contains all tests needed in order to check SpaceGal shell. Each directory marks a subsystem or category in which the tests are performed.

## List of available tests

### test_all_exit_status
Tests all front-facing commands and options that can be issued by a regular user. Each test expects either an OK or FAILURE, checked via exit status code returned from each _Space_ program call. Tests also look for the existence of a particular text output caught from stdout/err, trying to match with an expected string to check for correct program behavior.

### test_core
Tests all core program functionalities which relate to global state and OS-specific and shell-specific behaviours.

### test_yaml
Tests all YAML related operations.

