#!/bin/bash

set -e

toml_update > /dev/null

if [ "${1:0:1}" == '-' ]; then
    set -- telegraf "$@"
fi

# allow running as root with --user root
exec "$@"
