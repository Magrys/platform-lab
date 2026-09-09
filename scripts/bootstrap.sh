#!/usr/bin/env bash
set -euo pipefail

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential ca-certificates gnupg lsb-release

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Bootstrap complete."
