#!/bin/bash

# Define paths
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
TERRAFORM_DIR="$BASE_DIR/terraform"

# Step 1: Run Terraform destroy
echo "[INFO] Running Terraform destroy..."
cd "$TERRAFORM_DIR" || { echo "[ERROR] Terraform directory not found!"; exit 1; }
terraform destroy
if [ $? -ne 0 ]; then
    echo "[ERROR] Terraform destroy failed!"
    exit 1
fi
