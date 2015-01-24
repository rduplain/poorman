#!/usr/bin/env bats

load test_helper

@test "poorman: invocation without arguments prints usage" {
    run ./poorman
    assert_equal "usage line" "usage: poorman start" "${lines[0]}"
    assert_equal "exit code" "2" "$status"
}

@test "poorman: invocation with invalid subcommand prints usage" {
    run ./poorman fake
    assert_equal "error line" "error: no such command: fake" "${lines[0]}"
    assert_equal "usage line" "usage: poorman start" "${lines[1]}"
    assert_equal "exit code" "2" "$status"
}

@test "poorman: invocation without Procfile prints usage" {
    assert_does_not_exist "local Procfile does not exist when testing" Procfile
    run ./poorman start
    assert_equal "error line" "error: Procfile does not exist" "${lines[0]}"
    assert_equal "usage line" "usage: poorman start" "${lines[1]}"
    assert_equal "exit code" "2" "$status"
}
