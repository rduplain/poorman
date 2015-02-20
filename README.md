## poorman: shell port of foreman for Procfile and .env.

[![Build Status][build]](https://travis-ci.org/rduplain/poorman)
[![Coverage Status][coverage]](https://coveralls.io/r/rduplain/poorman)


### Usage

To install, put `poorman` in `$PATH`, then run `poorman start` in a directory
with a Procfile (and optionally a .env file).

To test poorman, run `make test`.

### Motivation

 1. Ensure managed processes actually die on exit.
 2. Handle stdout smoothly, without unusual buffering.
 3. Be fast on Unix-like systems.

### References

 * http://ddollar.github.io/foreman/
 * http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
 * https://devcenter.heroku.com/articles/procfile

### Test Coverage Report

Install the `bashcov` ruby gem, run `bashcov make test`, then open
`coverage/index.html` to view the report (tested with bashcov 1.0.1 on ruby
2.2.0).


[build]: https://travis-ci.org/rduplain/poorman.svg?branch=master
[coverage]: https://coveralls.io/repos/rduplain/poorman/badge.svg?branch=master
