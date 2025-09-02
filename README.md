# 🚀 Multi-Service Kubernetes Deployment with Helm, Traefik & AWS

This repository contains a fully automated setup for deploying two containerized applications — **Spring Petclinic** and a custom **Hello** app — into a Kubernetes cluster using Helm charts. Traffic routing is handled by **Traefik**, and all services are exposed via an **AWS LoadBalancer** with custom hostnames.

## 📂 Project Structure

├── Automation/ # Deployment scripts │ ├── deploy-traefik.sh │ ├── deploy-petclinic.sh │ └── deploy-hello.sh ├── Charts/ # Helm charts for each service │ ├── Hello/ │ ├── Petclinic/ │ └── Traefik/ ├── Images/ # Dockerfiles and build contexts │ ├── Hello/ │ ├── Petclinic/ │ └── Traefik/ ├── Infrastructure/ # Terraform configuration └── README.md

## 📋 Prerequisites

Before running the deployment scripts, make sure you have the following installed and configured:

- ✅ [Docker](https://www.docker.com/)
- ✅ [kubectl](https://kubernetes.io/docs/tasks/tools/)
- ✅ [Helm](https://helm.sh/)
- ✅ [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- ✅ [Terraform](https://developer.hashicorp.com/terraform/downloads)
- ✅ Access to an AWS ECR repository (configured via Terraform)
- ✅ A running Kubernetes cluster (e.g. EKS)

## ⚙️ Setup Instructions

### 1. Provision Infrastructure

Use Terraform to provision the required AWS resources (ECR, IAM roles, etc.):

```bash
cd Infrastructure
terraform init
terraform apply
This will output the ECR repository URL used by the deployment scripts.

2. Deploy Traefik
bash
bash Automation/deploy-traefik.sh
This installs Traefik into the hello-ns namespace and exposes it via an AWS LoadBalancer.

3. Deploy Hello App
bash
bash Automation/deploy-hello.sh
This builds the Hello app image, pushes it to ECR, and deploys it via Helm.

4. Deploy Petclinic App
bash
bash Automation/deploy-petclinic.sh
This builds the Petclinic image, pushes it to ECR, and deploys it via Helm into the petclinic-ns namespace.

🌐 Accessing Services Locally
To access the services via browser, update your local hosts file:


<ELB-IP> petclinic.local
<ELB-IP> hello.local
Replace <ELB-IP> with the public IP or DNS of your AWS LoadBalancer (visible via kubectl get svc traefik -n hello-ns).

Then flush DNS:

bash
ipconfig /flushdns   # Windows