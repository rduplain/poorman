#!/usr/bin/env bats

load poorman_functions
load test_helper

@test "pass: smoke test" {
    run pass
    assert_equal "exit code" "0" "$status"
}

print_three_lines() {
    echo one
    echo two
    echo three
}

print_two_lines_then_fail() {
    echo one
    echo two
    return 1
}

print_two_lines_without_final_newline() {
    echo one
    echo -n two
}

print_three_lines_without_final_newline() {
    echo one
    echo two
    echo -n three
}

double_line() {
    echo "$@ $@"
}

fail_on_two() {
    echo "$@ $@"
    if [ "$@" = "two" ]; then
        return 1
    fi
}

@test "map_lines: no command given" {
    fn() {
        echo one | map_lines
    }
    run fn
    assert_equal "line 1" "error: no command given to map_lines" "${lines[0]}"
    assert_equal "line 2" "usage: map_lines COMMAND" "${lines[1]}"
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "exit code" 2 $status
}

@test "map_lines: one line" {
    fn() {
        echo one | map_lines double_line
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "number of lines" 1 ${#lines[@]}
    assert_equal "exit code" 0 $status
}

@test "map_lines: one line without newline" {
    fn() {
        echo -n one | map_lines double_line
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "number of lines" 1 ${#lines[@]}
    assert_equal "output" "one one" "$output"
    assert_equal "exit code" 0 $status
}

@test "map_lines: three lines" {
    fn() {
        print_three_lines | map_lines double_line
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "line 3" "three three" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
    assert_equal "exit code" 0 $status
}

@test "map_lines: failure of line function stops execution" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "exit code" 1 $status
}

@test "map_lines: failure of line function propagates status code" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    assert_equal "exit code" 1 $status
}

@test "map_lines: failure of mapped function propagates status code" {
    fn() {
        print_two_lines_then_fail | map_lines double_line
    }
    run fn
    assert_equal "exit code" 1 $status
}

@test "map_lines: three lines without final newline" {
    fn() {
        print_three_lines_without_final_newline | map_lines double_line
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "line 3" "three three" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
    assert_equal "exit code" 0 $status
}

@test "map_lines: three lines without final newline, failure on second line" {
    fn() {
        print_three_lines_without_final_newline | map_lines fail_on_two
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "exit code" 1 $status
}

@test "map_lines: two lines without final newline, failure on second line" {
    fn() {
        print_two_lines_without_final_newline | map_lines fail_on_two
    }
    run fn
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "exit code" 1 $status
}

@test "map_lines: command with arguments" {
    fn() {
        print_three_lines | map_lines echo argument1 argument2
    }
    run fn
    assert_equal "line 1" "argument1 argument2 one" "${lines[0]}"
    assert_equal "line 2" "argument1 argument2 two" "${lines[1]}"
    assert_equal "line 3" "argument1 argument2 three" "${lines[2]}"
    assert_equal "number of lines" 3 ${#lines[@]}
    assert_equal "exit code" 0 $status
}

@test "pick_color: fail gracefully when no argument" {
    run pick_color
    assert_equal "output" "" "$output"
    assert_equal "exit code" 0 $status
}

@test "pick_color: sample a color" {
    run pick_color 4
    assert_equal "output" "\033[31m" "$output"
    assert_equal "exit code" 0 $status
}

@test "source_dotenv: source .env" {
    fixture basic_env
    unset DOT
    source_dotenv .env
    assert_equal '$DOT' "-" "$DOT"
    unset DOT
}

@test "source_dotenv: source env with nonstandard filepath" {
    fixture basic_env_with_nonstandard_envfile
    unset DOT
    source_dotenv env
    assert_equal '$DOT' "-" "$DOT"
    unset DOT
}

do_parse_procfile_line() {\
    parse_procfile_line NAME COMMAND "$1";
    echo $NAME
    echo $COMMAND
}

@test "parse_procfile_line: statement" {
    run do_parse_procfile_line "foo: echo bar"
    assert_equal "name" "foo" "${lines[0]}"
    assert_equal "command" "echo bar" "${lines[1]}"
}

@test "parse_procfile_line: blank line" {
    run do_parse_procfile_line ""
    assert_equal "name" "" "${lines[0]}"
    assert_equal "command" "" "${lines[1]}"
}

@test "parse_procfile_line: whitespace-only line" {
    run do_parse_procfile_line "   "
    assert_equal "name" "" "${lines[0]}"
    assert_equal "command" "" "${lines[1]}"
}

@test "parse_procfile_line: comment" {
    run do_parse_procfile_line "    # this is a comment";
    assert_equal "name" "" "${lines[0]}"
    assert_equal "command" "" "${lines[1]}"
}

@test "parse_procfile_line: statement with comment" {
    run do_parse_procfile_line "foo: echo hello # this is a comment";
    assert_equal "name" "foo" "${lines[0]}"
    assert_equal "command" "echo hello # this is a comment" "${lines[1]}"
}

@test "parse_procfile_line: statement with hash in quotes" {
    run do_parse_procfile_line "foo: echo '#hello'";
    assert_equal "name" "foo" "${lines[0]}"
    assert_equal "command" "echo '#hello'" "${lines[1]}"
}

@test "parse_procfile_line: statement with hash in expression" {
    run do_parse_procfile_line 'foo: echo ${0##*/}: There are $# arguments';
    assert_equal "name" "foo" "${lines[0]}"
    assert_equal "command" 'echo ${0##*/}: There are $# arguments' "${lines[1]}"
}

