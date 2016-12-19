#!/bin/bash -e

if [[ -e ./commands/lib.sh ]]; then
    source ./commands/lib.sh
else
    source .flow-lib
fi

flag=$1
if [[ $flag == "--simple" ]]; then
    export simple=true
    shift
fi

args=()
for arg in "$@"; do
    args+=("$arg")
done

group "${args[@]}"
exit $?
