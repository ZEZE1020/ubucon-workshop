# Lab 02: WSL & Systemd Setup

> **Duration:** 10 minutes

This lab is for **Windows users only**. If you are on Linux or macOS, you can skip this lab.

In Lab 00, you installed Ubuntu on WSL. Now, we need to enable a feature called `systemd`.

## Why Enable `systemd`?

`systemd` is a program that starts and manages other services in Linux. We need it to run tools like Kubernetes (K3s), which we will install in the next lab. While newer versions of WSL enable this by default, these steps ensure it is active.

## Step 1: Enable `systemd` in Ubuntu

1.  **Open your Ubuntu terminal.**

2.  **Create or edit the WSL configuration file** using the `nano` text editor.

    ```bash
    sudo nano /etc/wsl.conf
    ```

3.  **Add these two lines to the file.** This tells WSL to use `systemd` when it boots up.

    ```ini
    [boot]
    systemd=true
    ```

4.  **Save and close the file.** In `nano`, press `Ctrl+X`, then `Y` to confirm, and `Enter`.

5.  **Shut down your WSL instance.** This change requires a full restart of WSL. Open **PowerShell** or Windows Terminal and run:

    ```powershell
    wsl --shutdown
    ```

6.  **Restart your Ubuntu terminal.** When you open it again, it will be running with `systemd`.

## Step 2: Verify `systemd` is Running

Check that `systemd` is the first process running.
```bash
ps -p 1 -o comm=
```
The output should be `systemd`. If it is not, go through the steps again and check the troubleshooting section.

## Troubleshooting

### `wsl.conf` changes not taking effect
Make sure you run `wsl --shutdown` in PowerShell after saving the file. This is required to apply the new settings.

### Command `nano` not found
If you get an error that `nano` is not found, you can install it with `sudo apt update && sudo apt install nano`.

## Next Step

Your environment is now ready for Kubernetes!

Proceed to **[Lab 03: K3s + Cilium](../lab-03-k3s-cilium/)**.
