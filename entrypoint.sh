#!/bin/sh
set -e

# Grab the current build information and output to json
printf '\nBuild ID: %s' "$CF_BUILD_ID"

if 
    [ -z "$ANNOTATION_PREFIX" ]
then
    printf '\n\nANNOTATION_PREFIX is empty. Annotation name will be build_number'
else
    printf '\n\nANNOTATION_PREFIX=%s' "$ANNOTATION_PREFIX"
fi

printf '\n\nCurrent build JSON\n'
codefresh get build $CF_BUILD_ID -o json

# Use jq to traverse the json and grab the pipeline id
pipelineid=$(codefresh get build $CF_BUILD_ID -o json | jq '."pipeline-Id"')
printf '\nJSON parsed pipeline-Id: %s \n' "$pipelineid"

# If the annotation build_number already exists, increment it by 1
# If the annotation build_number doesn't exist, initialize it at 1
if 
    printf '\nCurrent annotation build_number JSON\n'
    codefresh get annotation pipeline $pipelineid build_number -o json 
then 
    build_number=$(codefresh get annotation pipeline $pipelineid build_number -o json | jq '.value' -j)    
    printf '\nCurrent build_number: %s' "$build_number"
    new_build_number=$((build_number+1))
    
    printf '\nBumped build_number: %s \n' "$new_build_number"
    printf '\nCreating annotation: '
    codefresh create annotation pipeline $pipelineid build_number=$new_build_number 
else 
    codefresh create annotation pipeline $pipelineid build_number=1 
fi
# Output the new value of the build_number annotation
printf '\nUpdated annotation build_number JSON'
codefresh get annotation pipeline $pipelineid build_number -o json