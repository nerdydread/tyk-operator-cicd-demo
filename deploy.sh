#!/bin/bash

dir="./crds"
validation=( $(kubectl apply -f crds --dry-run=server) )

if [[ " ${validation[*]} " =~ " *error* " ]]
    then
        kubectl apply -f crds/
        kubectl get tykapis
        kubectl get tykpolicies
    else
        echo ${validation}
        exit 1
fi
