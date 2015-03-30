#!/usr/bin/env bats

load poorman_functions
load test_helper

print_three_lines() {
    cat <<EOF
one
two
three
EOF
}

print_two_lines_then_fail() {
    echo one
    echo two
    return 1
}

double_line() {
    echo "$@ $@"
}

fail_on_two() {
    if [ "$@" = "two" ]; then
        return 1
    else
        echo "$@"
    fi
}

@test "pass: smoke test" {
    run pass
    assert_equal "exit code" "0" "$status"
}

@test "map_lines: one line" {
    echo one | map_lines double_line | {
        run cat
        assert_equal "number of lines" 1 ${#lines[@]}
        assert_equal "line 1" "one one" "${lines[0]}"
    }
}

@test "map_lines: one line without newline" {
    echo -n one | map_lines double_line | {
        run cat
        assert_equal "number of lines" 0 ${#lines[@]}
        assert_equal "line 1" "" "${lines[0]}"
        assert_equal "output" "" "$output"
    }
}

@test "map_lines: three lines" {
    print_three_lines | map_lines double_line | {
        run cat
        assert_equal "number of lines" 3 ${#lines[@]}
        assert_equal "line 1" "one one" "${lines[0]}"
        assert_equal "line 2" "two two" "${lines[1]}"
        assert_equal "line 3" "three three" "${lines[2]}"
    }
}

@test "map_lines: failure of line function stops execution" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    assert_equal "number of lines" 1 ${#lines[@]}
    assert_equal "line 1" "one" "${lines[0]}"
}

@test "map_lines: failure of line function propagates status code" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    assert_equal "exit code" "1" "$status"
}

@test "map_lines: failure of mapped function propagates status code" {
    fn() {
        print_two_lines_then_fail | map_lines double_line
    }
    run fn
    assert_equal "exit code" "1" "$status"
}

@test "pick_color: fail gracefully when no argument" {
    run pick_color
    assert_equal "output" "" "$output"
    assert_equal "exit code" "0" "$status"
}

@test "pick_color: sample a color" {
    run pick_color 2
    assert_equal "output" "\033[31m" "$output"
    assert_equal "exit code" "0" "$status"
}
