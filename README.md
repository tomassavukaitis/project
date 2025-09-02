# 🚀 Multi-Service Kubernetes Deployment with Helm, Traefik & AWS

This repository contains a fully automated setup for deploying two containerized applications — **Spring Petclinic** and a custom **Hello** app — into a Kubernetes cluster using Helm charts. Traffic routing is handled by **Traefik**, and all services are exposed via an **AWS LoadBalancer** with custom hostnames.


## 📋 Prerequisites

Before running the deployment scripts, make sure you have the following installed and configured:

- ✅ [Docker](https://www.docker.com/)
- ✅ [kubectl](https://kubernetes.io/docs/tasks/tools/)
- ✅ [Helm](https://helm.sh/)
- ✅ [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- ✅ [Terraform](https://developer.hashicorp.com/terraform/downloads)

## ⚙️ Setup Instructions

###  Provision Infrastructure and deploy the apps

Use Terraform to provision the required AWS resources (ECR, IAM roles, etc.):

```bash
cd Infrastructure
terraform init
terraform apply
This will output the ECR repository URL used by the deployment scripts.

 Deploy Hello App

```bash
cd Automation
./deploy-hello.sh

This builds the Hello app image, pushes it to ECR, and deploys it via Helm.

 Deploy Petclinic App

```bash
cd Automation
./deploy-petclinic.sh

This builds the Petclinic image, pushes it to ECR, and deploys it via Helm into the petclinic-ns namespace.

 Accessing Services Locally

To access the services via browser, update your local hosts file:


<ELB-IP> petclinic.local
<ELB-IP> hello.local

Replace <ELB-IP> with the public IP or DNS of your AWS LoadBalancer (visible via kubectl get svc traefik -n hello-ns).

Then flush DNS:

```cmd
ipconfig /flushdns   # Windows