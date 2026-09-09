# Stage 2 — Nginx Ingress Controller Installation (Platform Lab)

## 1. Overview

This document describes the installation of the Nginx Ingress Controller on a single-node K3s cluster running inside WSL2.  
The goal of this stage is to enable HTTP/HTTPS routing for all platform components (ArgoCD, OpenWebUI, Prometheus, Grafana, custom apps).

K3s ships with Traefik by default, but Traefik was intentionally disabled during installation:
INSTALL_K3S_EXEC="--disable traefik"

## 2. Install the correct (baremetal) Ingress manifest

The baremetal manifest is the recommended option for K3s, WSL2, VMs and non-cloud environments.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml

This manifest uses:
- `NodePort`
- `hostPort`
- no cloud LoadBalancer integration
- stable behavior in K3s

---

## 4. Verify Ingress Controller

Check pods:
kubectl get pods -n ingress-nginx
Expected:
- `ingress-nginx-controller` → **Running**

---

## 5. Verify Ingress Services

kubectl get svc -n ingress-nginx

Expected:
ingress-nginx-controller   NodePort   80:31745/TCP, 443:30259/TCP
ingress-nginx-controller-admission   ClusterIP

This is correct for baremetal mode.

---

## 6. Test Ingress availability

Find node IP:
kubectl get nodes -o wide

Test Ingress:
curl -I http://<NODE-IP>:<NODEPORT>
Example:
curl -I http://172.24.64.69:31745
HTTP/1.1 404 Not Found

A `404` response is expected and confirms that the controller is working.


# Stage 2 — Cert Manager Installation (Platform Lab)

## 1. Overview

Cert Manager provides automated certificate management for Kubernetes.  
It is required for:
- ArgoCD HTTPS access
- OpenWebUI HTTPS
- Prometheus/Grafana TLS
- local domain certificates
- future ACME/Let’s Encrypt integration

---

## 2. Install Cert Manager

Create namespace:
kubectl create namespace cert-manager

Install CRDs + components:
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.1/cert-manager.yaml

Verify:
kubectl get pods -n cert-manager

Expected:

- `cert-manager`
- `cert-manager-webhook`
- `cert-manager-cainjector`

All **Running**.

---

## 3. Create a ClusterIssuer (self-signed)

This issuer will generate certificates for local development.

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
name: selfsigned
spec:
selfSigned: {}
EOF

Verify:
kubectl get clusterissuer
Expected:
selfsigned   True

---

## 4. Issue a test certificate

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
name: test-cert
namespace: default
spec:
secretName: test-cert-tls
issuerRef:
name: selfsigned
kind: ClusterIssuer
commonName: test.local
dnsNames:
  test.local
EOF

Verify:
kubectl get certificate
kubectl describe certificate test-cert
kubectl get secret test-cert-tls

If the secret exists → Cert Manager is fully operational.

---

## 5. Summary

After completing Stage 2:

- Nginx Ingress Controller is installed and operational  
- Ports are exposed via NodePort and hostPort  
- Cert Manager is installed and healthy  
- ClusterIssuer is ready  
- Certificate issuance works  
- The platform is ready for Stage 3 (ArgoCD installation)