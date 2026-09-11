# Architecture Documentation - AD Homelab

## Overview

This document describes the network topology, Active Directory structure, and Group Policy configuration for the Active Directory homelab project. The environment is virtualized on a single host machine using VirtualBox, and simulates a small corporate domain (`home.lab`) with three departments.

---

## Network Layout

```
┌─────────────────────────────────────────────────────────────────┐
│                          HOST MACHINE                             │
│                        (Your Computer)                            │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │                  VIRTUALBOX NETWORK                       │     │
│  │                                                             │     │
│  │   ┌─────────────────┐    ┌──────────────────────────┐   │     │
│  │   │    AD-DC-01      │    │       Win10-Client        │   │     │
│  │   │  (Server Core)   │    │       (Windows 10)        │   │     │
│  │   │                  │    │                            │   │     │
│  │   │ IP: 192.168.0.10 │    │ IP: DHCP/Bridged          │   │     │
│  │   │ Domain: home.lab │    │ Joined to home.lab        │   │     │
│  │   │ Role: DC, DNS    │    │                            │   │     │
│  │   └─────────────────┘    └──────────────────────────┘   │     │
│  │                                                             │     │
│  └─────────────────────────────────────────────────────────┘     │
│                                                                     │
│   Internet: 8.8.8.8 (Google DNS) / 1.1.1.1 (Cloudflare)          │
└─────────────────────────────────────────────────────────────────┘
```

### Components

| Component | Role | IP Configuration | Notes |
|---|---|---|---|
| **AD-DC-01** | Domain Controller, DNS Server | `192.168.0.10` (static) | Windows Server, installed as Server Core |
| **Win10-Client** | Domain-joined workstation | DHCP / Bridged | Windows 10, joined to `home.lab` |
| **Upstream DNS** | External resolution | `8.8.8.8`, `1.1.1.1` | Google and Cloudflare, used as forwarders |

All virtual machines run under VirtualBox on the host machine, connected via a shared internal/host-only network so the client and DC can communicate while the DC handles name resolution and authentication.

---

## Active Directory Structure

The domain `home.lab` is organized into three department-level Organizational Units (OUs), each containing a dedicated security group and its associated user accounts.

```
home.lab (Domain)
│
├── HR_Department (OU)
│   ├── HR_Staff (Security Group)
│   └── Users:
│       ├── sjohnson   (Sarah Johnson)
│       ├── mchen      (Michael Chen)
│       └── lrodriguez (Lisa Rodriguez)
│
├── IT_Department (OU)
│   ├── IT_Staff (Security Group)
│   └── Users:
│       ├── dkim      (David Kim)
│       ├── aturner   (Alex Turner)
│       └── rstevens  (Rachel Stevens)
│
└── Finance_Department (OU)
    ├── Finance_Staff (Security Group)
    └── Users:
        ├── ewatson    (Emma Watson)
        └── omartinez  (Olivia Martinez)
```

### OU / User Summary

| OU | Security Group | Users |
|---|---|---|
| HR_Department | HR_Staff | sjohnson, mchen, lrodriguez |
| IT_Department | IT_Staff | dkim, aturner, rstevens |
| Finance_Department | Finance_Staff | ewatson, omartinez |

---

## Group Policy Objects (GPOs)

| GPO Name | Linked To | Purpose |
|---|---|---|
| HR_Wallpaper_Policy | HR_Department | Sets desktop wallpaper |
| HR_Drive_Mapping | HR_Department | Maps H: drive to HR_Share |

---

## Design Notes

- The DC (`AD-DC-01`) runs Server Core to keep resource usage low and to practice server administration without a GUI.
- DNS is hosted on the DC itself, with `8.8.8.8` and `1.1.1.1` configured as forwarders for external name resolution.
- Departments are separated at the OU level to allow independent GPO application and delegation, mirroring how a real organization would structure its directory.
- Security groups (`HR_Staff`, `IT_Staff`, `Finance_Staff`) are used for permission and GPO targeting rather than applying policy directly to individual users.