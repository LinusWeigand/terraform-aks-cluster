# Navigate into terraform directory
cd ..
cd terraform

# Run tf init
terraform init -migrate-state

# Run tf apply
terraform apply -auto-approve

# Navigate back to scripts directory
cd ..
cd scripts

# Create deployments
./deployments.sh

# Get services
./get_services.sh