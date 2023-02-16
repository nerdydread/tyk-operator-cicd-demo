#!/bin/bash

dir="./crds"

# Check if directory exists
# Check if directory exists
if [ -d "$dir" ];
then
    if [ "$(ls -A $dir)" ]; 
    then
        echo "Deplying APIs and Policies"
        files=(crds/*)

        kubectl apply -f crds/
        kubectl get tykapis
        kubectl get tykpolicies
    else
        echo "$dir is empty, no CRDs are found!"
    fi
else
    echo "Directory $dir not found."
fi
