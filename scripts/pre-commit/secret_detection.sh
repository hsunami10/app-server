#!/bin/bash
#
# Warn and prompts for confirmation in case potential secrets are found in the staged code.
#
# Source of most regexes: https://github.com/l4yton/RegHex and
# https://github.com/Yelp/detect-secrets/tree/master/detect_secrets/plugins

found=0

# Define list of REGEX to be searched and blocked
regex_list=(
 # artifactory
 '(?:\s|=|:|"|^)AKC[a-zA-Z0-9]{10,}'
 # basic auth
 "Basic (eyJ|YTo|Tzo|PD[89]|aHR0cHM6L|aHR0cDo|rO0)[a-zA-Z0-9+/]+={0,2}"
 # stripe
 '(?:r|s)k_live_[0-9a-zA-Z]{24}'
 # heroku
 '[h|H][e|E][r|R][o|O][k|K][u|U].{0,30}[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}'
 # google
 "(?i)(google|gcp|youtube|drive|yt)(.{0,20})?['\"][AIza[0-9a-z\\-_]{35}]['\"]"
 "AIza[0-9A-Za-z\\-_]{35}"
 "[A-Za-z0-9_]{21}--[A-Za-z0-9_]{8}"
 # slack
 'xox[baprs]-([0-9a-zA-Z]{10,48})?'
 # twilio
 'SK[0-9a-fA-F]{32}'
 # github
 "(?i)github(.{0,20})?(?-i)['\"][0-9a-zA-Z]{35,40}"
 # fexport api keys
 # mailchimp
 '[0-9a-f]{32}-us[0-9]{1,2}'
 # mailgun
 'key-[0-9a-zA-Z]{32}'
 # square
 'sqOatp-[0-9A-Za-z\\-_]{22}'
 'sq0csp-[ 0-9A-Za-z\\-_]{43}'
 # private key file
 '(\-){5}BEGIN\s?(RSA|OPENSSH|DSA|EC|PGP)?\s?PRIVATE KEY\s?(BLOCK)?(\-){5}.*'
 # AWS
 '(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}'
 'amzn\.mws\.[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
 "(?i)aws(.{0,20})?(?-i)['\"][0-9a-zA-Z\/+]{40}['\"]"
 # block keywords
 'CONFIDENTIAL'
 # auth bearer
 'bearer [a-zA-Z0-9_\\-\\.=]+'
 # jwt
 "eyJ[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.?[A-Za-z0-9\-_.+/=]*?"
 # TODO: passwords / passphrases
)
 
# concatenate regex_list
separator="|"
regex="$( printf "${separator}%s" "${regex_list[@]}" )"
# remove leading separator
regex="${regex:${#separator}}"
 
 
# only checking for staged code
# TODO: check for submodules
match=`git diff HEAD --cached | grep -oE "(${regex})"`
files=`git diff HEAD --cached --name-only`
 
# Verify its not empty
if [ "${match}" != "" ]; then
 found=$((${found} + 1))
fi

###############################
# Verify count of found secrets
###############################

if [ ${found} -gt 0 ]; then
   printf "SECURITY ALERT - The code your are about to commit might contain a secret or some confidential information. Here is what we think is a secret:\n"
   # Print filename and line numbers
   for file in "${files[@]}"; do
       grep -EnH "(${regex})" $file
   done
   printf "\nNOTE: If you are using any secret for testing, simply append an inline 'pragma: allowlist secret' comment and ignore this message for that secret. This would help our server-side checks ignore the secret."
   printf "\nReach out to #ask-security slack channel if you have any questions."
   printf "\n\nWould you still like to continue with the commit? (yes/no): "
   # Allows us to read user input below, assigns stdin to keyboard
   exec < /dev/tty
 
   read response
 
   if [ "$response" = "yes" ] || [ "$response" = "Yes" ] || [ "$response" = "YES" ]; then
       # Exit with success
       printf "\nCommit successfull!\n\n"
       exit 0
   else
       # Exit with failure
       printf "\nNothing commited!\n\n"
       exit 1
   fi
fi
