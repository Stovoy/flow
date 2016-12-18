#!/bin/bash -e

if [[ -e ./commands/lib.sh ]]; then
    source ./commands/lib.sh
else
    source .flow-lib
fi

group "$@"
exit $?
