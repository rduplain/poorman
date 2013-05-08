## poorman: shell port of foreman for Procfile and .env.

### Motivation

 1. Ensure managed processes actually die on exit.
 2. Handle stdout smoothly, without unusual buffering.
 3. Be fast on Unix-like systems.

### References

 * http://ddollar.github.io/foreman/
 * http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
 * https://devcenter.heroku.com/articles/procfile
