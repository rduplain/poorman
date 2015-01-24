assert_equal() {
    local test=$1
    local expected=$2
    local actual=$3

    if [ $# -ne 3 ]; then
        # Incorrect usage of this function.
        test="number of arguments"
        expected=3
        actual=$#
        return 1
    fi

    if [ "$expected" != "$actual" ]; then
        echo "test:     $test" >&2
        echo "expected: $expected" >&2
        echo "actual:   $actual" >&2
        return 1
    fi
}

assert_does_not_exist() {
    assert_equal "number of arguments" "2" "$#"
    local test=$1
    local file=$2
    if [ -e $file ]; then
        echo "test:     $test" >&2
        echo "failure:  $file exists" >&2
        return 1
    fi
}
