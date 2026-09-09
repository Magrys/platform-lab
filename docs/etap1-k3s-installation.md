# Etap 1 — K3s Installation on WSL2 (Platform Lab)

## 1. Overview

This document describes the installation of a single-node K3s cluster inside WSL2.  
It covers WSL configuration, resource allocation, K3s installation, kubeconfig setup, and cluster verification.

---

## 2. Configure WSL Resources (`.wslconfig`)

Create the file in C:\Users\magda\.wslconfig:

[wsl2]
memory=12GB
processors=6
swap=4GB
localhostForwarding=true

Restart WSL (required)
In PowerShell:
wsl --shutdown
Start Ubuntu again:
wsl -d Ubuntu

Verify resources:
free -h
nproc

Expected:
Memory: ~11–12 GB
Swap: 4 GB
CPU: 6

## 3. Install K3s

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -
Traefik is disabled because the lab uses Nginx Ingress instead.

## 4. Verify the cluster

sudo k3s kubectl get nodes
sudo k3s kubectl get pods -A

Expected components:
coredns
local-path-provisioner
metrics-server (optional)

## 5. Configure kubeconfig

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

Set kubeconfig permanently
Add to ~/.bashrc:
export KUBECONFIG=~/.kube/config
Reload:
source ~/.bashrc

## 6. Summary

After completing this stage:
WSL2 is configured with correct CPU/RAM/swap limits
K3s is installed and running
kubeconfig is set up correctly
kubectl works without sudo
The node is in Ready state
The cluster is prepared for Ingress, Cert Manager, ArgoCD, monitoring, and AI workloads. 