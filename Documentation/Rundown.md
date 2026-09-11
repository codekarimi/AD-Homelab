# AD Homelab Runbook

**Author:** Clifford Karimi
**Project Start Date:** Sep 1st 2026
**Environment:** Windows Server 2022 Core (VirtualBox)

---

## 1.0 Session Log

| Date | Session | Completed | Next Session |
|---|---|---|---|
| Sep 1st 2026 | Session 1 | VM Creation, Windows Installation, Network Setup, Updates, AD DS Installation, Domain Promotion | Create OUs, Groups, Users |
| Sep 3rd 2026 | Session 2 | Created AD structure (OUs, Groups, 9 Users) | Help Desk Simulation |
| Sep 7th 2026 | Session 3 | Simulated Help Desk tickets | Join Windows 10 client to domain |
| Sep 9th 2026 | Session 4 | Joined Windows 10 client to home.lab domain | Group Policy Implementation |
| Sep 11th 2026 | Session 5 | Implemented Group Policy (Wallpaper + Drive Mapping) | Documentation & Scripts Polish |
| Sep 11th 2026 | Session 6 | Documentation & Scripts Polish | Project Complete! |

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
|---|---|---|
| Hypervisor | Oracle VirtualBox (Latest) | ✅ Installed |
| OS ISO | Windows Server 2022 Evaluation | ✅ Downloaded |
| Source | Microsoft Evaluation Center | ✅ Acquired |
| License | 180-day Evaluation | ✅ Active |

---

## 4.0 Virtual Machine Creation

**Date:** Sep 1st 2026

### 4.1 VM Specifications

| Setting | Value |
|---|---|
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
|---|---|
| **Username** | Administrator |
| **Password** | *********** |

---

## 6.0 Network Configuration

**Date:** Sep 1st 2026

### 6.1 Network Settings

| Setting | Value | Justification |
|---|---|---|
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
ping 8.8.8.8            # ✅ Internet reachable
ping google.com         # ✅ DNS resolution working
```

---

## 7.0 Windows Updates

**Date:** Sep 1st 2026

### 7.1 Update Details

- **Category:** All quality updates (Option 1)
- **Selection:** (A)ll updates
- **Method:** SConfig menu (Option 6)

### 7.2 Updates Installed

| Update ID | Description |
|---|---|
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
```

### 8.1 Verification Results

```powershell
Get-ADDomain
# ✅ Domain: home.lab
# ✅ Forest Mode: Windows Server 2022

Get-Service -Name NTDS
# ✅ Status: Running
```

---

## 9.0 Active Directory Structure

**Date:** Sep 3rd 2026

### Organizational Units (OUs)

| OU Name | Distinguished Name |
|---|---|
| HR_Department | OU=HR_Department,DC=home,DC=lab |
| IT_Department | OU=IT_Department,DC=home,DC=lab |
| Finance_Department | OU=Finance_Department,DC=home,DC=lab |

### Security Groups

| Group Name | Department | Type |
|---|---|---|
| HR_Staff | HR | Global Security Group |
| IT_Staff | IT | Global Security Group |
| Finance_Staff | Finance | Global Security Group |

### Users Created

| Full Name | Username | Department |
|---|---|---|
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
|---|---|
| HR_Staff | sjohnson, mchen, lrodriguez |
| IT_Staff | dkim, aturner, rstevens |
| Finance_Staff | ewatson, omartinez |

### PowerShell Commands Used

```powershell
# Create OUs
New-ADOrganizationalUnit -Name "HR_Department" -Path "DC=home,DC=lab"

# Create Groups
New-ADGroup -Name "HR_Staff" -GroupScope Global -GroupCategory Security -Path "OU=HR_Department,DC=home,DC=lab"

# Create User
New-ADUser -Name "Sarah Johnson" -SamAccountName sjohnson -Enabled $true -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force)

# Add to Group
Add-ADGroupMember -Identity "HR_Staff" -Members sjohnson
```

---

## 10.0 Help Desk Ticket Simulation

**Date:** Sep 7th 2026

### Tickets Resolved

| Ticket | Issue | Command | Status |
|---|---|---|---|
| #1 | Password Reset - sjohnson | Set-ADAccountPassword | ✅ Resolved |
| #2 | Account Unlock - dkim | Unlock-ADAccount | ✅ Resolved |
| #3 | Add to Group - aturner to IT_Staff | Add-ADGroupMember | ✅ Resolved |
| #4 | Remove from Group - ewatson from Finance_Staff | Remove-ADGroupMember | ✅ Resolved |
| #5 | Disable Account - jobrien | Disable-ADAccount | ✅ Resolved |
| #6 | Enable Account - jobrien | Enable-ADAccount | ✅ Resolved |
| #7 | Check User Status - sjohnson | Get-ADUser | ✅ Resolved |
| #8 | Move User - sjohnson to IT | Move-ADObject | ✅ Resolved |
| #9 | Update User Info - mchen | Set-ADUser | ✅ Resolved |

### Commands Used

```powershell
# Password Reset
Set-ADAccountPassword -Identity sjohnson -Reset -NewPassword (ConvertTo-SecureString "NewP@ssw0rd123!" -AsPlainText -Force)

# Account Unlock
Unlock-ADAccount -Identity dkim

# Add to Group
Add-ADGroupMember -Identity "IT_Staff" -Members aturner

# Remove from Group
Remove-ADGroupMember -Identity "Finance_Staff" -Members ewatson -Confirm:$false

# Disable Account
Disable-ADAccount -Identity jobrien

# Enable Account
Enable-ADAccount -Identity jobrien

# Check User Status
Get-ADUser -Identity sjohnson -Properties LockedOut, Enabled, PasswordLastSet

# Move User
Move-ADObject -Identity "CN=Sarah Johnson,OU=HR_Department,DC=home,DC=lab" -TargetPath "OU=IT_Department,DC=home,DC=lab"

# Update User Info
Set-ADUser -Identity mchen -Title "Senior HR Specialist" -Department "Human Resources"
```

---

## 11.0 Windows 10 Client Join

**Date:** Sep 9th 2026

### Client Specifications

| Setting | Value |
|---|---|
| VM Name | Win10-Client |
| OS | Windows 10 (64-bit) |
| RAM | 4096 MB (4 GB) |
| Hard Disk | 50 GB (VDI, Dynamically allocated) |
| Network | Bridged Mode |

### DNS Configuration

| Setting | Value |
|---|---|
| Preferred DNS | 192.168.0.10 (DC) |
| Alternate DNS | 8.8.8.8 (Google) |

### Domain Join Details

| Setting | Value |
|---|---|
| Domain | home.lab |
| Admin Credentials | HOMELAB\Administrator |
| Test User | HOMELAB\sjohnson |

### Verification

```powershell
whoami
# ✅ home\sjohnson

Get-ADUser -Identity sjohnson
# ✅ User details displayed
```

---

## 12.0 Group Policy Implementation

**Date:** Sep 11th 2026

### GPOs Created

| GPO Name | Purpose | Status |
|---|---|---|
| HR_Wallpaper_Policy | Sets desktop wallpaper for HR Department | ✅ Created & Linked |
| HR_Drive_Mapping | Maps H: drive to HR_Share | ✅ Created & Linked |

### Commands Used

```powershell
# Create GPO
New-GPO -Name "HR_Wallpaper_Policy" -Comment "Sets desktop wallpaper for HR Department"

# Configure Wallpaper
Set-GPRegistryValue -Name "HR_Wallpaper_Policy" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "Wallpaper" -Type String -Value "C:\Windows\Web\Wallpaper\Windows\img0.jpg"

# Configure Wallpaper Style
Set-GPRegistryValue -Name "HR_Wallpaper_Policy" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "WallpaperStyle" -Type String -Value "2"

# Link GPO to OU
New-GPLink -Name "HR_Wallpaper_Policy" -Target "OU=HR_Department,DC=home,DC=lab" -LinkEnabled Yes

# View GPOs
Get-GPO -All | Format-Table DisplayName, CreationTime

# Force update on client
gpupdate /force
```

### Drive Mapping Configuration

| Setting | Value |
|---|---|
| Share Name | HR_Share |
| Share Path | C:\HR_Share |
| Drive Letter | H: |
| GPO Name | HR_Drive_Mapping |
| Target OU | HR_Department |

### Verification

- ✅ GPOs created successfully
- ✅ GPOs linked to HR_Department OU
- ✅ Wallpaper applied on Windows 10 client
- ✅ Drive mapping configured

### GPO Management Commands Reference

| Command | Purpose |
|---|---|
| `New-GPO -Name "GPO_Name"` | Create new GPO |
| `Set-GPRegistryValue` | Set registry policy |
| `New-GPLink` | Link GPO to OU |
| `Get-GPO -All` | List all GPOs |
| `gpupdate /force` | Force policy update on client |
| `gpresult /r` | View applied GPOs |

---

## 13.0 Documentation

**Date:** Sep 11th 2026

### Files Created

| File | Purpose |
|---|---|
| Documentation/Runbook.md | Complete project runbook |
| Documentation/Architecture_Diagram.md | Network and AD structure |
| Documentation/Troubleshooting_Guide.md | Common issues and fixes |
| Templates/GitHub_Commit_Message_Template.md | Commit message templates |
| Templates/Daily_Progress_Log.md | Daily progress tracking |
| Templates/Interview_Questions.md | Common AD interview Q&A |
| Templates/Runbook_Template.md | Blank runbook template |

### Scripts Created

| Script | Purpose |
|---|---|
| Scripts/New-OU.ps1 | Create Organizational Units |
| Scripts/New-SecurityGroup.ps1 | Create Security Groups |
| Scripts/New-ADUser.ps1 | Create AD User |