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
    [ $status -eq 0 ]
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

@test "map_lines: failure stops execution" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    assert_equal "number of lines" 1 ${#lines[@]}
    assert_equal "line 1" "one" "${lines[0]}"
}

@test "map_lines: failure propagates status code" {
    fn() {
        print_three_lines | map_lines fail_on_two
    }
    run fn
    [ $status -eq 1 ]
}
