# Lab 04: Visualizing Zero Trust Security with Cilium & Hubble

> **Duration:** 25 minutes

Welcome to the final lab! Here, we'll bring everything together in a powerful visual demonstration. You will deploy a multi-service application, observe its open network traffic, and then enforce a "Zero Trust" security policy using Cilium. The Hubble UI will give us a real-time map of what's happening.

## What You'll Learn

- How to deploy a multi-service application to Kubernetes.
- How to use the Hubble UI to visualize live network traffic.
- The meaning of "Zero Trust" in a practical context.
- How to write and apply a Cilium Network Policy to enforce security rules.
- How to visually confirm that a network policy is working.

## The Scenario: One Policy to Rule Them All...

We will deploy a simple application inspired by The Lord of the Rings:

-   **Barad-dûr:** Sauron's fortress, which has a powerful seeing stone (a Palantir). It has two endpoints:
    -   `/`: A public endpoint (everyone can see the tower).
    -   `/v1/palantir`: A sensitive endpoint that should only be accessed by authorized servants.
-   **Nazgûl:** A servant of Sauron that is **authorized** to use the Palantir.
-   **Hobbit:** A creature from the Shire that is **unauthorized** and must be blocked from using the Palantir.

Our goal is to use a Cilium Network Policy to allow the Nazgûl's request while blocking the Hobbit's request.

## Step 1: Deploy the Application

First, we'll deploy all the application components to your Kind cluster.

```bash
cd ~/ubucon/ubucon-workshop2026/lab-04-cilium-demo

# Apply all the manifests
kubectl apply -f manifests/

# Watch the pods start up
kubectl get pods -n mordor -w
```

Wait until all pods (`barad-dur`, `nazgul`, and `hobbit`) show a `Running` status. Press `Ctrl+C` to exit the watch command once they are ready.

## Step 2: Observe Unrestricted Traffic with Hubble

Before we apply any security, let's see what the network looks like.

1.  **Open the Hubble UI:**
    ```bash
    cilium hubble ui
    ```
    This will open the Hubble UI in your browser (usually at `http://localhost:12000`).

2.  **Generate Traffic:**
    In a **new terminal**, run the traffic generation script. This script will make both the Nazgûl and the Hobbit continuously try to access Barad-dûr's sensitive Palantir.

    ```bash
    # Make the script executable
    chmod +x scripts/generate-traffic.sh

    # Run the script
    ./scripts/generate-traffic.sh
    ```

3.  **Observe in Hubble:**
    -   In the Hubble UI, select the **`mordor`** namespace from the dropdown menu.
    -   You should see lines connecting both the `nazgul` and the `hobbit` to the `barad-dur` service.
    -   Notice that all traffic is **GREEN**, indicating it is all being allowed. **This is the security risk we need to fix!**

Leave the traffic script running for the next step.

## Step 3: Apply the Cilium Network Policy

Now, let's lock down Barad-dûr. We will apply a Cilium Network Policy that enforces our desired security rule.

```bash
# In your first terminal, apply the policy
kubectl apply -f policies/
```

### Understanding the Policy

This policy does two things:
1.  It selects the `barad-dur` pod.
2.  It defines an `ingress` (incoming traffic) rule that only allows requests to the `/v1/palantir` path if they come from pods with the label `race: nazgul`. The `nazgul` pod has this label, but the `hobbit` pod does not.

## Step 4: Visually Confirm the Policy Works

Return to the Hubble UI in your browser.

-   You will now see a dramatic change.
-   The traffic from the `nazgul` to `barad-dur` remains **GREEN** (Allowed).
-   The traffic from the `hobbit` to `barad-dur` is now **RED** (Blocked/Dropped).

You have visually confirmed that your Zero Trust policy is working exactly as intended! The policy is being enforced by eBPF in the Linux kernel, making it incredibly fast and secure.

## Cleanup

Once you are finished, you can stop the traffic script (`Ctrl+C` in the second terminal) and delete the application resources.

```bash
# Delete the namespace and all its contents
kubectl delete namespace mordor
```

## Congratulations!

You have successfully implemented and visualized a Zero Trust network security policy using Cilium and Hubble. You've seen firsthand how to define granular, identity-based rules and instantly observe their effect on your application's traffic.

This concludes the UbuCon Kenya 2026 workshop. Thank you for participating!
