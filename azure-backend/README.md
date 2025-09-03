# Azure Terraform Backend Infrastructure

This directory contains the Terraform configuration for setting up the remote state backend infrastructure (Storage Account and Table Storage) for the main Fivetran Hybrid Agent infrastructure on Azure.

## Purpose

This is a **one-time setup** that creates:
- Azure Storage Account for storing Terraform state files
- Azure Table Storage for state locking

**Important**: This infrastructure should NOT be destroyed as it contains your Terraform state!

## Quick Setup

```bash
# Set up the backend infrastructure
./setup-backend.sh
```

## What Gets Created

- **Storage Account**: `sttfstate{random_string}`
  - Versioning enabled
  - Server-side encryption (Microsoft-managed keys)
  - Public access disabled
  - Lifecycle policies for cost optimization

- **Table Storage**: `tfstatelock`
  - Used for state locking
  - PartitionKey: LockID

## Next Steps

After running `./setup-backend.sh`:

1. Navigate to the main infrastructure: `cd ../infrastructure`
2. Run: `./quick-setup.sh`

## File Structure

- `backend-infrastructure.tf` - Storage Account and Table Storage resources
- `variables.tf` - Configuration variables
- `versions.tf` - Terraform version requirements
- `providers.tf` - Azure provider configuration
- `setup-backend.sh` - One-time setup script
- `README.md` - This file
