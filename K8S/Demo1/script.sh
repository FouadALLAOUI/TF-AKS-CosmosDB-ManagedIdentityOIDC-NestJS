#! /bin/bash

# --->> https://github.com/abhinabsarkar/aks-ingress-ilb

# Create a resource group
az group create --name ingress-nginx-rg --location eastus

$VnetName="aks-vnet"
$VnetPrefix="172.26.102.0/23"
$AksSubnetName="aks-subnet" 
$AksSubnetPrefix="172.26.103.0/24"

# Create a virtual network
az network vnet create --resource-group ingress-nginx-rg --name $VnetName --address-prefixes $VnetPrefix --subnet-name $AksSubnetName --subnet-prefixes $AksSubnetPrefix

$AksSubnetId=$(az network vnet subnet show --resource-group ingress-nginx-rg --vnet-name $VnetName --name $AksSubnetName --query id -o tsv)

# Create a public AKS cluster with 2 nodes and standard SKU loadbalancer
az aks create `
    --resource-group ingress-nginx-rg `
    --name myAKSCluster `
    --node-count 2 `
    --network-plugin azure `
    --vnet-subnet-id $AksSubnetId 
    #--load-balancer-sku standard `

# Get the credentials for the AKS cluster
az aks get-credentials --resource-group ingress-nginx-rg --name myAKSCluster

# Install Nginx Ingress Controller with custom values
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install nginx-ingress ingress-nginx/ingress-nginx `
  --namespace ingress-nginx `
  --create-namespace `
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"="true" `
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"="aks-subnet" `
  --set controller.service.loadBalancerIP="172.26.103.103" `
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-ip"="172.26.103.103"

# List the namespaces
kubectl get namespaces

# List the pods in the ingress-nginx namespace
kubectl get pods -n ingress-nginx -o wide

# List the services in the ingress-nginx namespace
kubectl get services -n ingress-nginx -o wide

kubectl run nginx --image=nginx --restart=Never

kubectl exec -it nginx -n default -- /bin/bash

# List the ingresses
kubectl get ingresses -n ingress-nginx -o wide

# List the deployments
kubectl get deployments -n ingress-nginx -o wide

# List the replicasets
kubectl get replicasets -n ingress-nginx -o wide

# List the configmaps
kubectl get configmaps -n ingress-nginx -o wide

# List the secrets
kubectl get secrets -n ingress-nginx -o wide

