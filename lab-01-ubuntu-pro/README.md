# Lab 01: Get Free Security Updates with Ubuntu Pro

In this lab, we'll enable Ubuntu Pro on your WSL instance. This gives you access to more security updates for many of the open-source tools you use, and it's free for personal use.

**Time to complete:** 15 minutes

## Why Use Ubuntu Pro?

For this workshop, the main benefit of Ubuntu Pro is **Expanded Security Maintenance (ESM)**.

Normally, Ubuntu provides security updates for the main operating system packages. With ESM, you get security patches for thousands of other open-source tools and libraries as well. This helps keep your projects secure.

## Step 1: Get Your Ubuntu Pro Token

1.  Open your web browser and go to [**ubuntu.com/pro/dashboard**](https://ubuntu.com/pro/dashboard).
2.  Log in with your Ubuntu One account. If you don't have one, you can create one for free.
3.  On your dashboard, you will see a "Free Personal Token" section.
4.  Copy the token. It will be part of a command that looks like `sudo pro attach YOUR_TOKEN_HERE`. Keep it handy for the next step.

## Step 2: Connect Your System to Ubuntu Pro

Now, let's use the token in your Ubuntu terminal.

1.  Open your Ubuntu terminal in WSL.

2.  First, make sure your system is up-to-date:
    ```bash
    sudo apt update && sudo apt upgrade -y
    ```

3.  Run the `pro attach` command, pasting in the token you copied from the dashboard.
    ```bash
    # Replace YOUR_TOKEN_HERE with the token from your dashboard
    sudo pro attach YOUR_TOKEN_HERE
    ```

4.  The command will connect to Canonical's servers and enable the extra services on your machine.

    ```text
    Enabling default service esm-apps
    Updating package lists
    Ubuntu Pro: ESM Apps enabled
    Enabling default service esm-infra
    Updating package lists
    Ubuntu Pro: ESM Infra enabled
    This machine is now attached to Ubuntu Pro
    ```

## Step 3: Check the Status

You can see which Pro services are active at any time.

1.  Run the following command:
    ```bash
    pro status
    ```

2.  The output will show you a list of services and whether they are enabled.

    ```text
    SERVICE          ENTITLED  STATUS    DESCRIPTION
    esm-apps         yes       enabled   Expanded Security Maintenance for Applications
    esm-infra        yes       enabled   Expanded Security Maintenance for Infrastructure
    livepatch        yes       enabled   Canonical Livepatch service
    ```

## Summary

Great! Your Ubuntu environment is now connected to the extra security updates provided by Ubuntu Pro.

In the next lab, we will configure `systemd`, which is a necessary step for running tools like Kubernetes.

**[Next Lab: Lab 02 - WSL & Systemd Setup](../lab-02-wsl-setup/README.md)**
