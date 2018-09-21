#!/usr/bin/env bash
# Provide test process coordination using a fifo file.
#
# Run a coordination process:
#
#     bash fifo.bash FIFO_PATH NUMBER_OF_WRITES
#
# Set NUMBER_OF_WRITES to the expected number of `ping_fifo` calls.
# In separate bash programs:
#
#     set -e
#     . fifo.bash source
#     wait_for_fifo    FIFO_PATH # before action
#     ping_fifo        FIFO_PATH # on each action
#     wait_for_fifo_rm FIFO_PATH # once complete, to wait for other processes

FIFO_SLEEP_SECONDS=${FIFO_SLEEP_SECONDS:-0.01}

ping_fifo() {
    # Write to fifo to ping the process reading the fifo.

    local fifo="$1"
    shift

    if [ "$fifo" = "/dev/null" ]; then
        return 0
    fi

    if [ ! -p "$fifo" ]; then
        echo "error: not a fifo: $fifo" >&2
        return 3
    fi

    echo ping >> "$fifo"
}

wait_for_fifo() {
    # Wait for given fifo file to appear.

    local fifo="$1"
    shift

    if [ "$fifo" = "/dev/null" ]; then
        return 0
    fi

    while [ ! -e "$fifo" ]; do
        sleep $FIFO_SLEEP_SECONDS
    done

    if [ ! -p "$fifo" ]; then
        echo "File exists but is not a fifo: $fifo" >&2
        return 3
    fi
}

wait_for_rm_fifo() {
    # Wait until file is removed.

    local fifo="$1"
    shift

    if [ "$fifo" = "/dev/null" ]; then
        return 0
    fi

    while [ -e "$fifo" ]; do
        sleep $FIFO_SLEEP_SECONDS
    done
}

main() {
    # Run a fifo monitoring process, or provide source functions.

    if [ "$1" = "source" ]; then
        return 0
    fi

    if [ $# -ne 2 ]; then
        echo "usage: fifo.bash FIFO_PATH NUMBER_OF_WRITES" >&2
        return 2
    fi

    local fifo="$1"
    local count="$2"
    shift 2

    if [ ! $count -gt 0 ]; then
        echo "error: Provide a non-zero number of writes." >&2
        return 2
    fi

    if [ -e "$fifo" ]; then
        echo "error: file already exists: $fifo." >&2
        return 3
    fi

    mkfifo "$fifo"

    trap "rm -f '$fifo'; trap - INT TERM EXIT; exit" INT TERM EXIT

    while [ $count -gt 0 ]; do
        IFS= read -r line
        if [ -z "$line" ]; then
            sleep $FIFO_SLEEP_SECONDS
            continue
        fi
        let count=count-1
    done < "$fifo"

    sleep $FIFO_SLEEP_SECONDS

    return 0
}

main "$@"
