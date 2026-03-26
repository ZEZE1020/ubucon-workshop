# Lab 03: Secrets Management with SOPS

> **Duration:** 25 minutes

In this lab, you'll learn how to securely manage secrets using SOPS (Secrets OPerationS) with age encryption, making it safe to store encrypted secrets in Git.

## What You'll Learn

- Generate age encryption keys
- Encrypt Kubernetes secrets with SOPS
- Build secure containers with Canonical Chiseled images
- Deploy secrets safely to Kubernetes

## Platform Notes

| Platform | Notes |
|----------|-------|
| **All platforms** | SOPS and age work the same way everywhere |
| **macOS (Lima)** | Run commands inside the VM: `limactl shell workshop` |
| **Docker builds** | Require Docker or compatible runtime |

## Why SOPS + age?

| Traditional Approach | SOPS + age Approach |
|---------------------|--------------------|
| Secrets in plain text | Secrets encrypted at rest |
| Can't commit to Git | Safe to commit to Git |
| Manual key distribution | Key management via age |
| Hard to audit changes | Full Git history of changes |

## Lab Structure

```
lab-03-secrets-sops/
├── app/
│   ├── main.py           # FastAPI application
│   ├── requirements.txt  # Python dependencies
│   ├── Dockerfile        # Multi-stage build with Chiseled Ubuntu
│   └── secrets.yaml      # Kubernetes secret (encrypt this!)
└── scripts/
    ├── generate-age-key.sh   # Create encryption key
    └── encrypt-in-place.sh   # Encrypt secrets file
```

## Step 1: Generate Encryption Key

```bash
cd ~/workshops/ubucon-workshop2026/lab-03-secrets-sops/scripts

# Make scripts executable
chmod +x *.sh

# Generate age key
./generate-age-key.sh
```

This creates:
- `~/.sops/key.txt` - Your private key (NEVER commit this!)
- `.sops.yaml` - SOPS configuration file

### Understanding the Key

```bash
# View your public key (safe to share)
grep "public key" ~/.sops/key.txt

# The output looks like:
# public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Step 2: Examine the Unencrypted Secret

```bash
# View the plaintext secret
cat ../app/secrets.yaml
```

You'll see something like:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-credentials
stringData:
  DB_PASSWORD: "super-secret-password-123!"
  DB_USER: "admin"
```

**This is dangerous!** Anyone with repo access can see these credentials.

## Step 3: Encrypt the Secret

```bash
# Encrypt the secrets file in place
./encrypt-in-place.sh
```

### View the Encrypted Result

```bash
cat ../app/secrets.yaml
```

Now it looks like:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-credentials
stringData:
  DB_PASSWORD: ENC[AES256_GCM,data:xxxxx,iv:xxxxx,tag:xxxxx]
  DB_USER: ENC[AES256_GCM,data:xxxxx,iv:xxxxx,tag:xxxxx]
sops:
  age:
    - recipient: age1xxxxxxxxx
      enc: |
        -----BEGIN AGE ENCRYPTED FILE-----
        ...
```

**This is safe to commit!** Only someone with the private key can decrypt it.

## Step 4: Working with Encrypted Files

### Decrypt to View

```bash
# Decrypt and print to stdout (doesn't modify file)
sops -d ../app/secrets.yaml
```

### Edit Encrypted File

```bash
# Opens decrypted content in editor, re-encrypts on save
sops ../app/secrets.yaml
```

### Decrypt for Kubernetes

```bash
# Decrypt and apply to cluster
sops -d ../app/secrets.yaml | kubectl apply -f -
```

## Step 5: Build the Secure Container (Optional)

The Dockerfile uses a multi-stage build with Canonical Chiseled Ubuntu:

```bash
cd ../app

# Examine the Dockerfile
cat Dockerfile
```

### Key Security Features

1. **Multi-stage build**: Build dependencies don't end up in final image
2. **Chiseled base image**: No shell, no package manager, minimal attack surface
3. **Non-root user**: Application runs without root privileges

### Build the Image

```bash
# Build the container (requires Docker)
docker build -t secrets-demo:v1 .

# Check image size (should be very small)
docker images secrets-demo:v1
```

## Step 6: Deploy to Kubernetes

```bash
# Create namespace
kubectl create namespace secrets-demo

# Deploy the encrypted secret (decrypted on-the-fly)
sops -d secrets.yaml | kubectl apply -n secrets-demo -f -

# Verify secret was created
kubectl get secrets -n secrets-demo
```

## Understanding Chiseled Containers

```
+-------------------------------------------------------------+
|              Traditional Container                          |
|  +-------------------------------------------------------+  |
|  |  Shell (bash, sh)                                     |  |
|  |  Package Manager (apt, dpkg)                          |  |
|  |  System Utilities (ls, cat, curl, wget...)            |  |
|  |  Documentation, man pages                             |  |
|  |  Your Application                                     |  |
|  +-------------------------------------------------------+  |
|  Size: ~150-500 MB        Attack Surface: LARGE             |
+-------------------------------------------------------------+

+-------------------------------------------------------------+
|              Chiseled Container                             |
|  +-------------------------------------------------------+  |
|  |  Your Application                                     |  |
|  |  Minimal runtime libraries only                       |  |
|  +-------------------------------------------------------+  |
|  Size: ~20-50 MB          Attack Surface: MINIMAL           |
+-------------------------------------------------------------+
```

## Installing SOPS and age Manually

If the scripts don't install them automatically:

### Ubuntu/Debian

```bash
# Install age
sudo apt install -y age

# Install sops
SOPS_VERSION="3.8.1"
curl -LO "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64"
sudo mv "sops-v${SOPS_VERSION}.linux.amd64" /usr/local/bin/sops
sudo chmod +x /usr/local/bin/sops
```

### Fedora

```bash
sudo dnf install -y age
# Install sops same as above
```

### macOS

```bash
brew install age sops
```

## SOPS Best Practices

| Do | Don't |
|----|-------|
| Store `.sops.yaml` in repo | Commit private keys |
| Use separate keys per environment | Share keys via chat/email |
| Rotate keys periodically | Use the same key forever |
| Encrypt only sensitive values | Encrypt entire config files |

## Troubleshooting

### "age: error: no identity matched any of the recipients"

Your key doesn't match the encrypted file:
```bash
# Check which key was used to encrypt
grep -A2 "age:" ../app/secrets.yaml

# Verify your key
cat ~/.sops/key.txt
```

### "sops: command not found"

See [Installing SOPS and age Manually](#installing-sops-and-age-manually) above.

### "age: command not found"

See [Installing SOPS and age Manually](#installing-sops-and-age-manually) above.

## Useful Commands

| Command | Description |
|---------|-------------|
| `sops -e file.yaml` | Encrypt file (stdout) |
| `sops -d file.yaml` | Decrypt file (stdout) |
| `sops -i file.yaml` | Edit encrypted file in-place |
| `sops --rotate file.yaml` | Rotate encryption keys |
| `age-keygen` | Generate new age keypair |

## Next Step

Your secrets are now safely encrypted! Proceed to [Lab 04: Network Policies](../lab-04-network-policies/).
