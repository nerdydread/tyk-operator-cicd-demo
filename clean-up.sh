#!/bin/bash

# Retrieve all yaml files
files=(crds/*)

# Current deployed apis and policies
curr_apis_policies=()

# Retrieve apis
apis=( $(kubectl get tykapis -o json | jq -r '.items[].metadata.name') )

# Retrieve policies
policies=( $(kubectl get tykpolicies -o json | jq -r '.items[].metadata.name') )

# Extract source of truth api and policies
for file in "${files[@]}"; do
    # Check if the file is a yaml file
    if [[ $file == *.yaml ]]
    then
        # Retrieve all metadata.name from CRDs
        filename=$(yq e '.metadata.name' $file)
        curr_apis_policies+=($filename)
    fi
done

# Clean up tyk apis to match source of truth
for api in "${apis[@]}"; do
    echo "Syncing deployement with source of truth for $api"
    # Check if the value exists in the source of truth
    if [[ " ${curr_apis_policies[*]} " =~ " ${api} " ]]; 
        then
            # whatever you want to do when array contains value
            echo "API FOUND"
        else
            echo "API NOT FOUND: Cleaning up api..."
            $(kubectl get tykapis $api -o yaml | yq 'del(.metadata.finalizers[], .spec.contextRef[])')
    fi
done

# Clean up tyk policies to match source of truth
for policy in "${policies[@]}"; do
    echo "Syncing deployement with source of truth for $policy"
    # Check if the value exists in the source of truth
    if [[ " ${curr_apis_policies[*]} " =~ " ${policy} " ]]; 
        then
            # whatever you want to do when array contains value
            echo "POLICY FOUND"
        else
            echo "POLICY NOT FOUND: Cleaning up policy..."
            $(kubectl get tykpolicies $api -o yaml | yq 'del(.metadata.finalizers[], .spec.contextRef[])')
    fi
done