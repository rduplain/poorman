## poorman: shell port of foreman for Procfile and .env.

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
