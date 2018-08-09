## poorman: a process control system written in shell, for development

[![Build Status][build]](https://travis-ci.org/rduplain/poorman)
[![Coverage Status][coverage]](https://coveralls.io/r/rduplain/poorman)

### Overview

poorman is a shell port of [foreman](http://ddollar.github.io/foreman/) for
process control using Procfile and .env files, for development on Unix-like
systems. Its only dependency is the bash shell (GNU bash 3.2.0+). It is
designed to run all processes specified in the Procfile in the current
directory, and exit all processes when any such process exits.

See [Profile documentation](https://devcenter.heroku.com/articles/procfile).
Either check static Procfile and .env files into version control, or build
these files dynamically with a build system.


### Usage

To install, put `poorman` in `$PATH`, make it executable (`chmod +x poorman`),
then run `poorman start` in a directory with a Procfile (and optionally a .env
file).


### Running Inside a Project's Environment

Most of the time, you only interact with poorman using `poorman start`.
This section describes how to interact within the environment as defined in .env.

To run commands inside your project's environment, run (with `poorman` in the
`$PATH`):

    poorman run COMMAND [ARGS...]

To have your shell source the .env in the same way that poorman does, so that
variables are available on the command line and to executed programs, you have
two options.

Option 1, start a new interactive shell session:

    poorman run $SHELL

Option 2, source poorman and call its internal `source_dotenv` utility:

    . poorman source
    source_dotenv

The `source_dotenv` utility takes an optional argument when not using `.env` as
the filepath:

    source_dotenv path/to/env

Note that poorman is written in bash, and is only tested with bash. If you are
using a shell other than bash, verify that option 2 works for your environment
before proceeding.

Both options 1 and 2 will setup the shell environment variables for further
interaction and execution. Changes to the .env file are not automatically
detected; either restart the shell (option 1) or call `source_dotenv` again
(option 2).


### Differences Between poorman and foreman

* poorman is written in shell (bash); foreman is written in Ruby.
* poorman only implements the `start` subcommand and does not support any
  option flags; if other subcommands are needed, in particular the `export`
  subcommand to write startup configuration files, use foreman directly.
* poorman has no scaling features; it only runs one process per command listed
  in the Procfile.
* poorman supports bash's full substitution/expansion feature set in .env.


### Motivation

The original motivation in porting from foreman:

1. Ensure managed processes actually die on exit.
2. Handle stdout smoothly, without unusual buffering.
3. Be fast and light on resources on Unix-like systems.

Further development was motivated by having a lightweight process control
system written in shell, for minimal dependencies with a single script
download. This makes poorman particularly well-suited for local integration
development using classic build tools such as GNU make, where a target such as
`make run` could download and invoke poorman to further invoke all processes
configured for the project.


### References

* http://ddollar.github.io/foreman/
* http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
* https://devcenter.heroku.com/articles/procfile


### Contributor Notes

To test poorman, run `make test`.


#### Debugging Poorman

Any bash program written in `set -e` mode will exit immediately upon failure,
and if the failure case was not predicted by the programmer, then there may be
limited log information before the program exits. In these cases, `bash -x
path/to/poorman start` is useful to see what is happening. If `poorman` is in
`$PATH`, use:

    bash -x poorman start


#### Test Coverage Report

Run:

    make coverage

Alternative, install the `bashcov` ruby gem, then run `bashcov make test`. View
the report at `coverage/index.html` (tested with bashcov 1.1.0 on ruby
2.2.0).


#### Static Checking in Shell

[ShellCheck](http://www.shellcheck.net/) is a static checker (i.e. linter) for
shell programs. It is available on Ubuntu/Debian via `sudo apt-get install
shellcheck` since Ubuntu 14.04.


[build]: https://travis-ci.org/rduplain/poorman.svg?branch=master
[coverage]: https://coveralls.io/repos/rduplain/poorman/badge.svg?branch=master
