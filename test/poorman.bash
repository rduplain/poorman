# Load poorman_path function from poorman_functions.bash, and run it.
test_dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $test_dir/poorman_functions.bash source
_POORMAN_PATH=`poorman_path`

run_poorman() {
    # Run poorman with bats `run` command in poorman selective kill mode.

    export POORMAN_SELECTIVE_KILL=true
    run $_POORMAN_PATH "$@"
}

filter_control_sequences() {
    # Lifted from bats project, filter terminal control sequences.

    "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
}

run_poorman_filtered() {
    # Run poorman, filtering terminal control sequences.

    export POORMAN_SELECTIVE_KILL=true
    run filter_control_sequences $_POORMAN_PATH "$@"
}

cut_timestamps() {
    # Cut poorman timestamps, by cutting first field of each line.

    "$@" | cut -f 2- -d " "
}

run_poorman_filtered_without_timestamps() {
    # Run poorman, filtering terminal control sequences and cutting

    export POORMAN_SELECTIVE_KILL=true
    run filter_control_sequences cut_timestamps $_POORMAN_PATH "$@"
}
