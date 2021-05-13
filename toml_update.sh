#!/bin/sh

set -e

toml_update > /dev/null

/entrypoint.sh $@
