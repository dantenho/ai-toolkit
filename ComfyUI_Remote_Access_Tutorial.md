# ComfyUI Remote Access Tutorial

## 📋 Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Step 1: Configure ComfyUI Network Settings](#step-1-configure-comfyui-network-settings)
4. [Step 2: Configure Windows Firewall](#step-2-configure-windows-firewall)
5. [Step 3: Find Your IP Address](#step-3-find-your-ip-address)
6. [Step 4: Access ComfyUI Remotely](#step-4-access-comfyui-remotely)
7. [Security Considerations](#security-considerations)
8. [Troubleshooting](#troubleshooting)
9. [Advanced: HTTPS Setup (Optional)](#advanced-https-setup-optional)

---

## Overview

This tutorial will guide you through configuring ComfyUI to allow remote access, enabling you and your friends to use ComfyUI from any device on the same network or over the internet.

**What you'll learn:**
- How to configure ComfyUI's network settings
- How to set up Windows Firewall rules
- How to find your IP address
- How to securely access ComfyUI remotely

---

## Prerequisites

- ComfyUI installed and running
- Administrator access to your Windows computer
- Both devices (yours and your friend's) on the same network (for local access)
- OR port forwarding configured on your router (for internet access)

---

## Step 1: Configure ComfyUI Network Settings

### 1.1 Open ComfyUI Settings

1. Launch ComfyUI
2. Navigate to the **Settings** or **Network** configuration panel
3. Locate the Network configuration section

### 1.2 Configure Network Parameters

Update the following settings:

| Setting | Value | Explanation |
|---------|-------|-------------|
| **Host** | `0.0.0.0` | Listen on all network interfaces (required for remote access) |
| **Port** | `8188` | Default ComfyUI port (or your preferred port) |
| **TLS Key File** | *(Leave empty for HTTP)* | Path to TLS key file (only if using HTTPS) |
| **TLS Certificate File** | *(Leave empty for HTTP)* | Path to TLS certificate file (only if using HTTPS) |
| **Enable CORS header** | `*` | Allows all origins (or specify specific domain) |
| **Maximum upload size (MB)** | `100` | Adjust based on your needs |

### 1.3 Important Notes

- **Host `0.0.0.0`**: This is crucial! It allows ComfyUI to accept connections from any network interface, not just localhost.
- **Port**: The default port is `8188`. Make sure this port is not used by another application.
- **CORS**: Setting to `*` allows any website to access the API. For production, consider restricting this.

### 1.4 Save and Restart

1. Click **Save** or **Apply** to save your settings
2. **Restart ComfyUI** for the changes to take effect

---

## Step 2: Configure Windows Firewall

Windows Firewall will block incoming connections by default. You need to allow ComfyUI through the firewall.

### 2.1 Method 1: Using Windows Defender Firewall GUI

1. Press `Win + R`, type `wf.msc`, and press Enter
2. Click **Inbound Rules** in the left panel
3. Click **New Rule...** in the right panel
4. Select **Port** and click **Next**
5. Select **TCP** and enter your port number (e.g., `8188`)
6. Click **Next**
7. Select **Allow the connection** and click **Next**
8. Check all three profiles (Domain, Private, Public) and click **Next**
9. Name it "ComfyUI Remote Access" and click **Finish**

### 2.2 Method 2: Using PowerShell (Administrator)

Open PowerShell as Administrator and run:

```powershell
New-NetFirewallRule -DisplayName "ComfyUI Remote Access" -Direction Inbound -Protocol TCP -LocalPort 8188 -Action Allow
```

### 2.3 Verify Firewall Rule

1. Open Windows Defender Firewall
2. Go to **Inbound Rules**
3. Look for "ComfyUI Remote Access" rule
4. Ensure it's **Enabled** and set to **Allow**

---

## Step 3: Find Your IP Address

Your friend needs your IP address to connect to ComfyUI.

### 3.1 Find Your Local IP Address (Same Network)

**Method 1: Using Command Prompt**
1. Press `Win + R`, type `cmd`, and press Enter
2. Type `ipconfig` and press Enter
3. Look for **IPv4 Address** under your active network adapter
   - Usually looks like: `192.168.1.xxx` or `10.0.0.xxx`

**Method 2: Using PowerShell**
```powershell
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} | Select-Object IPAddress, InterfaceAlias
```

### 3.2 Find Your Public IP Address (Internet Access)

If your friend is on a different network, you need your public IP:

1. Visit: https://whatismyipaddress.com/
2. Note your **IPv4 Address**
3. **Important**: You'll also need to configure port forwarding on your router (see Advanced section)

---

## Step 4: Access ComfyUI Remotely

### 4.1 For Local Network Access (Same Wi-Fi/Network)

1. **On your computer**: Note your local IP address (from Step 3.1)
2. **On your friend's device**: Open a web browser
3. Navigate to: `http://YOUR_LOCAL_IP:8188`
   - Example: `http://192.168.1.100:8188`

### 4.2 For Internet Access (Different Networks)

1. **On your computer**: Note your public IP address (from Step 3.2)
2. **Configure port forwarding** on your router (see Advanced section)
3. **On your friend's device**: Open a web browser
4. Navigate to: `http://YOUR_PUBLIC_IP:8188`
   - Example: `http://203.0.113.45:8188`

### 4.3 Verify Connection

- You should see the ComfyUI interface
- Both you and your friend can now use ComfyUI simultaneously
- Changes made by one user will be visible to all connected users

---

## Security Considerations

### ⚠️ Important Security Warnings

1. **HTTP vs HTTPS**
   - HTTP (default) sends data unencrypted
   - Anyone on the network can potentially intercept data
   - **Recommendation**: Use HTTPS for production or sensitive work

2. **Network Access**
   - Opening ComfyUI to `0.0.0.0` makes it accessible to anyone on your network
   - For internet access, ensure you have proper security measures

3. **Authentication**
   - ComfyUI doesn't have built-in authentication by default
   - Consider using a reverse proxy (nginx, Apache) with authentication
   - Or use a VPN for secure remote access

4. **Firewall Rules**
   - Only allow the specific port needed
   - Consider restricting access to specific IP addresses if possible

### 🔒 Recommended Security Practices

- Use HTTPS with valid certificates
- Implement authentication (reverse proxy or VPN)
- Restrict CORS to specific domains
- Regularly update ComfyUI
- Monitor access logs
- Use a VPN for internet access instead of direct exposure

---

## Troubleshooting

### Problem: Friend cannot connect

**Solutions:**
1. ✅ Verify ComfyUI is running
2. ✅ Check Host is set to `0.0.0.0` (not `127.0.0.1`)
3. ✅ Verify Windows Firewall rule is enabled
4. ✅ Confirm correct IP address and port
5. ✅ Check if another application is using the port
6. ✅ Ensure both devices are on the same network (for local access)
7. ✅ Try disabling Windows Firewall temporarily to test (re-enable after!)

### Problem: Connection timeout

**Solutions:**
1. Check router firewall settings
2. Verify port forwarding (for internet access)
3. Check if ISP blocks the port
4. Try a different port number

### Problem: CORS errors in browser

**Solutions:**
1. Set CORS header to `*` in ComfyUI settings
2. Or specify the exact origin domain
3. Clear browser cache and cookies

### Problem: Port already in use

**Solutions:**
1. Change ComfyUI port to a different number (e.g., `8189`, `8190`)
2. Or stop the application using the port:
   ```powershell
   # Find process using port 8188
   netstat -ano | findstr :8188
   # Kill the process (replace PID with actual process ID)
   taskkill /PID <PID> /F
   ```

### Problem: Can't find IP address

**Solutions:**
1. Ensure network adapter is enabled
2. Check network connection status
3. Try `ipconfig /all` for detailed information
4. Use `Get-NetIPConfiguration` in PowerShell

---

## Advanced: HTTPS Setup (Optional)

For secure remote access, you can set up HTTPS:

### Option 1: Self-Signed Certificate (Testing Only)

1. Generate self-signed certificate using OpenSSL:
   ```bash
   openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
   ```

2. In ComfyUI settings:
   - **TLS Key File**: Path to `key.pem`
   - **TLS Certificate File**: Path to `cert.pem`

3. Access via: `https://YOUR_IP:8188`
   - Browser will show security warning (click "Advanced" → "Proceed")

### Option 2: Let's Encrypt Certificate (Production)

1. Use Certbot to obtain free SSL certificate
2. Configure certificate paths in ComfyUI
3. Set up automatic renewal

### Option 3: Reverse Proxy (Recommended)

Use nginx or Apache as reverse proxy:
- Handles SSL/TLS termination
- Provides authentication
- Better security and performance

---

## Quick Reference Checklist

- [ ] Host set to `0.0.0.0` in ComfyUI settings
- [ ] Port configured (default: `8188`)
- [ ] CORS enabled (set to `*` or specific domain)
- [ ] Windows Firewall rule created and enabled
- [ ] IP address identified (local or public)
- [ ] ComfyUI restarted after configuration
- [ ] Tested connection from remote device
- [ ] Security measures considered (HTTPS, authentication)

---

## Additional Resources

- [ComfyUI GitHub Repository](https://github.com/comfyanonymous/ComfyUI)
- [ComfyUI Documentation](https://github.com/comfyanonymous/ComfyUI/wiki)
- Windows Firewall Documentation
- Network Port Forwarding Guides

---

## Support

If you encounter issues not covered in this tutorial:
1. Check ComfyUI logs for error messages
2. Review Windows Event Viewer for firewall/network issues
3. Test with firewall temporarily disabled (for troubleshooting only)
4. Consult ComfyUI community forums or GitHub issues

---

**Last Updated**: 2024
**Version**: 1.0

---

## Summary

To enable remote access to ComfyUI:

1. **Set Host to `0.0.0.0`** in ComfyUI network settings
2. **Configure Windows Firewall** to allow the port
3. **Share your IP address** with your friend
4. **Access via**: `http://YOUR_IP:8188`

Remember to consider security implications when exposing ComfyUI to the network!

