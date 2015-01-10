assert_equal() {
    if [ "$2" != "$3" ]; then
        echo "test:     $1" >&2
        echo "expected: $2" >&2
        echo "actual:   $3" >&2
        return 1
    fi
}
