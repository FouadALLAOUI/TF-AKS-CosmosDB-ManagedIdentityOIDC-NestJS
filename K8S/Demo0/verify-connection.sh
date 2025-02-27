#!/bin/bash

echo "1. Checking Azure CLI login status..."
az account show || exit 1

echo "2. Verifying kubectl configuration..."
kubectl config view

echo "3. Testing cluster connection..."
kubectl cluster-info

echo "4. Checking all pods status..."
kubectl get pods --all-namespaces

echo "5. Verifying network connectivity..."
kubectl run test-pod --image=busybox --rm -it --restart=Never -- wget -O- http://kubernetes.default.svc.cluster.local/api/v1/namespaces/default/pods -q 