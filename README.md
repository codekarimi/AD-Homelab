# 🛡️ Active Directory Homelab — Enterprise Identity Infrastructure

![Windows Server](https://img.shields.io/badge/Windows_Server-2022-0078D6?style=flat-square&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![VirtualBox](https://img.shields.io/badge/VirtualBox-183A61?style=flat-square&logo=virtualbox&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-DS%2FDNS%2FGPO-orange?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)

A fully functional Active Directory domain — built, populated, and administered from a Server Core install, with a simulated Help Desk workflow and Group Policy rollout to a domain-joined client.

---

## Project Overview

This project simulates a small business IT environment: a Windows Server 2022 Domain Controller running Server Core (no GUI), managing users, groups, and policy for three departments, with a Windows 10 client joined to the domain. The goal was to build real, defensible sysadmin experience — not just click through a GUI, but administer everything the way it's done in production: via PowerShell.

| Detail | Value |
|---|---|
| Domain Name | `home.lab` |
| Domain Controller | `AD-DC-01` (Windows Server 2022 Core) |
| DC IP Address | `192.168.0.10` (static) |
| Hypervisor | Oracle VirtualBox |
| Client | Windows 10 (domain-joined) |
| Build Time | 6 sessions over 11 days |

---

## Architecture

### Active Directory Structure

```
home.lab (Domain)
│
├── HR_Department (OU)
│   ├── HR_Staff (Security Group)
│   └── Users: sjohnson, mchen, lrodriguez
│
├── IT_Department (OU)
│   ├── IT_Staff (Security Group)
│   └── Users: dkim, aturner, rstevens
│
└── Finance_Department (OU)
    ├── Finance_Staff (Security Group)
    └── Users: ewatson, omartinez
```

### Network Layout

| Component | IP / Config | Role |
|---|---|---|
| AD-DC-01 | `192.168.0.10` (static) | Domain Controller, DNS |
| Win10-Client | DHCP / Bridged | Domain-joined workstation |
| DNS Forwarders | `8.8.8.8`, `1.1.1.1` | External resolution |

---

## What Was Built

| Day | Focus | Outcome |
|---|---|---|
| Day 1 | Foundation | Built the DC VM, installed Windows Server Core, configured static networking, applied updates, installed AD DS, and promoted to domain controller |
| Day 2 | Directory Structure | Created 3 OUs, 3 security groups, and 8 users across HR, IT, and Finance |
| Day 3 | Help Desk Simulation | Resolved 9 simulated tickets — password resets, account lockouts, group changes, and account moves |
| Day 4 | Client Integration | Joined a Windows 10 VM to the `home.lab` domain and verified authentication |
| Day 5 | Group Policy | Built and linked GPOs for desktop wallpaper and drive mapping to the HR OU |
| Day 6 | Documentation | Wrote the runbook, architecture diagram, troubleshooting guide, and supporting scripts |

---

## Skills Demonstrated

**Core Infrastructure**
- Active Directory Domain Services installation and forest promotion
- DNS configuration and forwarding
- Server Core administration (CLI-only, no GUI)
- Static IP and network configuration for domain controllers

**Identity & Access Management**
- OU, security group, and user account design
- Account lifecycle management (create, disable, enable, unlock, move)
- Group-based access control

**Automation**
- PowerShell-driven AD administration (no GUI tools used)
- Reusable scripts for OU, group, and user creation

**Policy & Client Management**
- Group Policy Object creation and OU linking
- Registry-based policy configuration (wallpaper, drive mapping)
- Domain client join and policy verification (`gpupdate`, `gpresult`)

**Documentation**
- Runbook-style technical documentation
- Architecture diagramming
- Troubleshooting guide authored from real issues encountered

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Windows Server 2022 (Core) | Domain Controller OS |
| Windows 10 | Domain-joined client |
| Oracle VirtualBox | Virtualization platform |
| PowerShell | All AD DS, GPO, and account administration |
| Active Directory Domain Services | Directory, authentication |
| DNS Server | Name resolution |
| Group Policy Management | Policy deployment |

---

## Project Structure

```
ad-homelab/
├── README.md
├── Documentation/
│   ├── Runbook.md                  # Full session-by-session build log
│   ├── Architecture_Diagram.md     # Network and AD structure
│   └── Troubleshooting_Guide.md    # Issues encountered and fixes
├── Templates/
│   ├── GitHub_Commit_Message_Template.md
│   ├── Daily_Progress_Log.md
│   ├── Interview_Questions.md
│   └── Runbook_Template.md
└── Scripts/
    ├── New-OU.ps1                  # Creates Organizational Units
    ├── New-SecurityGroup.ps1       # Creates Security Groups
    └── New-ADUser.ps1              # Creates AD User accounts
```

---

## Key Commands Reference

```powershell
# Promote server to Domain Controller
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "home.lab" -InstallDNS -Force

# Create an OU, group, and user (scripted structure)
New-ADOrganizationalUnit -Name "HR_Department" -Path "DC=home,DC=lab"
New-ADGroup -Name "HR_Staff" -GroupScope Global -GroupCategory Security -Path "OU=HR_Department,DC=home,DC=lab"
New-ADUser -Name "Sarah Johnson" -SamAccountName sjohnson -Enabled $true `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force)

# Help Desk: unlock account and check status
Unlock-ADAccount -Identity dkim
Get-ADUser -Identity sjohnson -Properties LockedOut, Enabled, PasswordLastSet

# Deploy Group Policy to an OU
New-GPO -Name "HR_Wallpaper_Policy" -Comment "Sets desktop wallpaper for HR Department"
New-GPLink -Name "HR_Wallpaper_Policy" -Target "OU=HR_Department,DC=home,DC=lab" -LinkEnabled Yes
```

---

## Screenshots

*Screenshots to be added.* Recommended captures for maximum impact:

- `Get-ADDomain` output confirming the promoted domain controller
- Active Directory Users and Computers (or `Get-ADUser`) showing the OU/group structure
- A resolved Help Desk ticket (before/after command output)
- The Windows 10 client showing the mapped `H:` drive and applied wallpaper after `gpupdate /force`
- `gpresult /r` output confirming policy application on the client

---

## Documentation

- [Runbook](Documentation/Runbook.md) — full session-by-session build log with commands and verification steps
- [Architecture Diagram](Documentation/Architecture_Diagram.md) — network layout and AD structure
- [Troubleshooting Guide](Documentation/Troubleshooting_Guide.md) — real issues encountered and their fixes

---

## What I Learned

- Server Core forces you to actually know PowerShell — there's no GUI to fall back on, and that changed how comfortable I am at a command line.
- Static IP configuration isn't optional for a DC — I saw firsthand how DHCP would have broken authentication if the DC's address had changed.
- Writing the troubleshooting guide *after* hitting the errors, not before, made it far more useful — every entry came from something that actually broke.
- Group Policy takes more than just creating and linking a GPO — verifying it actually applied (`gpresult /r`) turned out to be its own skill.
- Documenting as I went (session logs, not a single write-up at the end) made the final runbook far more accurate than trying to reconstruct it from memory would have been.

---

## Future Improvements

- Add a DHCP server role and move the client off static/bridged networking
- Set up file shares with NTFS + share permissions beyond the single drive mapping
- Add a second domain controller for redundancy and replication practice
- Configure Azure AD Connect for hybrid identity
- Expand GPOs to cover password policy, screen lock, and software restriction
- Add centralized logging (Windows Event Forwarding) for the domain

---

## Connect With Me

- GitHub: [codekarimi](https://github.com/codekarimi/)
- LinkedIn: [Clifford Karimi](www.linkedin.com/in/clifford-karimi)