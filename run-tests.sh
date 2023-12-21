#!/bin/sh

set -o errexit
set -o nounset

check_shellcheck () {
    shellcheck run-tests.sh
}

check_commitlint () {
    from=${2:-master}
    npx commitlint --from="$from" --verbose
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
