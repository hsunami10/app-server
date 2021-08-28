#!/bin/sh

gitroot=$(git rev-parse --show-toplevel || echo ".")
if [ ! -d "${gitroot}" ]; then
  exit 1
fi

sh $gitroot/scripts/pre-commit/install_pre_commit_hook.sh
# sh $gitroot/scripts/psql/install.sh
sh $gitroot/scripts/watchman/setup.sh

