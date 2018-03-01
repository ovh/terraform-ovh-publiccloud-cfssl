#!/bin/bash

REGIONS=${1:-$OS_REGION_NAME}
DIRS=(cfssl-public-server cfssl-private-server cfssl-public-server-cl cfssl-private-server-cl)

if [ ! -f "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent) && ssh-add ${TEST_SSH_PRIVATE_KEY:-$HOME/.ssh/id_rsa}
fi

EXIT=0
for d in ${DIRS[@]}; do
    for r in $REGIONS; do
        $(dirname $0)/runtest.sh "$(dirname $0)/../examples/$d" "$r"
        exit_test=$?
        echo "test $d exited with $exit_test" >&2
        EXIT=$((EXIT+exit_test))
    done
done

exit $EXIT
