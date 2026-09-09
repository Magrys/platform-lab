# Security Guidelines for Platform Lab

This project is designed to be fully public and safe to share as a technical portfolio.
To maintain security and privacy, follow these rules:

Do NOT commit:
- Raw output from systeminfo, ipconfig, Get-CimInstance
- Hostnames, IP addresses, MAC addresses
- Windows Product IDs or license information
- Personal email addresses or user names
- Secrets, tokens, kubeconfigs, certificates, SSH keys

Allowed:
- Abstracted hardware summaries
- High-level system descriptions
- Kubernetes manifests without secrets
- Terraform/Ansible code without credentials
