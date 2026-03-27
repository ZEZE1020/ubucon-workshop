# Lab 03: Deploy a Local Kubernetes Cluster with Kind & Cilium

> **Duration:** 20 minutes

In this lab, you will deploy a fully functional, local Kubernetes cluster on your machine using **Kind** (Kubernetes in Docker). We will then install **Cilium** to manage the cluster's networking and security.

## What You'll Learn

- How to create a local Kubernetes cluster with Kind.
- How to install Cilium to handle network traffic.
- How to verify that your cluster and its networking are healthy.
- How to enable the Hubble UI to see network traffic.

## Step 1: Create the Kind Cluster

We will use a simple script to create the cluster. This script contains a special configuration that disables the default networking plugin, allowing us to install Cilium instead.

1.  **Navigate to the lab directory:**
    ```bash
    cd ~/ubucon/ubucon-workshop2026/lab-03-kind-cilium
    ```

2.  **Make the installation script executable:**
    ```bash
    chmod +x install-kind-cilium.sh
    ```

3.  **Run the script:**
    ```bash
    ./install-kind-cilium.sh
    ```

    This script will:
    -   Create a Kind cluster named `ubucon-workshop`.
    -   Install the Cilium CLI.
    -   Install Cilium into your cluster.
    -   Wait for all the components to be ready.

    The process should take a few minutes. You will see a lot of output as the tools are downloaded and the cluster is configured.

## Step 2: Verify the Installation

Once the script finishes, you can check that everything is working correctly.

1.  **Check the Cilium status:**
    ```bash
    cilium status --wait
    ```
    You should see output indicating that all components are healthy.

    ```text
        /¯¯\\
 /¯¯\\__/¯¯\\    Cilium:         OK
 \\__/¯¯\\__/    Operator:       OK
 /¯¯\\__/¯¯\\    Envoy DaemonSet:  OK
 \\__/¯¯\\__/    Hubble Relay:   OK
    \\__/       ClusterMesh:    disabled

Deployment        hubble-ui          OK
DaemonSet         cilium             OK
Deployment        cilium-operator    OK
...
    ```

2.  **Check your Kubernetes nodes:**
    ```bash
    kubectl get nodes
    ```
    You should see one node named `ubucon-workshop-control-plane` with the status `Ready`.

## Step 3: Enable the Hubble UI

Hubble is a tool that comes with Cilium that lets you see the traffic between your applications. Let's turn on its user interface.

1.  **Enable the Hubble UI:**
    ```bash
    cilium hubble enable --ui
    ```

2.  **Forward the UI to your local machine:**
    ```bash
    cilium hubble ui
    ```
    This command will open the Hubble UI in your web browser, usually at `http://localhost:12000`. You won't see much traffic yet, but we will change that in the next lab.

## Summary

![Hubble, K8s, and Cilium](HubbleK8S,cillium.png)

Congratulations! You now have a fully functional Kubernetes cluster running locally, powered by Kind and Cilium. Your environment is ready for deploying applications and defining network policies.

**[Next Lab: Lab 04 - Visualizing Network Policies](../lab-04-cilium-demo/)**