#!/bin/bash

# Retrieve all yaml files
files=(crds/*)

curr_apis=()

# Retrieve apis
apis=( $(sudo kubectl get tykapis -o json | jq -r '.items[].metadata.name') )

# Retrieve policies
policies=( $(sudo kubectl get tykpolicies -o json | jq -r '.items[].metadata.name') )


for file in "${files[@]}"; do
    # Check if the file is a yaml file
    if [[ $file == *.yaml ]]
    then
        echo $file -o json
        # # Remove prefix and suffix
        # prefix="crds/"
        # suffix=".yaml"
        # filename=${file#"$prefix"}
        # filename=${filename%"$suffix"}

        # curr_apis+=($filename)
    fi
done

for api in "${curr_apis[@]}"; do
    echo $api
done

for api in "${apis[@]}"; do
    echo $api
done

for api in "${policies[@]}"; do
    echo $api
done

# # Clean up tykapis
# echo "Cleaning up tykapis..."
# for api in "${apis[@]}"; do
#     echo "$api"
#     # Check if the value exists in the source of truth
#     if [[ " ${file[*]} " =~ ${api} * ]]; 
#         then
#             # whatever you want to do when array contains value
#             echo "FOUND"
#         else
#             echo "NOT FOUND"
#     fi
# done

# echo "Cleaning up tykpolicies..."
# for policy in "${policies[@]}"; do
#     echo "$policy"
# done

