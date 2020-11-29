# Cape Cod Coastal Planner UAT

> This project is designed and built for the Cape Cod Commission of Barnstable County, Massachusetts and provides a public portal for communities of Cape Cod to assess, compare, and plan various strategies in response to the three major coastal hazards: storm surge, erosion, and sea level rise. 

It is divided into 2 main projects:

1. `ccc/chip_api` - a GraphQL API written in Elixir and using the Phoenix web framework and the Absinthe GraphQL library
1. `ccc/chip_app` - a Single-page App written in Elm and using the OpenLayers and Turf.js libraries for mapping and geospatial analysis

Architecture Decision Records can be found in `ccc/docs/architecture` and document the major architectural choices made throughout this project.


## Local Docker & Development - (!!if developing create a feature branch off the dev branch!!)
```bash
# Navigate to the project directory
cd cape-cod-coastal-planner/

# Checkout the dev branch

# Create a feature branch off the dev branch
naming convention of feature branch `this-feature`

# Navigate to chip_api/config
create `dev.secret.exs` & `test.secret.exs`

# Navigate to chip_api/startup.sh
uncomment `mix ecto.setup` line (Only for development)

# Run & destroy all services locally with docker
`docker-compose up --build` (create docker-compose services)
`docker-compose down -v` (destroy docker-compose services)

#Prior to rebasing feature-branch against dev branch
navigate to `chip_api/startup.sh` and comment `mix ecto.setup` line again
```

## CI/CD
Pushing to dev or master branches will trigger our pipeline:
1. CircleCI or Azure Devlops will pull our recent code from the specified branch
    * Then rebuild, tag, and push the Front and API containers with our latest code to ACR
1. Azure Webhooks watch our tagged containers on ACR 
    * On-push, will ping Keel
1. Keel rebuilds pods with the correctly tagged images on Kubernetes

## AKS Specs
```bash
# Resource Group
CCC-AKSGroup

# Kubernetes Service
CCC-AKS-01

# Node Resource Group
MC_CCC-AKSGroup_CCC-AKS-01_eastus
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
To deploy to Azure Kubernetes Cluster (AKS) CCC-AKS-01
```bash
# Log in to Azure
az login

# Connect to cluster
az aks get-credentials --resource-group CCC-AKSGroup --name CCC-AKS-01

# View status of pods, services, deployments, and recplicasets
kubectl get pods
kubectl get services
kubectl get deployments

# Convert the Docker Compose file into a Kubernetes config file
kompose convert -f docker-compose.yml -o kubernetes-compose.yml

# Deploy new Kubernetes config to AKS Cluster
# Please note: Run only when kubernetes-compose.yml file changes
kubectl apply -f kubernetes-compose.yml

# Enter an interactive terminal into a pod id
kubectl exec -it cccpapi-1234567 -- /bin/bash

# Install Keel on AKS to rebuild pods when pinged
helm upgrade --install keel --namespace=keel keel/keel --set service.enabled="true" 

# To delete all services, deployments, pods, replicasets, volumes
kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

# To delete a persistent volume and claim
kubectl delete pvc pgdata-claim
```

### Administration
To view the CCC-AKS-DEV-01 Cluster:
```bash
# Log in
az login

# Start local webapp to view CCC-AKS-DEV-01  
#
az aks browse --resource-group CCC-AKSGroup --name CCC-AKS-01
```

### Starting from Scratch on Kubes
1. Set up database and persistent volume claim (cccpdb)
2. Set up API (cccpapi) (NOTE: this step is necessary to seed (a.k.a. build) the database)
3. Seed database from API (exec mix ecto.setup)
4. Delete API [NOTE: steps 4 & 5 are necessary because you need a database for the API to properly f(x), otherwise you have a dysfunctional API]
5. Re-build API
6. Build front-end (cccpfront)
7. Set up cccpapi dev & uat
8. Set up cccpfrontdev, then uat 1 @ a time
9. Install ingress
10. Install cert-manager (delete purge if existing prior)
11. Create cluster issuer (letsencrypt-prod & specific namespace)
12. Create a certificate object w/ secrets (namespace specific - www, uat & dev)
13. Create ingress w/ hosts & secrets
14. Then rebuild, tag, and push the Front and API containers with our latest code to ACR
