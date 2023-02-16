#!/bin/bash

dir="/crds"

# Check if directory exists
if [ "$(ls -A $dir)" ]; 
then
    echo "Deplying APIs and Policies"
    files=(crds/*)

    $(kubectl apply -f crds/)
    $(kubectl get tykapis)
    $(kubectl get tykpolicies)
else
    echo "$dir is empty, no CRDs are found!"
fi