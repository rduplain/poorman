#!/usr/bin/env bats

load test_helper

@test "poorman: invocation without arguments prints usage" {
    run ./poorman
    assert_equal "usage line" "usage: poorman start" "${lines[0]}"
    assert_equal "exit code" "2" "$status"
}
