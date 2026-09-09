# Etap 0 — Hardware & System Audit Summary

Get-CimInstance Win32_Processor | Select-Object Name
Name
----
AMD Ryzen 7 4800U with Radeon Graphics

(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
 15,3723678588867

Platform Lab – Hardware & System Audit Summary
This document summarizes the hardware and operating system audit performed on the Lenovo 81YM laptop. The goal of the audit is to validate whether the device can reliably host a local Platform Engineering Lab environment using WSL2, K3s, GitOps, observability tooling, and local AI models.

System Overview
Device: Lenovo 81YM
OS: Windows 11 Home, Build 26200
Virtualization: Hypervisor detected, Virtualization-Based Security enabled
Secure Boot: Enabled
WSL2 Compatibility: Fully supported
Networking: Realtek Wi-Fi + VirtualBox Host-only adapter (not required for Platform Lab)

Conclusion:  
The operating system is modern, secure, and fully compatible with WSL2, Docker Desktop, and Kubernetes tooling.

CPU Analysis
Processor: AMD Ryzen 7 4800U with Radeon Graphics
Cores/Threads: 8 cores / 16 threads
Virtualization Support: Enabled (SVM Mode)

Conclusion:  
The CPU provides excellent performance for local Kubernetes workloads, GitOps pipelines, CI/CD tasks, and CPU-based LLM inference (Ollama, Bielik, Llama). GPU acceleration is not available, but not required for this project.

Memory Analysis
Total Physical Memory: ~15.7 GB
Available Memory at Idle: ~8.1 GB
Recommended WSL2 Allocation: 10–12 GB
Recommended Swap: 4 GB

Conclusion:  
The laptop has enough RAM to run a full single-node K3s cluster with GitOps, monitoring, logging, and lightweight AI workloads.
Resource limits must be carefully configured for each Kubernetes component.

Disk Considerations
Minimum free space: 40–60 GB

Conclusion:  
DIsk space is sufficent.

WSL2 Readiness
The system meets all requirements for WSL2:
Hypervisor active
Secure Boot enabled
Virtualization-Based Security running
Windows 11 kernel compatible with WSL
No blockers detected

Conclusion:  
WSL2 will run reliably and can host the entire Platform Lab stack.

Component Feasibility on This Hardware
Fully Supported
K3s (single-node)
ArgoCD
Nginx Ingress
Cert Manager
Prometheus
Grafana
Loki + Promtail
Kyverno
Trivy
Open WebUI
Ollama (CPU inference)
Bielik / Llama models (CPU inference)
GitHub Actions CI/CD
Terraform + Ansible
AWX (with resource limits)
Optional / Conditional
Longhorn  
Longhorn is memory-intensive and may be used only if resource limits are aggressively tuned.

Final Assessment
The Lenovo 81YM laptop is fully capable of running the complete Platform Lab environment under WSL2, provided that:
WSL2 memory is capped at 10–12 GB
Kubernetes components use strict resource limits
Monitoring stack is deployed in a lightweight configuration
AI workloads use CPU-only inference (supported by Ollama)
This hardware is suitable for learning Kubernetes, GitOps, Platform Engineering, Observability, and local AI operations.

