# Fivetran Hybrid Agent Terraform Infrastructure - Azure

This directory contains Terraform configurations to deploy Fivetran Hybrid Agent infrastructure on Azure. The configuration supports multiple environments and is designed to be easily deployable across different stages of development.

## Overview

This Terraform configuration creates:
- Managed Identity and role assignments for the Fivetran Agent VM
- Network Security Groups with appropriate ingress/egress rules
- Virtual Machine with Docker and Fivetran Agent installation

## Prerequisites

1. **Terraform**: Version >= 1.0
2. **Azure CLI**: Configured with appropriate credentials
3. **Azure Permissions**: Ability to create Resource Groups, VMs, Network Security Groups, Storage Accounts, and Table Storage

## Remote State Management

This infrastructure uses remote state management with Azure Storage as the backend. The setup is divided into two phases:

### Phase 1: Backend Infrastructure (One-time setup)
The backend infrastructure (Storage Account and Table Storage) is managed separately in the `../azure-backend/` directory.

```bash
# Navigate to backend infrastructure directory
cd ../azure-backend

# Set up the backend infrastructure (Storage Account + Table Storage)
./setup-backend.sh
```

### Phase 2: Main Infrastructure
After the backend is set up, deploy the main infrastructure:

```bash
# Navigate back to main infrastructure
cd ../infrastructure

# Quick setup (recommended)
./quick-setup.sh

# Or manual setup
terraform init
# Create backend-config.tf manually, then:
terraform init -reconfigure
terraform plan
terraform apply
```

## Quick Start

### 1. Set up Backend Infrastructure (One-time)
```bash
cd ../azure-backend
./setup-backend.sh
```

### 2. Deploy Main Infrastructure
```bash
cd ../infrastructure
./quick-setup.sh
```

## File Structure

### Root Directory Files

```
infrastructure/
├── versions.tf          # Terraform version and provider requirements
├── variables.tf         # Input variables definition
├── locals.tf           # Local values and environment mappings
├── providers.tf        # Azure provider configuration
├── identity.tf         # Managed Identity
├── role-assignments.tf # Role assignments for the managed identity
├── network.tf          # Virtual Network and Subnet configuration
├── security.tf         # Network Security Group configuration
├── vm.tf              # Virtual Machine configuration
├── outputs.tf          # Output values
├── main.tf            # Main configuration file
├── user_data.sh       # User data script for VM instance
├── deploy.sh          # Deployment script
├── quick-setup.sh     # One-command setup for main infrastructure with remote backend
├── environments/      # Environment-specific variable files
└── README.md          # This file
```

### Backend Infrastructure Directory

```
../azure-backend/
├── backend-infrastructure.tf # Storage Account and Table Storage resources
├── variables.tf              # Backend-specific variables
├── versions.tf               # Terraform version requirements
├── providers.tf              # Azure provider configuration
├── setup-backend.sh          # One-time backend setup script
└── README.md                 # Backend setup documentation
```

## Resource Naming Convention

All resources follow a consistent naming pattern:
- Managed Identity: `mi-{environment}-{project_name}`
- Role Assignments: 
  - `VirtualMachineContributor-{environment}-{project_name}`
  - `MonitoringContributor-{environment}-{project_name}`
  - `Reader-{environment}-{project_name}`
- Network Security Group: `nsg-{project_name}-{environment}-fivetran-agent`
- Virtual Machine: `vm-{project_name}-{environment}-fivetran-agent`

## Quick Start

### 1. Initialize Terraform

```bash
cd infrastructure
terraform init
```

### 2. Deploy to Development Environment

```bash
# Plan the deployment
./deploy.sh dev plan

# Apply the deployment
./deploy.sh dev apply
```

### 3. Deploy to Production Environment

```bash
# Plan the deployment
./deploy.sh prd plan

# Apply the deployment
./deploy.sh prd apply
```

## Deployment Script Usage

The `deploy.sh` script provides a convenient way to manage deployments:

```bash
./deploy.sh [environment] [action]
```

### Actions:
- `init` - Initialize Terraform
- `plan` - Create a Terraform plan
- `apply` - Apply the Terraform configuration
- `destroy` - Destroy the infrastructure

### Examples:

```bash
# Initialize Terraform
./deploy.sh dev init

# Plan deployment for development
./deploy.sh dev plan

# Apply deployment for production
./deploy.sh prd apply

# Destroy infrastructure for staging
./deploy.sh stg destroy
```
