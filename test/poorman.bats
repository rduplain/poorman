#!/usr/bin/env bats

load test_helper
load poorman

USAGE_LINE="usage: poorman start [PROCESS]        # Start processes."

@test "poorman: invocation without arguments prints usage" {
    run_poorman
    assert_equal "usage line" "$USAGE_LINE" "${lines[0]}"
    assert_equal "exit code" 2 $status
}

@test "poorman: invocation with invalid subcommand prints usage" {
    run_poorman fake
    assert_equal "error line" "error: no such command: fake" "${lines[0]}"
    assert_equal "usage line" "$USAGE_LINE" "${lines[1]}"
    assert_equal "exit code" 2 $status
}

@test "poorman: invocation without Procfile prints usage" {
    fixture empty
    assert_does_not_exist "local Procfile does not exist when testing" Procfile
    run_poorman start
    assert_equal "error line" "error: Procfile does not exist" "${lines[0]}"
    assert_equal "usage line" "$USAGE_LINE" "${lines[1]}"
    assert_equal "exit code" 2 $status
}

@test "poorman: basic Procfile" {
    fixture basic
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | ." "${lines[0]}"
    assert_equal "line 2" "one   | .." "${lines[1]}"
    assert_equal "line 3" "one   | ..." "${lines[2]}"
    assert_equal "line 4" "three | ." "${lines[3]}"
    assert_equal "line 5" "three | .." "${lines[4]}"
    assert_equal "line 6" "three | ..." "${lines[5]}"
    assert_equal "line 7" "two   | ." "${lines[6]}"
    assert_equal "line 8" "two   | .." "${lines[7]}"
    assert_equal "line 9" "two   | ..." "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with .env" {
    fixture basic_env
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | -" "${lines[0]}"
    assert_equal "line 2" "one   | --" "${lines[1]}"
    assert_equal "line 3" "one   | ---" "${lines[2]}"
    assert_equal "line 4" "three | -" "${lines[3]}"
    assert_equal "line 5" "three | --" "${lines[4]}"
    assert_equal "line 6" "three | ---" "${lines[5]}"
    assert_equal "line 7" "two   | -" "${lines[6]}"
    assert_equal "line 8" "two   | --" "${lines[7]}"
    assert_equal "line 9" "two   | ---" "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with .env containing a shell parameter" {
    fixture basic_env_parameter
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | x" "${lines[0]}"
    assert_equal "line 2" "one   | xx" "${lines[1]}"
    assert_equal "line 3" "one   | xxx" "${lines[2]}"
    assert_equal "line 4" "three | x" "${lines[3]}"
    assert_equal "line 5" "three | xx" "${lines[4]}"
    assert_equal "line 6" "three | xxx" "${lines[5]}"
    assert_equal "line 7" "two   | x" "${lines[6]}"
    assert_equal "line 8" "two   | xx" "${lines[7]}"
    assert_equal "line 9" "two   | xxx" "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with .env, both with additional empty lines" {
    fixture basic_env_with_empty_lines
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | -" "${lines[0]}"
    assert_equal "line 2" "one   | --" "${lines[1]}"
    assert_equal "line 3" "one   | ---" "${lines[2]}"
    assert_equal "line 4" "three | -" "${lines[3]}"
    assert_equal "line 5" "three | --" "${lines[4]}"
    assert_equal "line 6" "three | ---" "${lines[5]}"
    assert_equal "line 7" "two   | -" "${lines[6]}"
    assert_equal "line 8" "two   | --" "${lines[7]}"
    assert_equal "line 9" "two   | ---" "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with .env with '=' in a comment" {
    fixture basic_env_with_commented_assignment
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | v" "${lines[0]}"
    assert_equal "line 2" "one   | vv" "${lines[1]}"
    assert_equal "line 3" "one   | vvv" "${lines[2]}"
    assert_equal "line 4" "three | v" "${lines[3]}"
    assert_equal "line 5" "three | vv" "${lines[4]}"
    assert_equal "line 6" "three | vvv" "${lines[5]}"
    assert_equal "line 7" "two   | v" "${lines[6]}"
    assert_equal "line 8" "two   | vv" "${lines[7]}"
    assert_equal "line 9" "two   | vvv" "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with a comment" {
    fixture basic_with_comment_in_procfile
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | ." "${lines[0]}"
    assert_equal "line 2" "one   | .." "${lines[1]}"
    assert_equal "line 3" "one   | ..." "${lines[2]}"
    assert_equal "line 4" "three | ." "${lines[3]}"
    assert_equal "line 5" "three | .." "${lines[4]}"
    assert_equal "line 6" "three | ..." "${lines[5]}"
    assert_equal "line 7" "two   | ." "${lines[6]}"
    assert_equal "line 8" "two   | .." "${lines[7]}"
    assert_equal "line 9" "two   | ..." "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile missing newline" {
    fixture basic_missing_newline
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | ." "${lines[0]}"
    assert_equal "line 2" "one   | .." "${lines[1]}"
    assert_equal "line 3" "one   | ..." "${lines[2]}"
    assert_equal "line 4" "three | ." "${lines[3]}"
    assert_equal "line 5" "three | .." "${lines[4]}"
    assert_equal "line 6" "three | ..." "${lines[5]}"
    assert_equal "line 7" "two   | ." "${lines[6]}"
    assert_equal "line 8" "two   | .." "${lines[7]}"
    assert_equal "line 9" "two   | ..." "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with .env missing newline" {
    fixture basic_env_missing_newline
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | +" "${lines[0]}"
    assert_equal "line 2" "one   | ++" "${lines[1]}"
    assert_equal "line 3" "one   | +++" "${lines[2]}"
    assert_equal "line 4" "three | +" "${lines[3]}"
    assert_equal "line 5" "three | ++" "${lines[4]}"
    assert_equal "line 6" "three | +++" "${lines[5]}"
    assert_equal "line 7" "two   | +" "${lines[6]}"
    assert_equal "line 8" "two   | ++" "${lines[7]}"
    assert_equal "line 9" "two   | +++" "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: basic Procfile with early failure of one process" {
    fixture basic_with_early_failure
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "emo    | I am happy." "${lines[0]}"
    assert_equal "line 2" "menace | I fail you." "${lines[1]}"
    assert_equal "number of lines" 2 ${#lines[@]}
}

@test "poorman: Procfile with a backslash" {
    fixture backslash_procfile
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "test | \\n" "${lines[0]}"
    assert_equal "number of lines" 1 ${#lines[@]}
}

@test "poorman: .env with a backslash" {
    fixture backslash_env
    run_poorman_filtered_without_timestamps start
    assert_equal "line 1" "test | \\n" "${lines[0]}"
    assert_equal "number of lines" 1 ${#lines[@]}
}

@test "poorman: .env with non-comment hashes" {
    fixture env_with_non_comment_hashes
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "channel      | #cville" "${lines[0]}"
    assert_equal "line 2" "email-domain | example.com" "${lines[1]}"
    assert_equal "line 3" "quoted       | Why is this # here?" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
}

@test "poorman: Procfile with .env, start just one command" {
    fixture env_with_distinct_commands
    run_poorman start command-one
    assert_equal "line 1" "Hello, world!" "${lines[0]}"
    assert_equal "line 2" "Hello, world!" "${lines[1]}"
    assert_equal "line 3" "Hello, world!" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
}

@test "poorman: start two commands, show error on number of commands" {
    fixture env_with_distinct_commands
    run_poorman start x y
    assert_equal "error line" "error: too many names given: x y" "${lines[0]}"
    assert_equal "exit code" 2 $status
}

@test "poorman: start one command, display an error when not found" {
    fixture env_with_distinct_commands
    run_poorman start xyz
    assert_equal "error line" "error: no command found for 'xyz'" "${lines[0]}"
    assert_equal "exit code" 2 $status
}

@test "poorman: Procfile with commands containing shell parameters" {
    fixture parameter_in_command
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "one   | x" "${lines[0]}"
    assert_equal "line 2" "one   | xx" "${lines[1]}"
    assert_equal "line 3" "one   | xxx" "${lines[2]}"
    assert_equal "line 4" "three | z" "${lines[3]}"
    assert_equal "line 5" "three | zz" "${lines[4]}"
    assert_equal "line 6" "three | zzz" "${lines[5]}"
    assert_equal "line 7" "two   | y" "${lines[6]}"
    assert_equal "line 8" "two   | yy" "${lines[7]}"
    assert_equal "line 9" "two   | yyy" "${lines[8]}"
    assert_equal "number of lines" 9 ${#lines[@]}
}

@test "poorman: start one process containing a shell parameter" {
    fixture parameter_in_command
    run_poorman start two
    assert_equal "line 1" "y" "${lines[0]}"
    assert_equal "line 2" "yy" "${lines[1]}"
    assert_equal "line 3" "yyy" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
}

@test "poorman: start one process containing another shell parameter" {
    fixture parameter_in_command
    run_poorman start three
    assert_equal "line 1" "z" "${lines[0]}"
    assert_equal "line 2" "zz" "${lines[1]}"
    assert_equal "line 3" "zzz" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
}

@test "poorman: Procfile with command containing a space" {
    fixture command_with_space
    run_poorman_filtered_without_timestamps start
    sort_lines
    assert_equal "line 1" "command1 | foo bar baz" "${lines[0]}"
    assert_equal "line 2" "command2 | foo bar baz" "${lines[1]}"
    assert_equal "number of lines" 2 ${#lines[@]}
}

@test "poorman: start one process containing a space" {
    fixture command_with_space
    run_poorman start command1
    assert_equal "line 1" "foo bar baz" "${lines[0]}"
    assert_equal "number of lines" 1 ${#lines[@]}
}

@test "poorman: run an arbitrary command" {
    fixture run_a_command
    run_poorman run ./test_command
    assert_equal "output" "This value is from a .env file." "${lines[0]}"
    assert_equal "exit code" 0 $status
}

@test "poorman: run a command with a space using backslash" {
    fixture command_with_space
    run_poorman run ./this\ command foo bar baz
    assert_equal "output" "foo bar baz" "${lines[0]}"
    assert_equal "exit code" 0 $status
}

@test "poorman: run a command with a space using quotes" {
    fixture command_with_space
    run_poorman run './this command' foo bar baz
    assert_equal "output" "foo bar baz" "${lines[0]}"
    assert_equal "exit code" 0 $status
}

@test "poorman: export refers to reference implementation" {
    fixture run_a_command
    run_poorman export
    export_error="poorman: export not implemented; use foreman export."
    assert_equal "output" "$export_error" "${lines[0]}"
    assert_equal "exit code" 2 $status
}

@test "poorman: check refers to reference implementation" {
    fixture run_a_command
    run_poorman check
    check_error="poorman: check not implemented; use foreman check."
    assert_equal "output" "$check_error" "${lines[0]}"
    assert_equal "exit code" 2 $status
}
