This fixture tests poorman's `kill 0` implementation and consistent use of
poorman environment variables in case poorman calls poorman.

Given this complexity, and that the scripts enclosed do not trap to kill
backgrounded processes, this fixture is not able to be run with
`POORMAN_SELECTIVE_KILL` set. Instead, this fixture provides for developer
inspection. To test, change directories to this fixture and run:

    ./poorman start
    ^C # After a few moments.
    ps # See that no stray processes are running.
