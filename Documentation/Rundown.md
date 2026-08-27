# AD Homelab Runbook - [Your Name]
**Project Start Date:** [Today's Date]

---

## 1.0 Prerequisites
*(We'll fill this in later)*

---

## 2.0 Virtual Machine Creation
**Date:** [Today's Date]

| Setting | Value |
| :--- | :--- |
| **VM Name** | AD-DC-01 |
| **OS Type** | Microsoft Windows |
| **OS Version** | Windows Server 2022 (64-bit) |
| **RAM Allocated** | 2048 MB (2 GB) |
| **Hard Disk Type** | VDI (VirtualBox Disk Image) |
| **Storage Type** | Dynamically allocated |
| **Hard Disk Size** | 40 GB |
| **File Location** | [VirtualBox default path] |

---

## 3.0 Windows Server Installation
*(We'll fill this in during the next steps)*

---

## 4.0 Active Directory Configuration
*(We'll fill this in later)*

---

## 5.0 Knowledge Base & Technical References

### Naming Conventions
- **AD-DC-01** follows standard enterprise naming:
  - **AD** = Active Directory server role
  - **DC** = Domain Controller function
  - **01** = First instance (allows for future expansion)

### Hardware Specifications & Justification

| Component | Microsoft Minimum | Our Lab | Status |
| :--- | :--- | :--- | :--- |
| **CPU** | 1.4 GHz | Virtualized | ✅ Meets requirement |
| **RAM** | 2 GB | 2,048 MB | ✅ Meets requirement (Bare minimum) |
| **Storage** | 32 GB | 40 GB | ✅ Exceeds requirement |

**Note:** 40 GB was chosen to provide breathing room beyond Microsoft's 32 GB minimum to avoid disk space warnings during installation and updates.

### Storage Configuration
- **VDI (VirtualBox Disk Image):** Native VirtualBox format
- **Dynamically allocated:** The VDI file starts at ~1 GB and grows as data is added, saving host disk space
- **Location:** VirtualBox default path in [Your Username]/VirtualBox VMs/

### Networking (Current Configuration)
- **Mode:** NAT (Network Address Translation)
- **Purpose:** Provides internet access for Windows updates during installation
- **Future Plan:** Will switch to Bridged mode when joining clients to the domain

### VirtualBox Networking Modes Reference

| Mode | Host-to-VM | VM-to-Internet | Use Case |
| :--- | :--- | :--- | :--- |
| **NAT** | ❌ No | ✅ Yes | Initial setup, internet access |
| **Bridged** | ✅ Yes | ✅ Yes | Production, domain joining |
| **Host-Only** | ✅ Yes | ❌ No | Isolated testing |

---

## 6.0 PowerShell Commands Reference
*(We'll add PowerShell equivalents for each task)*

---