#!/bin/bash

# Set variables
$ResourceGroupName="aks-nginx-routing-rg"
$ClusterName="aks-nginx-routing"
$Location="northeurope"
$VnetName="aks-vnet"
$VnetPrefix="10.0.0.0/16"
$AksSubnetName="aks-subnet"
$AksSubnetPrefix="10.0.0.0/24"
$JumpboxSubnetName="jumpbox-subnet"
$JumpboxSubnetPrefix="10.0.1.0/24"
$JumpboxName="aks-jumpbox"
$JumpboxUsername="azureuser"

# Login to Azure
az login

# Create Resource Group
az group create --name $ResourceGroupName --location $Location

# Create Virtual Network and Subnets
az network vnet create `
    --resource-group $ResourceGroupName `
    --name $VnetName `
    --address-prefix $VnetPrefix `
    --subnet-name $AksSubnetName `
    --subnet-prefix $AksSubnetPrefix

# Add Jumpbox Subnet
az network vnet subnet create `
    --resource-group $ResourceGroupName `
    --vnet-name $VnetName `
    --name $JumpboxSubnetName `
    --address-prefix $JumpboxSubnetPrefix

# Get Subnet IDs
$AksSubnetId=$(az network vnet subnet show --resource-group $ResourceGroupName --vnet-name $VnetName --name $AksSubnetName --query id -o tsv)

# Create AKS Cluster
# Set non-overlapping service and DNS CIDRs
$ServiceCidr="172.16.0.0/16"
$DnsServiceIP="172.16.0.10"
$DockerBridgeCidr="172.17.0.1/16"

# Create AKS cluster with custom CIDR ranges
az aks create `
    --resource-group $ResourceGroupName `
    --name $ClusterName `
    --location $Location `
    --enable-app-routing `
    --generate-ssh-keys `
    --node-count 2 `
    --enable-private-cluster `
    --network-plugin azure `
    --vnet-subnet-id $AksSubnetId `
    --network-policy azure `
    --service-cidr $ServiceCidr `
    --dns-service-ip $DnsServiceIP `
    --docker-bridge-address $DockerBridgeCidr

# Create Jumpbox VM
$JumpboxPassword="@123@jumpbox@456@aks@789@"  # Make sure to use a complex password

# Create the VM with password authentication
az vm create `
    --resource-group $ResourceGroupName `
    --name $JumpboxName `
    --image Ubuntu2204 `
    --admin-username $JumpboxUsername `
    --admin-password $JumpboxPassword `
    --authentication-type password `
    --vnet-name $VnetName `
    --subnet $JumpboxSubnetName `
    --public-ip-sku Standard

# Get Jumpbox Public IP
$JumpboxIP=$(az vm show -d -g $ResourceGroupName -n $JumpboxName --query publicIps -o tsv)
Write-Host "Jumpbox Public IP: $JumpboxIP"

# Commands to run on the Jumpbox (save these for later use):
$JumpboxCommands = @"
# Update package list
sudo apt-get update

# Install Azure CLI
#curl -sL https://aka.ms/InstallAzureCLI | sudo bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install kubectl
sudo az aks install-cli

# Login to Azure
az login

# Get AKS credentials
#az aks get-credentials --resource-group $ResourceGroupName --name $ClusterName --overwrite-existing

az aks get-credentials --resource-group aks-nginx-routing-rg --name aks-nginx-routing --overwrite-existing


# Create namespace
kubectl create namespace hello-web-app-routing

# Continue with your deployments
kubectl get ingressclasses.networking.k8s.io

kubectl get service -n app-routing-system

kubectl applay -f configma.yml

kubectl apply -f nginx-service.yml

# Many times to see that the external ip address is private
kubectl get service -n app-routing-system 

kubectl apply -f sample-app.yml

kubectl run nginx --image=nginx --restart=Never

kubectl exec nginx -n default -- /bin/bash

kubectl apply -f ingress.yml




"@

Write-Host "`nConnect to jumpbox using: ssh $JumpboxUsername@$JumpboxIP"
Write-Host "`nAfter connecting, run the following commands:"
Write-Host $JumpboxCommands


###################################################################################
###################################################################################




