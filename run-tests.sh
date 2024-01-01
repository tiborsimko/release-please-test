#!/usr/bin/env bash

set -o errexit
set -o nounset

check_shellcheck () {
    shellcheck run-tests.sh
}

check_commitlint () {
    from=${2:-master}
    to=${3:-HEAD}
    npx commitlint --from="$from" --to="$to" --verbose
    found=0
    while IFS= read -r line; do
        if echo "$line" | grep -qP "\(\#[0-9]+\)$"; then
            echo "✔   PR number present in $line"
        else
            echo "✖   PR number missing in $line"
            found=1
        fi
    done < <(git log "$from..$to" --format="%s")
    if [ $found != "0" ]; then
        exit 1
    fi
}

check_all () {
    check_commitlint
    check_shellcheck
}

if [ $# -eq 0 ]; then
    check_all
    exit 0
fi

arg="$1"
case $arg in
    --check-commitlint) check_commitlint "$@";;
    --check-shellcheck) check_shellcheck;;
    *) echo "[ERROR] Invalid argument '$arg'. Exiting." && exit 1;;
esac
