# Demo Application Deployment with ArgoCD, Ingress and TLS (WSL2 + K3s)

This document describes the deployment of a demo application using GitOps with ArgoCD, including Ingress configuration, TLS termination, and exposing HTTPS traffic through NodePort in a WSL2 + K3s environment.

---

## 1. Environment Overview

- **Platform:** WSL2 (Windows Subsystem for Linux)
- **Kubernetes distribution:** K3s
- **GitOps tool:** ArgoCD
- **Ingress controller:** ingress-nginx
- **TLS:** cert-manager (self-signed or staging)
- **Access method:** HTTPS via NodePort exposed to Windows

WSL2 uses a virtualized network stack, so NodePort exposure is required for Windows to reach the Ingress controller.

---

## 2. Demo Application Structure

Repository structure:
demo-app/
├── deployment.yaml
├── service.yaml
├── ingress.yaml
└── kustomization.yaml

ArgoCD monitors this folder and automatically synchronizes changes into the cluster.

---

## 3. ArgoCD Application

The application is defined as:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-app
spec:
  project: default
  source:
    repoURL: <your-repo-url>
    path: demo-app
    targetRevision: HEAD
  destination:
    server: https://kubernetes.default.svc
    namespace: demo-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true

Status in ArgoCD:

Healthy
Synced

## 4.  Ingress + TLS The demo application is exposed through ingress-nginx:

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-app
  annotations:
    cert-manager.io/cluster-issuer: "selfsigned-issuer"
spec:
  tls:
    - hosts:
        - demo.local
      secretName: demo-app-tls
  rules:
    - host: demo.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: demo-app
                port:
                  number: 80

TLS is terminated at the Ingress controller.

## 5. Exposing HTTPS to Windows (NodePort)
WSL2 cannot route HTTPS traffic directly to the Ingress controller.
To allow Windows to access the application, the Ingress controller service must be exposed via NodePort.

Final service configuration:

spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      targetPort: 80
      nodePort: 31745
    - name: https
      port: 443
      targetPort: 443
      nodePort: 30259

6. Windows Hosts Entry
Add the following entry to Windows hosts file:
172.24.64.69 demo.local
This maps the hostname to the WSL2 network interface.

7. Connectivity Test (Windows)
Verify that Windows can reach the HTTPS NodePort:
powershell
Test-NetConnection -ComputerName 172.24.64.69 -Port 30259
Expected:
TcpTestSucceeded : True
8. Accessing the Application
Open in Windows browser:
https://demo.local:30259
You should see the default Nginx welcome page or your application UI.

9. Summary
Demo application deployed via ArgoCD
Ingress + TLS configured
HTTPS exposed to Windows through NodePort
Application reachable at https://demo.local:30259
GitOps workflow fully operational
This completes the deployment stage and prepares the environment for adding additional applications.