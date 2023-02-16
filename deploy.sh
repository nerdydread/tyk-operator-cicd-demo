#!/bin/bash

dir="./crds"

kubectl apply -f crds/ && kubectl get tykapis && kubectl get tykpolicies