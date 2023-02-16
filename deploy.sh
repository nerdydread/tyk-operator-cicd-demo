#!/bin/bash

dir="./crds"
validation=$(kubectl apply -f crds --dry-run=server 2>&1)

if [[ "$validation" == *"error"* ]]
then
    echo $validation
    exit 1
else
    echo "Validation success: deploying APIs and Policies..."
    kubectl apply -f crds/
    kubectl get tykapis
    kubectl get tykpolicies
fi