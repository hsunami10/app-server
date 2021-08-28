#!/bin/sh

# https://medium.com/@aoc/simple-watchman-setup-ab006e97fb1d

set -e

gitroot=$(git rev-parse --show-toplevel || echo ".")
if [ ! -d "${gitroot}" ]; then
    exit 1
fi

watchman watch-del-all
watchman watch-project $gitroot
watchman -j < "$gitroot/scripts/watchman/babelTrigger.json"
