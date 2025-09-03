#!/bin/bash

# Quick setup script for main infrastructure with remote state
# This script assumes the backend infrastructure (Storage Account + Table Storage) already exists

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Quick Setup for Main Infrastructure with Remote State - Azure${NC}"
echo "=================================================================="
echo ""

# Check if we're in a Terraform directory
if [ ! -f "versions.tf" ] && [ ! -f "main.tf" ]; then
    echo -e "${GREEN}❌ Error: This script must be run from a Terraform directory${NC}"
    exit 1
fi

echo -e "${GREEN}📋 Step 1: Verifying backend infrastructure exists...${NC}"
echo "Checking if Storage Account and Table Storage are accessible..."

# Get the location from variables
LOCATION=$(grep -A1 'variable "location"' variables.tf | grep 'default' | sed 's/.*default.*=.*"\([^"]*\)".*/\1/')

if [ -z "$LOCATION" ]; then
    LOCATION="East US"
fi

echo "Using location: $LOCATION"

# Check if Azure CLI is installed and logged in
if ! command -v az &> /dev/null; then
    echo -e "${GREEN}❌ Error: Azure CLI is not installed. Please install it first.${NC}"
    exit 1
fi

if ! az account show &> /dev/null; then
    echo -e "${GREEN}❌ Error: Not logged into Azure. Please run 'az login' first.${NC}"
    exit 1
fi

echo "✅ Azure CLI is installed and authenticated"

# Test access to backend resources
echo "Testing access to backend resources..."

# Check if the backend resource group exists
BACKEND_RG="csg-sa-kveluru-docker-hybrid-agent"
if ! az group show --name "$BACKEND_RG" --query "name" -o tsv >/dev/null 2>&1; then
    echo -e "${GREEN}❌ Error: Cannot find backend resource group: $BACKEND_RG${NC}"
    echo "Please ensure the backend infrastructure exists:"
    echo "1. Go to ../azure-backend"
    echo "2. Run: ./setup-backend.sh"
    echo "3. Come back here and run this script again"
    exit 1
fi

echo "✅ Backend resource group found: $BACKEND_RG"

# Check if storage account exists
STORAGE_ACCOUNT="csgsakvelurutfstate"
if ! az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$BACKEND_RG" --query "name" -o tsv >/dev/null 2>&1; then
    echo -e "${GREEN}❌ Error: Cannot find storage account: $STORAGE_ACCOUNT${NC}"
    echo "Please ensure the backend infrastructure exists:"
    echo "1. Go to ../azure-backend"
    echo "2. Run: ./setup-backend.sh"
    echo "3. Come back here and run this script again"
    exit 1
fi

echo "✅ Storage account found: $STORAGE_ACCOUNT"

# Check if container exists
CONTAINER="dockeragenttfstate"
if ! az storage container exists --name "$CONTAINER" --account-name "$STORAGE_ACCOUNT" --auth-mode login | grep -q "True"; then
    echo -e "${GREEN}❌ Error: Cannot access container $CONTAINER in storage account $STORAGE_ACCOUNT${NC}"
    echo "Please ensure the backend infrastructure exists:"
    echo "1. Go to ../azure-backend"
    echo "2. Run: ./setup-backend.sh"
    echo "3. Come back here and run this script again"
    exit 1
fi

echo "✅ Container found: $CONTAINER"

echo "✅ Backend infrastructure verified successfully!"

echo ""
echo -e "${GREEN}📋 Step 2: Setting up remote backend...${NC}"

# Create the backend configuration file with modern parameters
cat > backend-config.tf << EOF
# Backend Configuration for Remote State
# This file configures Terraform to use the Azure Storage backend

terraform {
  backend "azurerm" {
    resource_group_name  = "$BACKEND_RG"
    storage_account_name = "$STORAGE_ACCOUNT"
    container_name       = "$CONTAINER"
    key                  = "hybrid/docker/terraform.tfstate"
    use_azuread_auth     = true
  }
}
EOF

echo "Created backend-config.tf with the correct configuration"

echo ""
echo -e "${GREEN}📋 Step 3: Initializing Terraform with remote backend...${NC}"
echo "Running: terraform init -reconfigure"

# Initialize with backend reconfiguration
terraform init -reconfigure

echo ""
echo -e "${GREEN}📋 Step 4: Planning infrastructure deployment...${NC}"
terraform plan

echo ""
echo -e "${GREEN}📋 Step 5: Deploying infrastructure...${NC}"
terraform apply -auto-approve

echo ""
echo -e "${GREEN}🎉 Setup complete! Your main infrastructure is now deployed with remote state management.${NC}"
echo ""
echo -e "${BLUE}Your Terraform state is now managed remotely in:${NC}"
echo "  - Resource Group: $BACKEND_RG"
echo "  - Storage Account: $STORAGE_ACCOUNT"
echo "  - Container: $CONTAINER"
echo "  - State Key: hybrid/docker/terraform.tfstate"
echo "  - Location: $LOCATION"
echo ""
echo "Next time you work on this infrastructure:"
echo "  - Clone the repository"
echo "  - Run: terraform init"
echo "  - Run: terraform plan"
echo ""
echo -e "${GREEN}Note: Always use 'terraform init' when cloning this repository or working from a new location.${NC}"
