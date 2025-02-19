#!/bin/bash
# Record starting time (second)
start_time=$(date +%s)

echo "Starts tasks: $(date)"

# Define paths
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
TERRAFORM_DIR="$BASE_DIR/terraform"
SCRIPTS_DIR="$BASE_DIR/scripts"
ANSIBLE_DIR="$BASE_DIR/ansible"

# Step 1: Run Terraform apply
echo "[INFO] Running Terraform apply..."
cd "$TERRAFORM_DIR" || { echo "[ERROR] Terraform directory not found!"; exit 1; }
terraform init && terraform apply -auto-approve
if [ $? -ne 0 ]; then
    echo "[ERROR] Terraform apply failed!"
    exit 1
fi

# Step 2: Run generate_ssh_key.sh
echo "[INFO] Generating SSH key..."
cd "$SCRIPTS_DIR" || { echo "[ERROR] Scripts directory not found!"; exit 1; }
chmod +x generate_ssh_key.sh
./generate_ssh_key.sh
if [ $? -ne 0 ]; then
    echo "[ERROR] SSH key generation failed!"
    exit 1
fi

ssh-keygen -f ~/.ssh/known_hosts -R 172.18.0.2
ssh-keygen -f ~/.ssh/known_hosts -R 172.18.0.3
ssh-keygen -f ~/.ssh/known_hosts -R 172.18.0.4

# Step 3: Run Ansible playbook
echo "[INFO] Running Ansible playbook..."
cd "$ANSIBLE_DIR" || { echo "[ERROR] Ansible directory not found!"; exit 1; }
chmod +x run_playbooks.sh
./run_playbooks.sh
if [ $? -ne 0 ]; then
    echo "[ERROR] Ansible playbook execution failed!"
    exit 1
fi

echo "[SUCCESS] All steps completed successfully!"


# Record end time(second)
end_time=$(date +%s)
echo "End tasks: $(date)"

# Total time taken(minute)
elapsed_time=$(( (end_time - start_time) / 60 ))

echo "Total time taken: ${elapsed_time} minutes"
