#!/bin/bash

set -e

gitroot=$(git rev-parse --show-toplevel || echo ".")
if [ ! -d "${gitroot}" ]; then
    exit 1
fi

pre_commit_file="${gitroot}/.git/hooks/pre-commit"
pre_commit_file_impl="${gitroot}/scripts/pre-commit/pre_commit_hooks.sh"

if [ ! -f ${pre_commit_file_impl} ]; then
    echo "pre_commit_hooks.sh does not exist at path $pre_commit_file_impl."
    exit 1
fi

if [ ! -f ${pre_commit_file} ]; then
    cp $gitroot/.git/hooks/pre-commit.sample $pre_commit_file
else
    rm $pre_commit_file
    cp $gitroot/.git/hooks/pre-commit.sample $pre_commit_file
fi

>$pre_commit_file
echo "#!/bin/sh" > $pre_commit_file
echo "" >> $pre_commit_file
echo "sh $pre_commit_file_impl" >> $pre_commit_file
echo "" >> $pre_commit_file
chmod a+x $pre_commit_file

echo "Installation finished!"
exit 0
