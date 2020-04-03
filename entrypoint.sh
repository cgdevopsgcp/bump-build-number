#!/bin/sh
set -e

# Grab the current build information and output to json
printf 'Current build JSON\n'
codefresh get build $CF_BUILD_ID -o json
printf '\n\n'
# Use jq to traverse the json and grab the pipeline id
pipelineid=$(codefresh get build $CF_BUILD_ID -o json | jq '."pipeline-Id"')
printf 'JSON parsed pipeline-Id\n'
printf $pipelineid
printf '\n\n'
# If the annotation build_number already exists, increment it by 1
# If the annotation build_number doesn't exist, initialize it at 1
if 
    printf 'Current annotation build_number JSON\n'
    codefresh get annotation pipeline $pipelineid build_number -o json 
then 
    build_number=$(codefresh get annotation pipeline $pipelineid build_number -o json | jq '.value' -j)
    echo '\nCurrent build_number:' $build_number
    new_build_number=$((build_number+1))
    #expr $build_number + 1
    echo 'Bumped build_number:' $new_build_number
    codefresh create annotation pipeline $pipelineid build_number=$new_build_number 
else 
    codefresh create annotation pipeline $pipelineid build_number=1 
fi
# Output the new value of the build_number annotation
printf '\nUpdated annotation build_number JSON\n'
codefresh get annotation pipeline $pipelineid build_number -o json