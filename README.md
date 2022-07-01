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
