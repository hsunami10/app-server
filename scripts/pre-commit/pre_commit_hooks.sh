#!/bin/bash

# Git pre-commit checks
set -e

gitroot=$(git rev-parse --show-toplevel || echo ".")
if [ ! -d "${gitroot}" ]; then
    exit 1
fi

# Determine whether a merge is in progress.
# From: https://stackoverflow.com/a/30783114
# if [ -f .git/MERGE_HEAD ]
# then
#   is_merge_in_progress=true
# else
#   is_merge_in_progress=false
# fi

ALL_DIFFED_FILES=$(git diff --cached --name-only | tr '\n' ' ')

# DIFFED_FILES_IN_MOBILE_APP=`git diff HEAD --cached --name-only --diff-filter=ACMR -- 'mobile/drive/*.js'`
# DELETED_MIGRATION_FILES=`git diff --cached --name-only --diff-filter=D '*db/migrate/*.rb' '*db/old_migrations/*.rb'`
 
# Check if engineer update Gemfile.lock when new Gems are added
# DIFFED_GEMFILE=`git diff HEAD --cached --name-only --diff-filter=ACMR -- 'Gemfile'`
# DIFFED_GEMLOCK=`git diff HEAD --cached --name-only --diff-filter=ACMR -- 'Gemfile.lock'`
# DIFFED_GEM_RBIS=`git diff HEAD --cached --name-only --diff-filter=ACMR -- 'sorbet/rbi/gems/'`
# if [ -n "$DIFFED_GEMFILE" ] && ([ -z "$DIFFED_GEMLOCK" ] || [ -z "$DIFFED_GEM_RBIS" ]); then
#  echo "Changed Gemfile without updating Gemfile.lock and/or sorbet/rbi/gems"
#  echo "Please run <bundle install> to update Gemfile.lock, and <bundle exec tapioca sync> to update rbi files"
#  echo "If you made a change to the Gemfile that does not affect Gemfile.lock/rbis and is regenerating the same exact files, please verify and commit using the --no-verify option, "
#  exit 1
# fi
 
# Update routes if needed
# DIFFED_RB_ROUTES=`git diff HEAD --cached --name-only --diff-filter=ACMR -- 'config/routes/core.rb' 'config/routes/www.rb' 'config/routes/partner.rb' 'config/routes/dispatch.rb'`
# DIFFED_JAVASCRIPT_ROUTES=`git diff HEAD --cached --name-only --diff-filter=ACMR -- 'webpack/assets/javascripts/routes.js'`
# if [ -n "$DIFFED_RB_ROUTES" ] && [ -z "$DIFFED_JAVASCRIPT_ROUTES" ]; then
#  echo "Changed routes"
#  echo "$DIFFED_RB_ROUTES"
#  echo "Please run bundle exec rake js:routes to update routes"
#  echo "If you made a change that does not affect routes.js and is regenerating the same exact file, please verify and commit using -n"
#  exit 1
# fi
 
# Check for 'DO NOT  COMMIT' comments in code. Only one space in actual regex, but two in comment to miss check here.
SOURCE_DIFFED_FILES=`git diff HEAD --cached --name-only --diff-filter=ACMR -- '*'`
BLOCK_COMMIT_PATTERN='DO NOT COMMI[T]'
if output=$(grep -q "$BLOCK_COMMIT_PATTERN" $SOURCE_DIFFED_FILES); then
  grep --color=auto -Hn "$BLOCK_COMMIT_PATTERN" $SOURCE_DIFFED_FILES
  echo "Found commit blocking comments in the code."
  exit 1
fi
 
JS_JSX_JSON_DIFFED_FILES=`git diff HEAD --cached --name-only --diff-filter=ACMR -- '*.jsx' '*.js' '*.json'`
if [ -n "$JS_JSX_JSON_DIFFED_FILES" ]; then
  echo "$JS_JSX_JSON_DIFFED_FILES"
  # Ensure there aren't prettier problems.
  echo "Running prettier..."
  set +e
  PRETTIER_FILES=$(echo "$JS_JSX_JSON_DIFFED_FILES" | xargs yarn run --silent prettier --list-different 2>/dev/null)
  set -e
  if [ -n "$PRETTIER_FILES" ]; then
    echo "Your files aren't pretty. Let me fix that for you".
    echo "running yarn run prettier --write $PRETTIER_FILES"
    yarn run prettier --write $PRETTIER_FILES
    git add $PRETTIER_FILES
  fi
  echo "prettier complete!"
fi

JS_JSX_DIFFED_FILES=`git diff HEAD --cached --name-only --diff-filter=ACMR -- '*.jsx' '*.js'`
if [ -n "$JS_JSX_DIFFED_FILES" ]; then
  # Ensure there aren't eslint problems.
  echo "Running eslint..."
  if echo "$JS_JSX_DIFFED_FILES" | xargs yarn eslint ; then
    : # no-op
  else
    e=$? # return code from if
    if [ "${e}" -eq "1" ]; then
      echo "Your files aren't aren't linted correctly. Attempting to fix for you..."
      echo "running yarn run eslint --fix $JS_JSX_DIFFED_FILES"
      yarn run eslint --fix $JS_JSX_DIFFED_FILES
    elif [ "${e}" -gt "1" ]; then
      echo "yarn eslint returned an exit code > 1."
      exit ${e}
    fi
  fi
  echo "eslint complete!"

  # Run flow on changed files.
  echo "$JS_JSX_DIFFED_FILES"
  # Ensure types check out
  echo "Running strict flow checks..."
  yarn run flow --show-all-errors --max-warnings 0
  git add $JS_JSX_DIFFED_FILES
fi

# RB_DIFFED_FILES=`git diff HEAD --cached --name-only --diff-filter=ACMR -- '*.rb' '*.rbi'`
# if [ -n "$RB_DIFFED_FILES" ]; then
#  if $(bundle exec srb tc); then
#    echo "No Sorbet type errors."
#  else
#    echo "Sorbet type check failed."
#    exit 1
#  fi
# fi
 
# # Prediction pre-commit hooks
# sh ./script/flexport/prediction_pre_commit.sh
# # Protobuf pre-commit hooks
# sh ./script/flexport/protobuf_pre_commit.sh
# # Bazel pre-commit hooks
# sh ./script/flexport/bazel_pre_commit.sh
# # Java pre-commit hooks
# ruby ./script/flexport/java_pre_commit.rb
# # Genesis pre-commit hooks
# sh ./script/flexport/genesis_pre_commit.sh
 
# Secret detection
sh $gitroot/scripts/pre-commit/secret_detection.sh
 
# Ensure no commits to master
# protected_branch='main'
 
# policy="\n\nNEVER commit directly to the "$protected_branch" branch!\n\n"
 
# current_branch=$(git symbolic-ref --quiet HEAD | sed -e 's,.*/\(.*\),\1,')
 
# push_command=$(ps -ocommand= -p $PPID)
 
# do_exit(){
#  echo -e $policy
#  exit 1
# }
 
# Prevent ALL pushes to protected_branch
# if [[ $push_command =~ $protected_branch ]] || [ "$current_branch" = "$protected_branch" ]; then
#  do_exit
# fi
 
# unset do_exit
 
exit 0
 

