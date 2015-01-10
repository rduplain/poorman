poorman_path() {
    # Print path to poorman script.

    local dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
    local filepath=$dir/poorman
    if [ ! -e $filepath ]; then
        echo "error: poorman not found: $filepath" >&2
        return 1
    fi
    echo $filepath
}

. `poorman_path` source
