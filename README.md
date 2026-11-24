# Velora — Cloud-Native Digital Banking Platform

Velora is a cloud-native digital banking dashboard built to demonstrate the design, deployment, security, and automation of a containerized application on Microsoft Azure.

The project implements a multi-tier architecture using Azure Kubernetes Service (AKS), Azure Database for PostgreSQL, Docker, Terraform, and GitHub Actions.

## Architecture Overview

Velora consists of three application layers:

- **Frontend:** An Nginx web server serving the banking dashboard and routing API requests.
- **Backend:** A Python FastAPI application responsible for retrieving account and transaction data.
- **Database:** Azure Database for PostgreSQL Flexible Server, configured with private network connectivity.

### Application Request Flow

```text
User / Web Browser
        |
        v
Azure Public Load Balancer
        |
        v
AKS Frontend Service
        |
        v
Nginx Frontend Pod
        |
        v
AKS Backend Service
        |
        v
FastAPI Backend Pod
        |
        v
Azure PostgreSQL Flexible Server
```

## Technology Stack

| Category | Technologies |
|---|---|
| Cloud Platform | Microsoft Azure |
| Infrastructure as Code | Terraform |
| Containerization | Docker |
| Container Orchestration | Kubernetes, Azure Kubernetes Service |
| Container Registry | Azure Container Registry |
| Backend | Python, FastAPI |
| Frontend | HTML, Nginx |
| Database | PostgreSQL |
| CI/CD | GitHub Actions |
| Authentication | Microsoft Entra ID, OpenID Connect |
| Security | Azure RBAC, Kubernetes RBAC, Kubernetes Secrets, private networking |

## Key Features

- Containerized frontend and backend applications deployed to AKS.
- Banking dashboard displaying account balances and transaction history.
- PostgreSQL database with private network connectivity.
- Infrastructure provisioned and managed through Terraform.
- Docker images stored in Azure Container Registry.
- Automated application builds and deployments through GitHub Actions.
- Microsoft Entra workload identity federation for passwordless CI/CD authentication.
- Namespace-scoped Kubernetes RBAC for deployment permissions.
- Database credentials supplied through Kubernetes Secrets.
- Kubernetes health and rollout verification.

## Infrastructure

The infrastructure is defined in `infrastructure/terraform/` and includes:

- Azure Resource Group
- Azure Virtual Network and subnets
- Azure Kubernetes Service
- Azure Container Registry
- Azure Database for PostgreSQL Flexible Server
- Private DNS configuration
- Azure identity and access management resources
- Monitoring configuration

Terraform provides a repeatable approach to provisioning and removing the cloud infrastructure.

## CI/CD Pipeline

The GitHub Actions workflow is defined in:

`.github/workflows/velora-ci-cd.yml`

The pipeline contains two jobs.

### 1. Build and Push

1. Check out the application source code.
2. Build the backend and frontend Docker images.
3. Authenticate to Azure using OIDC.
4. Authenticate to Azure Container Registry.
5. Tag the images using the Git commit SHA.
6. Push both images to ACR.

### 2. Deploy to AKS

1. Authenticate to Azure.
2. Retrieve AKS cluster credentials.
3. Configure Kubernetes authentication using `kubelogin`.
4. Update the Kubernetes manifests with the new image tags.
5. Apply the application Deployments, Services, and ConfigMap.
6. Verify successful Kubernetes rollouts.

The workflow is manually triggered using GitHub Actions.

## Security

Velora incorporates several cloud security practices:

- **OIDC authentication:** GitHub Actions authenticates to Azure without a stored client secret.
- **Azure RBAC:** Controls access to Azure Container Registry and AKS.
- **Kubernetes RBAC:** Restricts deployment permissions to the application namespace.
- **Private database connectivity:** PostgreSQL is accessed through private Azure networking.
- **Kubernetes Secrets:** Database passwords are supplied to application containers at runtime.
- **Database authorization:** The application uses a database role with restricted permissions.
- **Infrastructure as Code:** Infrastructure configuration is version-controlled and reproducible.

## Project Structure

```text
velora/
├── .github/
│   └── workflows/
│       └── velora-ci-cd.yml
├── app/
│   ├── backend/
│   └── frontend/
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   └── setup.sql
├── infrastructure/
│   └── terraform/
├── kubernetes/
└── README.md
```

## Deployment

### Prerequisites

- Azure subscription with sufficient permissions and service quotas
- Azure CLI
- Terraform
- Docker
- kubectl and kubelogin
- GitHub repository with Azure OIDC federation configured

### Infrastructure Provisioning

From the Terraform directory:

```bash
terraform init
terraform plan
terraform apply
```

Review the Terraform variables and supply the required values securely before applying.

### Application Deployment

The Kubernetes manifests are maintained in the `kubernetes/` directory.

After provisioning the infrastructure, building and publishing the container images, and configuring the required Kubernetes Secrets and database initialization, deploy the application using the Kubernetes manifests.

Alternatively, trigger the **Velora CI/CD** workflow in GitHub Actions after completing the infrastructure and database prerequisites.

### Accessing the Application

After deployment, retrieve the frontend's external IP address:

```bash
kubectl get service frontend
```

Open the external IP in a web browser using HTTP.

The public IP is assigned during deployment and may change when the infrastructure is recreated.

## Infrastructure Cleanup

To remove the Terraform-managed Azure infrastructure:

```bash
cd infrastructure/terraform
terraform plan -destroy
terraform destroy
```

Review the destruction plan before approving. Deleting the PostgreSQL server also deletes its stored database data unless separately backed up.

## Project Outcomes

Velora demonstrates practical experience in:

- Provisioning Azure infrastructure using Terraform.
- Building and managing containerized applications.
- Deploying workloads to Azure Kubernetes Service.
- Configuring Kubernetes networking and access controls.
- Integrating applications with a privately networked PostgreSQL database.
- Implementing GitHub Actions CI/CD using Azure OIDC authentication.
- Troubleshooting container image, authentication, and deployment issues.
- Validating application functionality across the full cloud architecture.

## Project Status

The application and CI/CD pipeline have been successfully deployed and validated in a development environment.

Azure resources may be removed between development sessions to manage costs. The repository preserves the application source code, infrastructure definitions, Kubernetes manifests, and CI/CD workflow for future deployments.