#!/bin/bash

# Retrieve all yaml files
files=()
dir="./crds"

# Tykapis and tykpolicies
curr_apis_policies=()

# Extract apis
apis=( $(kubectl get tykapis -o json | jq -r '.items[].metadata.name') )

# Extract policies
policies=( $(kubectl get tykpolicies -o json | jq -r '.items[].metadata.name') )

# Check if directory exists
if [ -d "$dir" ]
then
    if [ "$(ls -A $dir)" ]
    then
        echo "CRDs found!"
        files=(crds/*)
    else
        echo "$dir is empty, no CRDs are found!"
    fi
else
    echo "Directory $dir not found."
fi

# Extract source of truth api and policies (github repo)
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
    # Check if the api exists in the source of truth
    if [[ " ${curr_apis_policies[*]} " =~ " ${api} " ]]
    then
        # API found in source of truth
        echo "API FOUND"
    else
        # API not found in source of truth
        echo "API NOT FOUND: Cleaning up api..."
        kubectl get tykapis $api -o json | jq 'del(.metadata.finalizers)' && kubectl delete tykapis $api;
    fi
done

# Clean up tyk policies to match source of truth
for policy in "${policies[@]}"; do
    echo "Syncing deployement with source of truth for $policy"
    # Check if the policy exists in the source of truth
    if [[ " ${curr_apis_policies[*]} " =~ " ${policy} " ]]
    then
        # Policy found in source of truth
        echo "POLICY FOUND"
    else
        # Policy not found in source of truth
        echo "POLICY NOT FOUND: Cleaning up policy..."
        kubectl get tykpolicies $api -o json | jq 'del(.metadata.finalizers)' && kubectl delete tykapis $api;
    fi
done