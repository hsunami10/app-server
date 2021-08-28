#!/bin/sh

# https://medium.com/@aoc/simple-watchman-setup-ab006e97fb1d
# https://facebook.github.io/watchman/docs/cmd/trigger.html#extended-syntax

set -e

gitroot=$(git rev-parse --show-toplevel || echo ".")
if [ ! -d "${gitroot}" ]; then
    exit 1
fi

watchman watch-del-all
watchman watch-project $gitroot
watchman -j < "$gitroot/scripts/watchman/babelTrigger.json"
