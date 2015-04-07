#!/usr/bin/env bats

load test_helper
load poorman

@test "poorman: invocation without arguments prints usage" {
    run_poorman
    assert_equal "usage line" "usage: poorman start" "${lines[0]}"
    assert_equal "exit code" "2" "$status"
}

@test "poorman: invocation with invalid subcommand prints usage" {
    run_poorman fake
    assert_equal "error line" "error: no such command: fake" "${lines[0]}"
    assert_equal "usage line" "usage: poorman start" "${lines[1]}"
    assert_equal "exit code" "2" "$status"
}

@test "poorman: invocation without Procfile prints usage" {
    fixture empty
    assert_does_not_exist "local Procfile does not exist when testing" Procfile
    run_poorman start
    assert_equal "error line" "error: Procfile does not exist" "${lines[0]}"
    assert_equal "usage line" "usage: poorman start" "${lines[1]}"
    assert_equal "exit code" "2" "$status"
}

@test "poorman: basic Procfile" {
    fixture basic
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "one   | ." "${lines[0]}"
    assert_equal "line 2" "two   | ." "${lines[1]}"
    assert_equal "line 3" "three | ." "${lines[2]}"
    assert_equal "line 4" "one   | .." "${lines[3]}"
    assert_equal "line 5" "two   | .." "${lines[4]}"
    assert_equal "line 6" "three | .." "${lines[5]}"
    assert_equal "line 7" "one   | ..." "${lines[6]}"
    assert_equal "line 8" "two   | ..." "${lines[7]}"
    assert_equal "line 9" "three | ..." "${lines[8]}"
}

@test "poorman: basic Procfile with .env" {
    fixture basic_env
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "one   | -" "${lines[0]}"
    assert_equal "line 2" "two   | -" "${lines[1]}"
    assert_equal "line 3" "three | -" "${lines[2]}"
    assert_equal "line 4" "one   | --" "${lines[3]}"
    assert_equal "line 5" "two   | --" "${lines[4]}"
    assert_equal "line 6" "three | --" "${lines[5]}"
    assert_equal "line 7" "one   | ---" "${lines[6]}"
    assert_equal "line 8" "two   | ---" "${lines[7]}"
    assert_equal "line 9" "three | ---" "${lines[8]}"
}

@test "poorman: basic Procfile with .env containing a shell parameter" {
    fixture basic_env_parameter
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "one   | x" "${lines[0]}"
    assert_equal "line 2" "two   | x" "${lines[1]}"
    assert_equal "line 3" "three | x" "${lines[2]}"
    assert_equal "line 4" "one   | xx" "${lines[3]}"
    assert_equal "line 5" "two   | xx" "${lines[4]}"
    assert_equal "line 6" "three | xx" "${lines[5]}"
    assert_equal "line 7" "one   | xxx" "${lines[6]}"
    assert_equal "line 8" "two   | xxx" "${lines[7]}"
    assert_equal "line 9" "three | xxx" "${lines[8]}"
}

@test "poorman: basic Procfile with .env, both with additional empty lines" {
    fixture basic_env_with_empty_lines
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "one   | -" "${lines[0]}"
    assert_equal "line 2" "two   | -" "${lines[1]}"
    assert_equal "line 3" "three | -" "${lines[2]}"
    assert_equal "line 4" "one   | --" "${lines[3]}"
    assert_equal "line 5" "two   | --" "${lines[4]}"
    assert_equal "line 6" "three | --" "${lines[5]}"
    assert_equal "line 7" "one   | ---" "${lines[6]}"
    assert_equal "line 8" "two   | ---" "${lines[7]}"
    assert_equal "line 9" "three | ---" "${lines[8]}"
}

@test "poorman: basic Procfile missing newline" {
    fixture basic_missing_newline
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "one   | ." "${lines[0]}"
    assert_equal "line 2" "two   | ." "${lines[1]}"
    assert_equal "line 3" "three | ." "${lines[2]}"
    assert_equal "line 4" "one   | .." "${lines[3]}"
    assert_equal "line 5" "two   | .." "${lines[4]}"
    assert_equal "line 6" "three | .." "${lines[5]}"
    assert_equal "line 7" "one   | ..." "${lines[6]}"
    assert_equal "line 8" "two   | ..." "${lines[7]}"
    assert_equal "line 9" "three | ..." "${lines[8]}"
}

@test "poorman: basic Procfile with .env missing newline" {
    fixture basic_env_missing_newline
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "one   | +" "${lines[0]}"
    assert_equal "line 2" "two   | +" "${lines[1]}"
    assert_equal "line 3" "three | +" "${lines[2]}"
    assert_equal "line 4" "one   | ++" "${lines[3]}"
    assert_equal "line 5" "two   | ++" "${lines[4]}"
    assert_equal "line 6" "three | ++" "${lines[5]}"
    assert_equal "line 7" "one   | +++" "${lines[6]}"
    assert_equal "line 8" "two   | +++" "${lines[7]}"
    assert_equal "line 9" "three | +++" "${lines[8]}"
}

@test "poorman: basic Procfile with early failure of one process" {
    fixture basic_with_early_failure
    run_poorman_filtered_without_timestamps start
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "line 1" "emo    | I am happy." "${lines[0]}"
    assert_equal "line 2" "menace | I fail you." "${lines[1]}"
}
