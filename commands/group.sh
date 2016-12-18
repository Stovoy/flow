#!/bin/bash -e

if which .flow-lib; then
    source .flow-lib
else
    source ./commands/lib.sh
fi

group "$@"
exit $?
