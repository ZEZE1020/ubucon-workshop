# Lab 05: Zero Trust Network Policies with Cilium

> **Duration:** 30 minutes

In this lab, you'll implement Zero Trust network security using Cilium Network Policies. You'll see how eBPF-powered policies can block unauthorized traffic at the kernel level.

## What You'll Learn

- Deploy a multi-tier application
- Apply Cilium Network Policies
- Observe blocked traffic with Hubble
- Understand Zero Trust networking principles

## Platform Notes

| Platform | Notes |
|----------|-------|
| **All platforms** | Requires K3s cluster from Lab 02 |
| **macOS (Lima)** | Run commands inside the VM: `limactl shell workshop` |
| **macOS (Docker Desktop)** | Works with Docker Desktop Kubernetes |

## Zero Trust Principles

| Traditional Network | Zero Trust Network |
|--------------------|-------------------|
| Trust internal traffic | Verify every request |
| Perimeter-based security | Identity-based security |
| Implicit allow | Explicit allow, implicit deny |
| Network location = trust | No implicit trust |

## Lab Architecture

We'll deploy three components to demonstrate network policies:

```
+-------------------------------------------------------------+
|                    Kubernetes Cluster                       |
|                                                             |
|  +-------------+         +-------------+                   |
|  |   Backend   |<--------|   API       |                   |
|  |   (Redis)   |   OK    |   Server    |                   |
|  |             |         |             |                   |
|  +-------------+         +-------------+                   |
|         ^                                                   |
|         | BLOCKED                                           |
|         |                                                   |
|  +-------------+                                           |
|  |  Untrusted  |                                           |
|  |    Client   |                                           |
|  |             |                                           |
|  +-------------+                                           |
|                                                             |
+-------------------------------------------------------------+
```

- **Backend (Redis)**: The protected data store
- **API Server**: Trusted service that CAN access Redis
- **Untrusted Client**: Simulated attacker that CANNOT access Redis

## Lab Structure

```
lab-04-network-policies/
├── manifests/
│   ├── 01-namespace.yaml         # Create isolated namespace
│   ├── 02-redis-backend.yaml     # Redis deployment
│   ├── 03-api-server.yaml        # Trusted API server
│   └── 04-untrusted-client.yaml  # Simulated attacker
└── policies/
    └── zero-trust-policy.yaml    # Cilium network policies
```

## Step 1: Deploy the Application

```bash
cd ~/workshops/ubucon-workshop2026/lab-04-network-policies

# Deploy all manifests in order
kubectl apply -f manifests/

# Watch pods come up
kubectl get pods -n network-lab -w
```

Wait until all pods show `Running` status (press Ctrl+C to exit watch).

## Step 2: Test Connectivity (Before Policies)

### Test from API Server (should work)

```bash
# Connect to the API server pod
kubectl exec -it -n network-lab deploy/api-server -- sh

# Inside the pod, test Redis connection
nc -zv redis-backend 6379

# Expected: Connection succeeded!
# Type 'exit' to leave the pod
```

### Test from Untrusted Client (should also work - no policies yet!)

```bash
# Connect to the untrusted client pod
kubectl exec -it -n network-lab deploy/untrusted-client -- sh

# Inside the pod, test Redis connection
nc -zv redis-backend 6379

# Expected: Connection succeeded! (This is the problem!)
# Type 'exit' to leave the pod
```

**This is the security gap we need to fix!**

## Step 3: Apply Zero Trust Policies

```bash
# Apply Cilium network policies
kubectl apply -f policies/

# Verify policies are active
kubectl get ciliumnetworkpolicies -n network-lab
```

### Understanding the Policy

```yaml
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  name: protect-redis
spec:
  # Apply to Redis pods
  endpointSelector:
    matchLabels:
      app: redis-backend
  ingress:
  # Only allow from API server
  - fromEndpoints:
    - matchLabels:
        app: api-server
        trusted: "true"
    toPorts:
    - ports:
      - port: "6379"
        protocol: TCP
  # Everything else is implicitly DENIED
```

## Step 4: Test Connectivity (After Policies)

### Test from API Server (should still work)

```bash
kubectl exec -it -n network-lab deploy/api-server -- nc -zv redis-backend 6379

# Expected: Connection succeeded!
```

### Test from Untrusted Client (should be BLOCKED)

```bash
kubectl exec -it -n network-lab deploy/untrusted-client -- nc -zv redis-backend 6379

# Expected: Connection timed out or refused
```

**Zero Trust in action!** The untrusted client can no longer reach Redis.

## Step 5: Observe with Hubble

### Terminal-based Observation

```bash
# Watch all traffic in the namespace
hubble observe --namespace network-lab -f

# Filter for dropped traffic only
hubble observe --namespace network-lab --verdict DROPPED -f
```

### Hubble UI

```bash
# Launch the Hubble UI
cilium hubble ui
```

In the UI:
1. Select the `network-lab` namespace
2. Watch the service map update in real-time
3. See red lines for blocked connections
4. See green lines for allowed connections

**Note for macOS users:** If using Lima, you may need to forward the port:
```bash
# In a separate terminal on macOS
limactl shell workshop -- kubectl port-forward -n kube-system svc/hubble-ui 12000:80
# Then open http://localhost:12000{:target=_blank} in your browser
```

## Step 6: Generate Traffic for Visualization

Open a new terminal and run:

```bash
# Continuously attempt connections from untrusted client
while true; do
  kubectl exec -n network-lab deploy/untrusted-client -- \
    timeout 2 nc -zv redis-backend 6379 2>&1 || true
  sleep 3
done
```

Watch Hubble show the blocked attempts!

## Understanding Cilium Network Policies

### Policy Types

| Type | Controls | Example Use Case |
|------|----------|------------------|
| Ingress | Incoming traffic | Protect databases |
| Egress | Outgoing traffic | Prevent data exfiltration |
| L3/L4 | IP and port based | Basic microsegmentation |
| L7 | Application layer | HTTP path/method filtering |

### Label-Based Selection

Cilium policies use Kubernetes labels to identify pods:

```yaml
# Select pods with these labels
endpointSelector:
  matchLabels:
    app: redis-backend

# Allow traffic from pods with these labels
fromEndpoints:
- matchLabels:
    app: api-server
    trusted: "true"
```

## Cleanup

When you're done experimenting:

```bash
# Remove the network lab
kubectl delete namespace network-lab

# Verify cleanup
kubectl get all -n network-lab
```

## Troubleshooting

### Policies Not Taking Effect

```bash
# Check if Cilium is managing the endpoints
cilium endpoint list

# Verify policy is applied
kubectl describe ciliumnetworkpolicy -n network-lab
```

### Hubble Not Showing Flows

```bash
# Check Hubble status
hubble status

# Restart Hubble relay if needed
kubectl rollout restart deployment/hubble-relay -n kube-system
```

### All Traffic Being Blocked

Check if you have a default-deny policy that's too restrictive:

```bash
# List all policies
kubectl get ciliumnetworkpolicies -A

# Check policy details
kubectl describe cnp -n network-lab
```

### macOS: Cannot Access Hubble UI

If running in Lima, forward the port manually:

```bash
# On macOS host
limactl shell workshop -- kubectl port-forward -n kube-system svc/hubble-ui 12000:80 &
open http://localhost:12000{:target=_blank}
```

## Key Takeaways

1. **Default Deny**: With no policy, all traffic is allowed. Add policies to restrict.
2. **Label-Based**: Policies use labels, not IP addresses - works with dynamic pods.
3. **Kernel-Level**: eBPF enforces policies in the kernel - very fast and secure.
4. **Observable**: Hubble lets you see exactly what's happening in your network.

## Congratulations!

You've completed all the labs! You now know how to:

- Set up a development environment on any OS
- Deploy Kubernetes with K3s and Cilium
- Manage secrets securely with SOPS
- Implement Zero Trust network policies

---

**Thank you for attending the workshop!**
