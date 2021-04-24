#!/bin/sh

set -e
trap 'echo "Trapped"' QUIT INT KILL

/conf_update

# run
/entrypoint.sh $@