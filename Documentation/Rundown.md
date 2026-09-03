# AD Homelab Runbook
**Author:** Clifford Karimi
**Project Start Date:** Sep 1st 2026
**Environment:** Windows Server 2022 Core (VirtualBox)

---

## 1.0 Session Log

| Date | Session | Completed | Next Session |
|------|---------|-----------|--------------|
| Sep 1st 2026 | Session 1 | VM Creation, Windows Installation, Network Setup, Updates, AD DS Installation, Domain Promotion | Create OUs, Groups, Users |
---

## 2.0 Project Overview

### 2.1 What Is Server Core?
Server Core is a minimal installation of Windows Server with no GUI (no Desktop, Start Menu, or File Explorer). It is managed via PowerShell and SConfig.

**Why Server Core:**
- Industry standard for enterprise servers
- Forces PowerShell skill development
- Uses 2-4x less RAM than Desktop Experience
- Smaller attack surface
- Fewer patches required

### 2.2 What We Can Do With Server Core
- ✅ Active Directory Domain Controller
- ✅ DNS Server
- ✅ User/Group Management
- ✅ Group Policy
- ✅ File/Print Services

---

## 3.0 Prerequisites

| Item | Version | Status |
|------|---------|--------|
| Hypervisor | Oracle VirtualBox (Latest) | ✅ Installed |
| OS ISO | Windows Server 2022 Evaluation | ✅ Downloaded |
| Source | Microsoft Evaluation Center | ✅ Acquired |
| License | 180-day Evaluation | ✅ Active |

---

## 4.0 Virtual Machine Creation

**Date:** Sep 1st 2026

### 4.1 VM Specifications

| Setting | Value |
|---------|-------|
| **VM Name** | HomelaB |
| **OS Type** | Microsoft Windows |
| **OS Version** | Windows Server 2022 (64-bit) |
| **RAM** | 2048 MB (2 GB) |
| **Hard Disk Type** | VDI (VirtualBox Disk Image) |
| **Storage Type** | Dynamically allocated |
| **Hard Disk Size** | 40 GB |
| **ISO** | [Path to downloaded ISO] |

### 4.2 Creation Steps
1. VM named: HomelaB
2. OS: Windows Server 2022 (64-bit)
3. RAM: 2048 MB
4. Hard Disk: VDI → Dynamically allocated → 40 GB

---

## 5.0 Windows Server Installation

**Date:** Sep 1st 2026

### 5.1 Installation Process
1. Booted from Windows Server 2022 ISO
2. Installation Type: Custom (Advanced)
3. Disk: Unallocated 40 GB selected
4. Windows Server 2022 Standard Evaluation installed
5. First boot → SConfig menu displayed

### 5.2 Administrator Password

| Credential | Value |
|------------|-------|
| **Username** | Administrator |
| **Password** | *********** |

---

## 6.0 Network Configuration

**Date:** Sep 1st 2026

### 6.1 Network Settings

| Setting | Value | Justification |
|---------|-------|---------------|
| **IP Address** | 192.168.0.10 | Static IP required for DC |
| **Subnet Mask** | 255.255.255.0 | Default /24 network |
| **Default Gateway** | (None) | Lab environment |
| **Primary DNS** | 8.8.8.8 | Google DNS |
| **Secondary DNS** | 1.1.1.1 | Cloudflare DNS |
| **Network Mode** | NAT | Initial setup |

### 6.2 Why Static IP?
Domain Controllers require static IPs. DHCP would break domain authentication if the IP changed.

### 6.3 Verification
```powershell
ipconfig /all          # ✅ IP: 192.168.0.10 confirmed
ping 8.8.8.8          # ✅ Internet reachable
ping google.com       # ✅ DNS resolution working


---

## 7.0 Windows Updates

**Date:** Sep 1st 2026

### 7.1 Update Details
- **Category:** All quality updates (Option 1)
- **Selection:** (A)ll updates
- **Method:** SConfig menu (Option 6)

### 7.2 Updates Installed

| Update ID | Description |
|-----------|-------------|
| KB5010475 | .NET Framework 3.5/4.8 Cumulative Update |
| KB5121650 | .NET Framework 3.5/4.8/4.8.1 Cumulative Update |
| KB2267602 | Microsoft Defender Antivirus Intelligence Update |
| KB5032198 | Windows Server 21H2 Cumulative Update |

### 7.3 Update Status
- **Status:** ✅ Completed
- **Reboot:** ✅ Performed

---

## 8.0 Active Directory Domain Services Installation & Promotion

**Date:** Sep 1st 2026

### Step 1: AD DS Installation & Promotion
```powershell

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -DomainName "home.lab" -InstallDNS -Force



### 8.1 Verification Results
```powershell
Get-ADDomain
# ✅ Domain: home.lab
# ✅ Forest Mode: Windows Server 2022

Get-Service -Name NTDS
# ✅ Status: Running

**Date:** Sep 3rd 2026

### Organizational Units (OUs)
| OU Name | Distinguished Name |
|---------|-------------------|
| HR_Department | OU=HR_Department,DC=home,DC=lab |
| IT_Department | OU=IT_Department,DC=home,DC=lab |
| Finance_Department | OU=Finance_Department,DC=home,DC=lab |

### Security Groups
| Group Name | Department | Type |
|------------|-----------|------|
| HR_Staff | HR | Global Security Group |
| IT_Staff | IT | Global Security Group |
| Finance_Staff | Finance | Global Security Group |

### Users Created
| Full Name | Username | Department |
|-----------|----------|------------|
| Sarah Johnson | sjohnson | HR |
| Michael Chen | mchen | HR |
| Lisa Rodriguez | lrodriguez | HR |
| David Kim | dkim | IT |
| Alex Turner | aturner | IT |
| Rachel Stevens | rstevens | IT |
| Emma Watson | ewatson | Finance |
| Olivia Martinez | omartinez | Finance |

### Group Memberships
| Group | Members |
|-------|---------|
| HR_Staff | sjohnson, mchen, lrodriguez |
| IT_Staff | dkim, aturner, rstevens |
| Finance_Staff | ewatson, jobrien, omartinez |