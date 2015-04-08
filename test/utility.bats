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

@test "map_lines: one line" {
    fn() {
        echo one | map_lines double_line
    }
    run fn
    assert_equal "number of lines" 1 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "exit code" 0 $status
}

@test "map_lines: one line without newline" {
    fn() {
        echo -n one | map_lines double_line
    }
    run fn
    assert_equal "number of lines" 1 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "output" "one one" "$output"
    assert_equal "exit code" 0 $status
}

@test "map_lines: three lines" {
    fn() {
        print_three_lines | map_lines double_line
    }
    run fn
    assert_equal "number of lines" 3 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "line 3" "three three" "${lines[2]}"
    assert_equal "exit code" 0 $status
}

@test "map_lines: failure of line function stops execution" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
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
    assert_equal "number of lines" 3 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "line 3" "three three" "${lines[2]}"
    assert_equal "exit code" 0 $status
}

@test "map_lines: three lines without final newline, failure on second line" {
    fn() {
        print_three_lines_without_final_newline | map_lines fail_on_two
    }
    run fn
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "exit code" 1 $status
}

@test "map_lines: two lines without final newline, failure on second line" {
    fn() {
        print_two_lines_without_final_newline | map_lines fail_on_two
    }
    run fn
    assert_equal "number of lines" 2 ${#lines[@]}
    assert_equal "line 1" "one one" "${lines[0]}"
    assert_equal "line 2" "two two" "${lines[1]}"
    assert_equal "exit code" 1 $status
}

@test "pick_color: fail gracefully when no argument" {
    run pick_color
    assert_equal "output" "" "$output"
    assert_equal "exit code" 0 $status
}

@test "pick_color: sample a color" {
    run pick_color 2
    assert_equal "output" "\033[31m" "$output"
    assert_equal "exit code" 0 $status
}
