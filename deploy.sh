#!/bin/bash

dir="./crds"
validation=( $(kubectl apply -f crds --dry-run=server) )

if [[  " ${validation[*]} " =~ " error* " ]]
    then
        echo ${validation}
        exit 1
        
    else
        kubectl apply -f crds/
        kubectl get tykapis
        kubectl get tykpolicies
fi
