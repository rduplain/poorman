fixture() {
    export FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixture/$1"
    cd $FIXTURE_ROOT
}

sort_lines() {
    OLDIFS="$IFS"
    IFS=$'\n' lines=($(sort -n <<<"${lines[*]}"))
    IFS="$OLDIFS"
}

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

assert_not_equal() {
    assert_equal "number of arguments" "3" "$#"
    local test=$1
    local expected=$2
    local actual=$3
    if [ "$expected" == "$actual" ]; then
        echo "test:       $test" >&2
        echo "unexpected: $actual" >&2
        return 1
    fi
}

assert_is_number() {
    assert_equal "number of arguments" "2" "$#"
    local test=$1
    local value=$2
    case $value in
        ''|*[!0-9]*)
            echo "test:         $test" >&2
            echo "not a number: $value" >&2
            return 1
            ;;
        *)
            ;;
    esac
}
