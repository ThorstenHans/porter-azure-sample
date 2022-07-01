# Porter Sample: Azure Kubernetes Service, Terraform, Helm 3

This repository contains a sample application which is packaged according to [CNAB spec](https://cnab.io) using [Porter](https://porter.sh).  

The actual application is a containerized .NET API which is consumed from Docker Hub during application deployment (just for simplification during live demos :D).

Porter is responsible for:

- Establish authentication with Azure using a service principal (SP)
- Provision state management backend for [Terraform](https://terraform.io) with Azure CLI
- Provision application infrastructure (AKS) with Terraform
- Grab credentials from AKS
- Provision NGINX Ingress using [Helm](https://helm.sh)
- Provision the actual application (custom Helm chart)

## Create a Service Principal

you can quickly create a new Service Principal in Azure using Azure CLI:

```bash
az ad sp create-for-rbac sp-porter-sample -ojsonc
```

Once you've create the Service Principal, go to Azure AD and assign the `Contributor` role to it on the scope of the desired Azure Subscription. Additionally, the Service Principal must be able to create, modify, and delete role assignments. This could be achieved by creating a custom role in Azure AD and assigning this to the service principal (also on the scope of the subscription).

Role Assignments are required depending on the actual infrastructure provisioned by Terraform as part of the CNAB bundle.

## Install Porter

Install porter according to [the installation guide](https://porter.sh/install/).

## Specify parameters and credentials

You can generate parameter and credential sets using `porter` CLI:

```bash
cd bundle
# Generate Parameters
porter parameter generate --file porter.yaml
# the cli will guide you through specifying the parameters
# and store the parameter set with the name porter-azure-sample

# Generate Credentials
porter credentials generate --file porter.yaml
# the cli will guide you through specifying the credentials
# and store the credential set with the name porter-azure-sample
```

## Install the application

```bash
# Install the bundle and specify the credential set (-c) and parameter set (-p)
porter install --file porter.yaml -c porter-azure-sample -p porter-azure-sample
```

## Call the sample API

Once installation has finished you can call the sample API via `curl` to get the IP address, you've to look for the IP address assigned to NGINX ingress. This can be achieved using Azure Portal or Azure CLI:

```bash
az aks get-credentials -n aks-porter-sample-2022 -g rg-porter-sample

kubectl get svc -A
```

From the output copy the public IP address of the ingress load balancer and curl the `/products` endpoint:

```bash
curl http://<INGRESS_IP>/products | jq
```

## Uninstall the application

To uninstall the application you can invoke

```bash
porter install --file porter.yaml -c porter-azure-sample -p porter-azure-sample
```
