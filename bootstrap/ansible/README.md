# Ansible Bootstrap for elitedesk

This Ansible playbook prepares an Ubuntu 24.04 server for use with a k3s-based GitOps setup.  
The playbook is stored in this repository to ensure full transparency, automation, and reproducibility.

## 🧩 What does this playbook do?

1. Updates and upgrades the system
2. Installs required packages (`curl`, `nfs-common`, etc.)
3. Installs k3s (without Traefik)
4. Ensures the NFS client is installed
5. Fetches the kubeconfig from the server and stores it on your workstation at `~/.kube/elitedesk-k3s.yaml`

## 📁 Structure

```
bootstrap/ansible/
├── inventory.ini          # List of target hosts
├── playbook.yaml          # Main playbook
├── roles/
│   ├── common/            # OS-level setup tasks
│   └── k3s/               # k3s installation and kubeconfig fetch
└── README.md              # This file
```

## 🚀 Running the Playbook

Make sure you have Ansible installed on your local machine:

```bash
sudo apt install ansible
```

Or with pip:

```bash
pip install ansible
```

Update the `inventory.ini` file with your server's IP address, SSH username, and private key path.

Example:

```ini
[elitedesk]
192.168.104.151 ansible_user=sysadmin ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

Then run the playbook:

```bash
cd bootstrap/ansible
ansible-playbook -i inventory.ini playbook.yaml --ask-become-pass
```

## 📥 Kubeconfig Setup

After the playbook runs successfully:

- Your `k3s.yaml` file will be fetched from the server and saved to your workstation as:
  ```
  ~/.kube/elitedesk-k3s.yaml
  ```

- The file will be automatically updated with the correct server IP address (`192.168.104.151`)
- Permissions are secured (`0600`)

To use it:

```bash
export KUBECONFIG=~/.kube/elitedesk-k3s.yaml
kubectl get nodes
```

Optional: Rename context and set it as default:

```bash
kubectl config --kubeconfig=~/.kube/elitedesk-k3s.yaml rename-context default elitedesk
kubectl config use-context elitedesk
```

## 🔐 Requirements

- SSH access to the target server
- The user in `inventory.ini` must have `sudo` rights
- Passwordless `sudo` is recommended for automation
