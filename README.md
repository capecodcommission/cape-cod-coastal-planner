# Cape Cod Coastal planner

> This project is designed and built for the Cape Cod Commission of Barnstable County, Massachusetts and provides a public portal for communities of Cape Cod to assess, compare, and plan various strategies in response to the three major coastal hazards: storm surges, erosion, and sea level rise. 

It is divided into 2 main projects:

1. `ccc/chip_api` - a GraphQL API written in Elixir and using the Phoenix web framework and the Absinthe GraphQL library
1. `ccc/chip_app` - a Single-page App written in Elm and using the OpenLayers and Turf.js libraries for mapping and geospatial analysis

Architecture Decision Records can be found in `ccc/docs/architecture` and document the major architectural choices made throughout this project.


## Getting Started
```bash
# Navigate to the project directory
cd cape-cod-coastal-planner/

# Run all services locally
docker-compose up
```

## AKS Specs
```bash
# Resource Group
CCC-AKSGroup

# Kubernetes Service
CCC-AKS-DEV-01

# Node Resource Group
MC_CCC-AKSGroup_CCC-AKS-DEV-01_eastus
```

## Azure
To build and push local images to Azure Container Registry
```bash

# Log in to Azure Container Registry (ACR) ccccontainers
az acr login -n ccccontainers

# Build local images from Dockerfile directories and tag with ACR login server name
# NOTE: Increment tag version number for each additional build
docker build ./chip_app -t ccccontainers.azurecr.io/cccp-front:latest
docker build ./chip_api -t ccccontainers.azurecr.io/cccp-api:latest

# Push images to ACR, use :latest for default tag
docker push ccccontainers.azurecr.io/cccp-front:latest
docker push ccccontainers.azurecr.io/cccp-api:latest

# To remove local images and build cache
docker system prune -a
```

## Kubernetes
### Deployment
To deploy to Azure Kubernetes Cluster (AKS) CCC-AKS-DEV-01
```bash
# Log in to Azure
az login

# Connect to cluster
az aks get-credentials --resource-group CCC-AKSGroup --name CCC-AKS-DEV-01

# View status of pods, services, deployments, and recplicasets
kubectl get pods
kubectl get services
kubectl get deployments

# Convert the Docker Compose file into a Kubernetes config file
kompose convert -f docker-compose.yml -o kubernetes-compose.yml

# Deploy new Kubernetes config to AKS Cluster
# Please note: Run only when kubernetes-compose.yml file changes
kubectl apply -f kubernetes-compose.yml

# To delete all services, deployments, pods, replicasets, volumes
kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

# To delete a persistent volume and claim
kubectl delete pvc pgdata
```

### Administration
To view the CCC-AKS-DEV-01 Cluster:
```bash
# Log in
az login

# Start local webapp to view CCC-AKS-DEV-01
az aks browse --resource-group CCC-AKSGroup --name CCC-AKS-DEV-01
```