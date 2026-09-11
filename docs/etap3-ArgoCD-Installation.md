# Stage 2 — ArgoCD Installation (Platform Lab, WSL2-Compatible)

## 1. Overview

This document describes the installation and configuration of ArgoCD on a single‑node K3s cluster running inside WSL2.

Because WSL2 has specific networking limitations (no LoadBalancer, no node‑level port 443 exposure), ArgoCD is intentionally not exposed through Ingress.
Instead, the ArgoCD UI is accessed via NodePort, which is the most stable and fully supported method in WSL2.

This stage prepares the GitOps engine for the platform and ensures reliable access to the ArgoCD UI.


## 2. Install ArgoCD Components

Create the ArgoCD Namespace
kubectl create namespace argocd

Official repo:
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Verify:
kubectl get pods -n argocd
Expected:
argocd-server
argocd-repo-server
argocd-application-controller
argocd-dex-server
argocd-redis

## 3. Expose ArgoCD via NodePort 

WSL2 cannot expose port 443 on the node, and LoadBalancer services are not supported.
Therefore, ArgoCD must be exposed via NodePort.

Patch the ArgoCD server service:
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

Retrieve the NodePort:
kubectl get svc -n argocd argocd-server
Example output:
argocd-server   NodePort   10.43.0.1   <none>   80:32297/TCP   443:30259/TCP

For WSL2, port 80 NodePort is used for UI access:
http://<WSL-IP>:32297

To get the WSL node IP:
kubectl get nodes -o wide

## 4. Retrieve the ArgoCD Admin Password and access the ArgoCD UI

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

Open in browser:
http://<WSL-IP>:<NODEPORT>
Login:
Username: admin
Password: (value retrieved above)